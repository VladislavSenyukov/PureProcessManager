//
//  PPSettingsManager.h
//  PureProcessManager
//
//  Created by Vladislav Senyukov on 09.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPSettingsManager : NSObject

@property (nonatomic, assign) BOOL showOwnerProcessesOnly;
@property (nonatomic, assign) NSTimeInterval updateRate;

@end
