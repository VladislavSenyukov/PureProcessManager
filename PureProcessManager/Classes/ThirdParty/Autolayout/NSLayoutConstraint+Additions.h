//
//  NSLayoutConstraint+Additions.h
//
//  Created by Vlad on 2/2/15.
//
//

#import <Cocoa/Cocoa.h>

@interface NSLayoutConstraint (Additions)

/**
 *  Constraints for an array of strings with visual format language
 */
+ (NSArray*)constraintsWithStrings:(NSArray*)strings
                             views:(NSDictionary*)views
                           metrics:(NSDictionary*)metrics;

/**
 *  Constraint for a single string. If the string imply more than 1 constraint, a first constraint taken will be returned
 */
+ (NSLayoutConstraint*)constraintWithString:(NSString*)string
                                      views:(NSDictionary*)views
                                    metrics:(NSDictionary*)metrics;

+ (NSLayoutConstraint*)constraintWithString:(NSString*)string
                                      views:(NSDictionary*)views;

+ (NSArray*)constraintsWithStrings:(NSArray*)strings views:(NSDictionary*)views;
+ (NSArray *)constraintsWithEdgeInsets:(NSEdgeInsets)insets onView:(NSView*)view;
+ (NSLayoutConstraint*)heightConstraint:(CGFloat)height onView:(NSView*)view;
+ (NSLayoutConstraint*)widthConstraint:(CGFloat)width onView:(NSView *)view;

- (NSLayoutConstraint *)copyConstraintAndReplaceView:(NSView *)oldView withView:(NSView *)newView;

@end
