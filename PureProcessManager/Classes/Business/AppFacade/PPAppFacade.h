//
//  PPAppFacade.h
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPProcessInfo.h"
#import "PPDefinitions.h"

#define AppFacadeShared [PPAppFacade shared]

@class PPAppFacade;
@protocol PPFacadeRetainable
@property (atomic, readonly) PPAppFacade *facade;
@end

typedef void(^PPProcessListDidUpdateCompletion)(NSArray<PPProcessInfo*> *processList);

@interface PPAppFacade : NSObject

@property (nonatomic, assign) NSTimeInterval processListUpdateRate;

+ (instancetype)shared;

- (void)startPeriodicProcessListUpdatesWithCompletion:(PPProcessListDidUpdateCompletion)completion;
- (void)killProcess:(PPProcessInfo*)info completion:(PPErrorCompletion)completion;

@end
