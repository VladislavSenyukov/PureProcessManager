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
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval target:self selector:@selector(fetchProcessList) userInfo:nil repeats:YES];
}

- (void)stopUpdatingProcessList {
    [self.updateTimer invalidate];
}

#pragma mark - Private

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
