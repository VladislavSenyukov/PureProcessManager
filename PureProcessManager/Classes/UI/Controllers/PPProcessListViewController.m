//
//  PPProcessListViewController.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPProcessListViewController.h"
#import "PPAppFacade.h"

@interface PPProcessListViewController ()
@property (nonatomic, strong) IBOutlet NSArrayController *datasourceController;
@end

@implementation PPProcessListViewController

#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AppFacadeShared startPeriodicProcessListUpdatesWithCompletion:^(NSArray<PPProcessInfo *> *processList) {
        self.datasourceController.content = processList.mutableCopy;
    }];
}

- (IBAction)killProcessSelected:(NSNumber*)selectionIdx {
    PPProcessInfo *selectedInfo = [self.datasourceController.content objectAtIndex:selectionIdx.unsignedIntegerValue];
    [self killProcessWithInfo:selectedInfo];
}

- (void)keyDown:(NSEvent *)event {
    NSUInteger selectionIdx = self.datasourceController.selectionIndex;
    if (selectionIdx != NSNotFound &&
        [[event charactersIgnoringModifiers] characterAtIndex:0] == NSDeleteCharacter) {
        PPProcessInfo *selectedInfo = [self.datasourceController.content objectAtIndex:selectionIdx];
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Process kill";
        alert.informativeText = [NSString stringWithFormat:@"Are you sure you want to kill %@?", selectedInfo.processName];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        NSModalResponse result = [alert runModal];
        if (result == NSAlertFirstButtonReturn) {
            [self killProcessWithInfo:selectedInfo];
        }
    }
}

#pragma mark - Private

- (void)killProcessWithInfo:(PPProcessInfo*)info {
    [AppFacadeShared killProcess:info completion:^(NSError *error) {
        if (!error) {
            [self.datasourceController removeObject:info];
        } else {
            NSAlert *alert = [NSAlert new];
            alert.messageText = @"Error";
            alert.informativeText = error.localizedDescription;
            [alert addButtonWithTitle:@"OK"];
            [alert runModal];
        }
    }];
}

@end
