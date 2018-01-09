//
//  PureProcessManagerPrefPane.m
//  PureProcessManagerPrefPane
//
//  Created by Vladislav Senyukov on 08.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PureProcessManagerPrefPane.h"
#import "PPSettingsManager.h"
#import "PPIntegerFormatter.h"

@interface PureProcessManagerPrefPane ()
@property (nonatomic, strong) PPSettingsManager *settings;
@property (nonatomic, weak) IBOutlet NSButton *showOwnerProcessesCheckbox;
@property (nonatomic, weak) IBOutlet NSTextField *updateRateField;
@end

@implementation PureProcessManagerPrefPane

- (void)mainViewDidLoad {
    self.updateRateField.formatter = [PPIntegerFormatter new];
    PPSettingsManager *settings = [PPSettingsManager new];
    self.showOwnerProcessesCheckbox.state = settings.showOwnerProcessesOnly;
    self.updateRateField.stringValue = [NSString stringWithFormat:@"%d", (int)settings.updateRate];
    self.settings = settings;
}

- (IBAction)displayOnlyOwnersProcessedSelected:(NSButton*)sender {
    self.settings.showOwnerProcessesOnly = sender.state;
}

- (void)controlTextDidChange:(NSNotification *)notification {
    if (notification.object == self.updateRateField) {
        self.settings.updateRate = [self.updateRateField.stringValue doubleValue];
    }
}

#pragma mark - Private

- (void)logMessage:(NSString*)message {
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"info";
    alert.informativeText = message;
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

@end
