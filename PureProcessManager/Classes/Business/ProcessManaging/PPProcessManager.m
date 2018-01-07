//
//  PPProcessManager.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPProcessManager.h"
#import "PPProcessFetcher.h"

@interface PPProcessManager()
@property (nonatomic, weak) NSTimer *updateTimer;
@end

@implementation PPProcessManager

#pragma mark - Overrides

- (instancetype)init {
    self = [super init];
    _updateInterval = 3.0;
    _callbackQueue = dispatch_get_main_queue();
    return self;
}

#pragma mark - Public

- (void)startUpdatingProcessList {
    [self fetchProcessList];
    [self startUpdateTimer];
}

- (void)stopUpdatingProcessList {
    [self stopUpdateTimer];
}

- (void)killProcessWithInfo:(PPProcessInfo *)info {
    if (info) {
        int result = kill(info.processID.intValue, SIGTERM);
        if (result == EPERM) {
            NSLog(@"The process does not have permission to send the signal to any of the target processes.");
        }
    }
}

#pragma mark - Private

- (void)startUpdateTimer {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval
                                                            target:self
                                                          selector:@selector(fetchProcessList)
                                                          userInfo:nil
                                                           repeats:YES];
}

- (void)stopUpdateTimer {
    [self.updateTimer invalidate];
}

- (void)fetchProcessList {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *list = [PPProcessFetcher fetchAllSystemProcesses];
        dispatch_async(self.callbackQueue, ^{
            if ([self.delegate respondsToSelector:@selector(processManager:didUpdateWithProcessList:)]) {
                [self.delegate processManager:self didUpdateWithProcessList:list];
            }
        });
    });
}

@end
