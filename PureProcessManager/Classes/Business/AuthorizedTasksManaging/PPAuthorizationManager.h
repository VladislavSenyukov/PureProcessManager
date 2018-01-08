//
//  PPAuthorizationManager.h
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 08.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAuthorizedRight.h"

@interface PPAuthorizationManager : NSObject

typedef void(^PPAcquireRightCompletion)(PPAuthorizedRight *right, NSError *error);

/**
 * @abstruct Create a new execute right or get a cached one. Runs synchronously.
 */
- (void)acquireExecuteRight:(PPAcquireRightCompletion)completion;

@end
