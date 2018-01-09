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
#import "PPSettingsManager.h"

@interface PPAppFacade() <PPProcessManagerDelegate>
@property (nonatomic, strong) PPProcessManager *processManager;
@property (nonatomic, strong) PPSettingsManager *settingsManager;
@property (nonatomic, copy) PPProcessListDidUpdateCompletion processListCompletion;
@end

@implementation PPAppFacade

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

#pragma mark - Overrides

- (instancetype)init {
    self = [super init];
    _settingsManager = [PPSettingsManager new];
    _processManager = [PPProcessManager new];
    _processManager.delegate = self;
    [self copyPrefPaneToPanesDirectoryIfNeeded];
    [self updateProcessManager:_processManager withSettings:_settingsManager];
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(onPrefPaneDidUpdate:) name:PPPrefPaneSettingsDidUpdate object:nil suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];
    return self;
}

#pragma mark - Observers

- (void)onPrefPaneDidUpdate:(NSNotification*)notification {
    self.settingsManager = [PPSettingsManager new];
    PPProcessManager *processManager = self.processManager;
    [self updateProcessManager:processManager withSettings:self.settingsManager];
    [processManager stopUpdatingProcessList];
    [processManager startUpdatingProcessList];
}

#pragma mark - PPProcessManagerDelegate

- (void)processManager:(PPProcessManager *)processManager didUpdateWithProcessList:(NSArray<PPProcessInfo *> *)processList {
    if (self.processListCompletion) {
        self.processListCompletion(processList);
    }
}

#pragma mark - Private

- (void)copyPrefPaneToPanesDirectoryIfNeeded {
    NSString *panesDirectory = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *paneBundlePath = [[NSBundle mainBundle] pathForResource:@"PureProcessManagerPrefPane" ofType:@"prefPane"];
    NSString *paneFilename = paneBundlePath.lastPathComponent;
    NSString *panePath = [panesDirectory stringByAppendingPathComponent:paneFilename];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:panePath]) {
        [fm copyItemAtPath:paneBundlePath toPath:panePath error:nil];
    }
}

- (void)updateProcessManager:(PPProcessManager*)manager withSettings:(PPSettingsManager*)settings {
    manager.updateInterval = settings.updateRate;
    manager.showOwnerProcessesOnly = settings.showOwnerProcessesOnly;
}

@end
