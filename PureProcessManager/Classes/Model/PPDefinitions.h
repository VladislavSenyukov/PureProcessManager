//
//  PPDefinitions.h
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 08.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#ifndef PPDefinitions_h
#define PPDefinitions_h

typedef void(^PPErrorCompletion)(NSError *error);

static NSTimeInterval const PPProcessListDefaultUpdateRate = 3.0;
static BOOL const PPProcessListDefaultShowOwnersProcessesOnly = NO;

static NSNotificationName const PPPrefPaneSettingsDidUpdate = @"PPPrefPaneSettingsDidUpdate";

static NSErrorDomain const PPAuthorizationErrorDomain = @"PPAuthorizationErrorDomain";
static NSErrorDomain const PPAuthorizedTaskErrorDomain = @"PPAuthorizedTaskErrorDomain";

static NSInteger const PPErrorCodeAuthorizationFailed = 1000;
static NSInteger const PPErrorCodeTaskExecutionFailed = 1001;

#endif /* PPDefinitions_h */
