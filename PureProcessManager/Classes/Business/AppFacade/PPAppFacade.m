//
//  PPAppFacade.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPAppFacade.h"
#import <AppKit/AppKit.h>
#import "PPProcessManager.h"

@interface PPAppFacade() <PPProcessManagerDelegate>
@property (nonatomic, strong) PPProcessManager *processManager;
@property (nonatomic, copy) PPProcessListDidUpdateCompletion processListCompletion;
@end

@implementation PPAppFacade

@dynamic processListUpdateRate;

#pragma mark - Public

+ (instancetype)shared {
    id instance = nil;
    if ([NSApp.delegate conformsToProtocol:@protocol(PPFacadeRetainable)]) {
        NSObject<PPFacadeRetainable> *facadeRetainer = (NSObject<PPFacadeRetainable> *)NSApp.delegate;
        instance = facadeRetainer.facade;
    }
    return instance;
}

- (void)startPeriodicProcessListUpdatesWithCompletion:(PPProcessListDidUpdateCompletion)completion {
    self.processListCompletion = completion;
    [self.processManager startUpdatingProcessList];
}

- (void)killProcess:(PPProcessInfo *)info completion:(PPErrorCompletion)completion {
    [self.processManager killProcessWithInfo:info completion:completion];
}

- (void)setProcessListUpdateRate:(NSTimeInterval)processListUpdateRate {
    self.processManager.updateInterval = processListUpdateRate;
}

- (NSTimeInterval)processListUpdateRate {
    return self.processManager.updateInterval;
}

#pragma mark - PPProcessManagerDelegate

- (void)processManager:(PPProcessManager *)processManager didUpdateWithProcessList:(NSArray<PPProcessInfo *> *)processList {
    if (self.processListCompletion) {
        self.processListCompletion(processList);
    }
}

#pragma mark - Accessors

- (PPProcessManager *)processManager {
    if (!_processManager) {
        _processManager = [PPProcessManager new];
        _processManager.delegate = self;
    }
    return _processManager;
}

@end
