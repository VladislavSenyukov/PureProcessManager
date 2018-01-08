//
//  PPAuthorizedRight.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 08.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPAuthorizedRight.h"

@implementation PPAuthorizedRight

@synthesize authorization = _authorization;

- (instancetype)initWithAuthorization:(AuthorizationRef)authorization {
    self = [super init];
    _authorization = authorization;
    return self;
}

@end
