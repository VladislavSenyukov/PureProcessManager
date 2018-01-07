//
//  PPAppFacade.h
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPProcessInfo.h"

@class PPAppFacade;
@protocol PPFacadeRetainable
@property (atomic, readonly) PPAppFacade *facade;
@end

typedef void(^PPProcessListDidUpdateCompletion)(NSArray<PPProcessInfo*> *processList);

@interface PPAppFacade : NSObject

+ (instancetype)shared;

- (void)startPeriodicProcessListUpdatesWithCompletion:(PPProcessListDidUpdateCompletion)completion;

@end
