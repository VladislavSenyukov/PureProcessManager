//
//  PPProcessListWindowController.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPProcessListWindowController.h"
#import "PPProcessListViewController.h"
#import "Autolayout.h"

@interface PPProcessListWindowController ()
@property (nonatomic, strong) PPProcessListViewController *processListVC;
@end

@implementation PPProcessListWindowController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    PPProcessListViewController *vc = [[PPProcessListViewController alloc] initWithNibName:@"PPProcessListViewController" bundle:[NSBundle mainBundle]];
    NSView *view = vc.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.window.contentView addSubview:view];
    [view addSuperviewSizedConstraints];
    self.processListVC = vc;
}

@end
