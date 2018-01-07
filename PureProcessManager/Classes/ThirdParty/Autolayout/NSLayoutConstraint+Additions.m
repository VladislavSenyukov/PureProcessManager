//
//  NSLayoutConstraint+Additions.m
//
//  Created by Vlad on 2/2/15.
//
//

#import "NSLayoutConstraint+Additions.h"

@implementation NSLayoutConstraint (Additions)

+ (NSArray*)constraintsWithStrings:(NSArray*)strings
                             views:(NSDictionary*)views
                           metrics:(NSDictionary*)metrics {
    NSMutableArray *allConstraints = [NSMutableArray new];
    for (NSString *string in strings) {
        [allConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:string options:0 metrics:metrics views:views]];
    }
    return allConstraints;
}

+ (NSLayoutConstraint*)constraintWithString:(NSString*)string
                                      views:(NSDictionary*)views
                                    metrics:(NSDictionary*)metrics {
    if (!string) {
        return nil;
    }
    return [[self constraintsWithStrings:@[string] views:views metrics:metrics] firstObject];
}

+ (NSLayoutConstraint*)constraintWithString:(NSString*)string
                                      views:(NSDictionary*)views {
    return [self constraintWithString:string views:views metrics:nil];
}

+ (NSArray*)constraintsWithStrings:(NSArray*)strings views:(NSDictionary*)views {
    return [self constraintsWithStrings:strings views:views metrics:nil];
}

+ (NSArray *)constraintsWithEdgeInsets:(NSEdgeInsets)insets onView:(NSView*)view {
    NSDictionary *views = @{@"view" : view};
    NSArray *strings = @[[NSString stringWithFormat:@"|-%f-[view]-%f-|", insets.left, insets.right], [NSString stringWithFormat:@"V:|-%f-[view]-%f-|", insets.top, insets.bottom]];
    return [self constraintsWithStrings:strings views:views];
}

+ (NSLayoutConstraint *)heightConstraint:(CGFloat)height onView:(NSView *)view {
    NSDictionary *views = @{@"view" : view};
    NSArray *strings = @[[NSString stringWithFormat:@"V:[view(%f)]", height]];
    NSArray *constraints = [self constraintsWithStrings:strings views:views];
    return [constraints firstObject];
}

+ (NSLayoutConstraint *)widthConstraint:(CGFloat)width onView:(NSView *)view {
    NSDictionary *views = @{@"view" : view};
    NSArray *strings = @[[NSString stringWithFormat:@"H:[view(%f)]", width]];
    NSArray *constraints = [self constraintsWithStrings:strings views:views];
    return [constraints firstObject];
}

- (NSLayoutConstraint *)copyConstraintAndReplaceView:(NSView *)oldView withView:(NSView *)newView {
    id fItem = self.firstItem != oldView ? self.firstItem : newView;
    id sItem = self.secondItem != oldView ? self.secondItem : newView;
    NSLayoutConstraint *copyConstraint = [NSLayoutConstraint constraintWithItem:fItem attribute:self.firstAttribute relatedBy:self.relation toItem:sItem attribute:self.secondAttribute multiplier:self.multiplier constant:self.constant];
    return copyConstraint;
}

@end
