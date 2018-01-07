//
//  NSView+LayoutConstraints.h
//
//  Created by Vlad on 2/2/15.
//
//

#import <Cocoa/Cocoa.h>
#import "NSLayoutConstraint+Additions.h"

@interface NSView (LayoutConstraints)

//*
- (void)addConstraints:(NSArray*)strings views:(NSDictionary*)views metrics:(NSDictionary*)metrics;
- (void)addConstraints:(NSArray*)strings views:(NSDictionary*)views;
- (void)removeAllConstraints;
- (void)embedInContainer:(NSView *)container;
- (void)embedInContainer:(NSView *)container positioned:(NSWindowOrderingMode)positioned relativeTo:(NSView*)relativeView;

// should have a superview
- (BOOL)addConstraintsWithEdgeInsets:(NSEdgeInsets)insets;
- (BOOL)addHeightConstraint:(CGFloat)height;
- (BOOL)addWidthConstraint:(CGFloat)width;
- (BOOL)addConstraintsSize:(NSSize)size;
- (BOOL)addConstraintsOrigin:(NSPoint)origin;
- (BOOL)addConstraintsRect:(NSRect)frame;
- (BOOL)addConstraintY:(CGFloat)y;
- (BOOL)addConstraintX:(CGFloat)x;
- (BOOL)addConstraintCenterVertically;
- (BOOL)addConstraintCenterVerticallyWithConstant:(CGFloat)constant;
- (BOOL)addConstraintCenterVerticallyWithMultiplier:(CGFloat)multiplier;
- (BOOL)addConstraintCenterHorizontally;
- (BOOL)addConstraintCenteredWithScale:(NSSize)scale;
- (BOOL)addSuperviewSizedConstraints;
- (BOOL)addConstraintEqualWidth;
- (BOOL)addConstraintEqualWidth:(CGFloat)multiplier;
- (BOOL)addConstraintEqualHeight;
- (BOOL)addConstraintEqualHeightWithMultiplier:(CGFloat)multiplier;
- (BOOL)addConstraintEqualHeightWithConstant:(CGFloat)constant;
- (BOOL)addConstraintEqualHeightWithMultiplier:(CGFloat)multiplier constant:(CGFloat)constant;

- (NSLayoutConstraint*)constraintCenterVertically;
- (NSLayoutConstraint*)constraintCenterVerticallyWithConstant:(CGFloat)constant;
- (NSLayoutConstraint*)constraintCenterVerticallyWithMultiplier:(CGFloat)multiplier constant:(CGFloat)constant;

- (NSArray<NSLayoutConstraint *> *)contentSizeConstraints;
- (NSArray<NSLayoutConstraint*>*)innerConstraints;
- (NSArray<NSLayoutConstraint*>*)outerConstraints;
- (NSArray<NSLayoutConstraint*>*)constraintsRelatedToView:(NSView*)view;
- (NSArray<NSLayoutConstraint*>*)removeAllRelativeConstraints;
- (void)removeInnerConstraints;

@end
