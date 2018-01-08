//
//  PPAuthorizationManager.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 08.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPAuthorizationManager.h"
#import "PPDefinitions.h"

@interface PPAuthorizationManager ()
@property (nonatomic, strong) PPAuthorizedRight *executeRight;
@end

@implementation PPAuthorizationManager

- (void)acquireExecuteRight:(PPAcquireRightCompletion)completion {
    PPAuthorizedRight *executeRight = self.executeRight;
    if (!executeRight) {
        AuthorizationRef authorization;
        OSStatus status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorization);
        if (status == errAuthorizationSuccess) {
            AuthorizationItem executeRigthItem = { kAuthorizationRightExecute, 0, 0, 0 };
            AuthorizationRights rights = { 1, &executeRigthItem };
            AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
            status = AuthorizationCopyRights(authorization, &rights, kAuthorizationEmptyEnvironment, flags, NULL);
            if (status == errAuthorizationSuccess) {
                executeRight = [[PPAuthorizedRight alloc] initWithAuthorization:authorization];
            }
        }
    }
    
    NSError *error = nil;
    if (!executeRight) {
        error = [NSError errorWithDomain:PPAuthorizationErrorDomain
                                    code:PPErrorCodeAuthorizationFailed
                                userInfo:@{NSLocalizedDescriptionKey : @"User authorization has failed."}];
    }
    self.executeRight = executeRight;
    if (completion) {
        completion(executeRight, error);
    }
}

@end
