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
@property (nonatomic, weak) IBOutlet NSTableView *processListTableView;
@property (nonatomic, strong) IBOutlet NSArrayController *datasourceController;
@end

@implementation PPProcessListViewController

#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PPAppFacade shared] startPeriodicProcessListUpdatesWithCompletion:^(NSArray<PPProcessInfo *> *processList) {
        self.datasourceController.content = processList;
    }];
}

@end
