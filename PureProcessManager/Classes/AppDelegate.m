//
//  AppDelegate.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "AppDelegate.h"
#import "PPProcessListWindowController.h"

@interface AppDelegate ()
@property (nonatomic, weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet PPProcessListWindowController *processListWC;
@end

@implementation AppDelegate

@synthesize facade = _facade;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {

}

#pragma mark - PPAppFacadeRetainable

- (PPAppFacade *)facade {
    @synchronized(self) {
        if (!_facade) {
            _facade = [PPAppFacade new];
        }
        return _facade;
    }
}

@end
