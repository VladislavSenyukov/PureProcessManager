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
    
    AppFacadeShared.processListUpdateRate = 10;
    [AppFacadeShared startPeriodicProcessListUpdatesWithCompletion:^(NSArray<PPProcessInfo *> *processList) {
        self.datasourceController.content = processList.mutableCopy;
    }];
}

- (IBAction)killProcessSelected:(NSNumber*)selectionIdx {
    NSUInteger idx = selectionIdx.unsignedIntegerValue;
    PPProcessInfo *selectedInfo = [self.datasourceController.content objectAtIndex:idx];
    [AppFacadeShared killProcess:selectedInfo completion:^(NSError *error) {
        if (!error) {
            [self.datasourceController removeObject:selectedInfo];
        } else {
            [self showAlertWithError:error];
        }
    }];
}

#pragma mark - Private

- (void)showAlertWithError:(NSError*)error {
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"Error";
    alert.informativeText = error.localizedDescription;
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

@end
