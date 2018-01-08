//
//  PPProcessManager.h
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPProcessInfo.h"
#import "PPDefinitions.h"

@class PPProcessManager;
@protocol PPProcessManagerDelegate
@optional
- (void)processManager:(PPProcessManager*)processManager didUpdateWithProcessList:(NSArray<PPProcessInfo*>*)processList;
@end

@interface PPProcessManager : NSObject

@property (nonatomic, weak) NSObject <PPProcessManagerDelegate> *delegate;
@property (nonatomic, assign) NSTimeInterval updateInterval;
@property (nonatomic, assign) dispatch_queue_t callbackQueue;

- (void)startUpdatingProcessList;
- (void)stopUpdatingProcessList;
- (void)killProcessWithInfo:(PPProcessInfo*)info completion:(PPErrorCompletion)completion;

@end
