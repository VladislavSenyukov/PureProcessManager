//
//  PPProcessInfo.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPProcessInfo.h"

@implementation PPProcessInfo

- (BOOL)isEqual:(PPProcessInfo*)object {
    return [self.processID intValue] == [object.processID intValue];
}

@end
