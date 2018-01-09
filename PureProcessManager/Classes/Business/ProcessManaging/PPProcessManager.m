//
//  PPProcessManager.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPProcessManager.h"
#import "PPProcessFetcher.h"
#import "PPAuthorizationManager.h"
#import "PPAuthorizedTask.h"
#import "PPDefinitions.h"

@interface PPProcessManager()
@property (nonatomic, weak) NSTimer *updateTimer;
@property (nonatomic, strong) dispatch_queue_t managerQueue;
@property (nonatomic, strong) PPAuthorizationManager *authManager;
@end

@implementation PPProcessManager

#pragma mark - Overrides

- (instancetype)init {
    self = [super init];
    _updateInterval = PPProcessListDefaultUpdateRate;
    _callbackQueue = dispatch_get_main_queue();
    _managerQueue = dispatch_queue_create("com.ruckef.PPProcessManager", DISPATCH_QUEUE_SERIAL);
    _authManager = [PPAuthorizationManager new];
    return self;
}

#pragma mark - Public

- (void)startUpdatingProcessList {
    [self fetchProcessList];
    [self startUpdateTimerWithInterval:self.updateInterval];
}

- (void)stopUpdatingProcessList {
    [self stopUpdateTimer];
}

- (void)killProcessWithInfo:(PPProcessInfo *)info completion:(PPErrorCompletion)completion {
    if (info) {
        dispatch_async(self.managerQueue, ^{
            __weak __typeof(self) wself = self;
            [self.authManager acquireExecuteRight:^(PPAuthorizedRight *right, NSError *error) {
                NSError *resultError = error; // save an autorization error if present
                if (right) {
                    PPAuthorizedTask *killTask = [PPAuthorizedTask new];
                    killTask.toolPath = @"/bin/kill";
                    int pid = info.processID.intValue;
                    NSString *pidString = [NSString stringWithFormat:@"%d", pid];
                    killTask.arguments = @[@"-s", @"kill", pidString];
                    killTask.authRight = right;
                    
                    // if a target process is OS kernel or the task execution failed
                    if (pid == 0 || [killTask launch] != errAuthorizationSuccess) {
                        resultError = [wself lanchError]; // create a launch error
                    }
                }
                dispatch_async(wself.callbackQueue, ^{
                    if (completion) {
                        completion(resultError);
                    }
                });
            }];
        });
    }
}

- (void)setUpdateInterval:(NSTimeInterval)updateInterval {
    if (_updateInterval != updateInterval) {
        _updateInterval = updateInterval;
        [self stopUpdateTimer];
        [self startUpdateTimerWithInterval:updateInterval];
    }
}

#pragma mark - Private

- (void)startUpdateTimerWithInterval:(NSTimeInterval)interval {
    if (!interval) {
        interval = PPProcessListDefaultUpdateRate;
    }
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                        target:self
                                                      selector:@selector(fetchProcessList)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)stopUpdateTimer {
    [self.updateTimer invalidate];
}

- (void)fetchProcessList {
    dispatch_async(self.managerQueue, ^{
        NSArray *list = [PPProcessFetcher fetchProcessesForOwnerOnly:self.showOwnerProcessesOnly];
        dispatch_async(self.callbackQueue, ^{
            if ([self.delegate respondsToSelector:@selector(processManager:didUpdateWithProcessList:)]) {
                [self.delegate processManager:self didUpdateWithProcessList:list];
            }
        });
    });
}

- (NSError*)lanchError {
    return [NSError errorWithDomain:PPAuthorizedTaskErrorDomain
                               code:PPErrorCodeTaskExecutionFailed
                           userInfo:@{NSLocalizedDescriptionKey : @"The task has failed to execute."}];
}

@end
