//
//  PPAuthorizedRight.h
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 08.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Authorization.h>

@interface PPAuthorizedRight : NSObject

- (instancetype)initWithAuthorization:(AuthorizationRef)authorization;

@property (nonatomic, readonly) AuthorizationRef authorization;

@end
