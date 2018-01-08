//
//  PPAuthorizedTask.h
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 08.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAuthorizedRight.h"

@interface PPAuthorizedTask : NSObject
@property (nonatomic, copy) NSString *toolPath;
@property (nonatomic, strong) NSArray<NSString*> *arguments;
@property (nonatomic, strong) PPAuthorizedRight *authRight;

- (OSStatus)launch;

@end
