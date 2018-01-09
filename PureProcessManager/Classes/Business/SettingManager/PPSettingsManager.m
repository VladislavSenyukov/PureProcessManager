//
//  PPSettingsManager.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 09.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPSettingsManager.h"
#import "PPDefinitions.h"
#import <AppKit/AppKit.h>

@implementation PPSettingsManager

- (instancetype)init {
    self = [super init];
    [self fetchShowOwnerProcessesOnly];
    [self fetchUpdateRate];
    return self;
}

#pragma mark - Public

- (void)setShowOwnerProcessesOnly:(BOOL)showOwnerProcessesOnly {
    if (_showOwnerProcessesOnly != showOwnerProcessesOnly) {
        _showOwnerProcessesOnly = showOwnerProcessesOnly;
        CFBooleanRef on = showOwnerProcessesOnly ? kCFBooleanTrue : kCFBooleanFalse;
        [self savePrefValue:on forKey:[self showOwnerProcessesOnlyKey]];
    }
}

- (void)setUpdateRate:(NSTimeInterval)updateRate {
    if (!updateRate) {
        updateRate = PPProcessListDefaultUpdateRate;
    }
    if (_updateRate != updateRate) {
        _updateRate = updateRate;
        CFStringRef rateValue = (__bridge CFStringRef)[NSString stringWithFormat:@"%f", updateRate];
        [self savePrefValue:rateValue forKey:[self updateRateKey]];
    }
}

#pragma mark - Private

- (void)fetchShowOwnerProcessesOnly {
    CFPropertyListRef value = CFPreferencesCopyAppValue([self showOwnerProcessesOnlyKey], [self appId]);
    BOOL show = PPProcessListDefaultShowOwnersProcessesOnly;
    if (value && CFGetTypeID(value) == CFBooleanGetTypeID()) {
        show = CFBooleanGetValue(value);
    }
    if (value) {
        CFRelease(value);
    }
    _showOwnerProcessesOnly = show;
}

- (void)fetchUpdateRate {
    CFPropertyListRef value = CFPreferencesCopyAppValue([self updateRateKey], [self appId]);
    NSTimeInterval updateRate = 0;
    if (value && CFGetTypeID(value) == CFStringGetTypeID()) {
        updateRate = [(__bridge NSString*)value doubleValue];
    }
    if (value) {
        CFRelease(value);
    }
    if (!updateRate) {
        updateRate = PPProcessListDefaultUpdateRate;
    }
    _updateRate = updateRate;
    
}

- (void)savePrefValue:(CFPropertyListRef)value forKey:(CFStringRef)key {
    CFStringRef appId = [self appId];
    CFPreferencesSetAppValue(key, value, appId);
    CFPreferencesAppSynchronize(appId);
    
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:PPPrefPaneSettingsDidUpdate object:nil userInfo:nil deliverImmediately:YES];
}

- (CFStringRef)appId {
    return CFSTR("com.ruckef.PureProcessManagerPrefPane");
}

- (CFStringRef)showOwnerProcessesOnlyKey {
    return CFSTR("Show Owner Processes Only Key");
}

- (CFStringRef)updateRateKey {
    return CFSTR("Update Rate Key");
}

@end
