//
//  PPIntegerFormatter.m
//  PureProcessManagerPrefPane
//
//  Created by Vladislav Senyukov on 09.01.18.
//  Copyright © 2018 Vladislav Senyukov. All rights reserved.
//

#import "PPIntegerFormatter.h"
#import <AppKit/AppKit.h>

@implementation PPIntegerFormatter

- (BOOL)isPartialStringValid:(NSString*)partialString
            newEditingString:(NSString**)newString
            errorDescription:(NSString**)error {
    if(!partialString.length) {
        return YES;
    }
    NSScanner* scanner = [NSScanner scannerWithString:partialString];
    if(!([scanner scanInt:0] && [scanner isAtEnd])) {
        NSBeep();
        return NO;
    }
    return YES;
}

@end
