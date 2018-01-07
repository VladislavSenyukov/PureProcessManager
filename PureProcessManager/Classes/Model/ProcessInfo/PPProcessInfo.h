//
//  PPProcessInfo.h
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 07.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPProcessInfo : NSObject
@property (nonatomic, assign) int processID;
@property (nonatomic, strong) NSString *processName;
@property (nonatomic, strong) NSString *ownerName;
@end
