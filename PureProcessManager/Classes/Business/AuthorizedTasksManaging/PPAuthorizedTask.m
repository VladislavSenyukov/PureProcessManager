//
//  PPAuthorizedTask.m
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 08.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPAuthorizedTask.h"
#import <dlfcn.h>

// Create fn pointer to AuthorizationExecuteWithPrivileges in case it doesn't exist in this version of MacOS
static OSStatus (*ExecuteWithPrivileges)(AuthorizationRef authorization, const char *pathToTool, AuthorizationFlags options, char * const *arguments, FILE **communicationsPipe) = NULL;

@implementation PPAuthorizedTask

- (OSStatus)launch {
    if (![self.class authorizedExecutionFunctionAvailable]) {
        return errAuthorizationDenied;
    }
    
    const char *toolPath = [self.toolPath fileSystemRepresentation];
    NSArray *arguments = self.arguments;
    AuthorizationRef authorization = self.authRight.authorization;
    NSUInteger numberOfArguments = [arguments count];
    char *args[numberOfArguments + 1];
    FILE *outputFile;
    
    for (int i = 0; i < numberOfArguments; i++) {
        NSString *argString = arguments[i];
        const char *fsrep = [argString fileSystemRepresentation];
        NSUInteger stringLength = strlen(fsrep);
        
        args[i] = malloc((stringLength + 1) * sizeof(char));
        snprintf(args[i], stringLength + 1, "%s", fsrep);
    }
    args[numberOfArguments] = NULL;
    
    //use Authorization Reference to execute script with privileges
    OSStatus status = ExecuteWithPrivileges(authorization, toolPath, kAuthorizationFlagDefaults, args, &outputFile);
    
    // free the malloc'd argument strings
    for (int i = 0; i < numberOfArguments; i++) {
        free(args[i]);
    }
    
    return status;
}

#pragma mark - Private

+ (BOOL)authorizedExecutionFunctionAvailable {
    // Check to see if we have the correct function in our loaded libraries
    if (!ExecuteWithPrivileges) {
        // On 10.7, AuthorizationExecuteWithPrivileges is deprecated. We want
        // to still use it since there's no good alternative (without requiring
        // code signing). We'll look up the function through dyld and fail if
        // it is no longer accessible. If Apple removes the function entirely
        // this will fail gracefully. If they keep the function and throw some
        // sort of exception, this won't fail gracefully, but that's a risk
        // we'll have to take for now.
        // Pattern by Andy Kim from Potion Factory LLC
#pragma GCC diagnostic ignored "-Wpedantic" // stop the pedantry!
#pragma clang diagnostic push
        ExecuteWithPrivileges = dlsym(RTLD_DEFAULT, "AuthorizationExecuteWithPrivileges");
#pragma clang diagnostic pop
    }
    return ExecuteWithPrivileges ? YES : NO;
}

@end
