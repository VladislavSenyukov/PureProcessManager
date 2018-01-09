//
//  PPProcessFetcher.h
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPProcessInfo.h"

@interface PPProcessFetcher : NSObject

+ (NSArray<PPProcessInfo *> *)fetchProcessesForOwnerOnly:(BOOL)ownerOnly;

@end
