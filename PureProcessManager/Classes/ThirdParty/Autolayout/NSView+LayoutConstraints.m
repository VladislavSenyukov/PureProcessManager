//
//  NSView+LayoutConstraints.m
//
//  Created by Vlad on 2/2/15.
//
//

#import "NSView+LayoutConstraints.h"

@implementation NSView (LayoutConstraints)

- (void)addConstraints:(NSArray*)strings views:(NSDictionary*)views metrics:(NSDictionary*)metrics {
    NSArray *constraints = [NSLayoutConstraint constraintsWithStrings:strings views:views metrics:metrics];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)addConstraints:(NSArray*)strings views:(NSDictionary*)views {
    return [self addConstraints:strings views:views metrics:nil];
}

- (void)removeAllConstraints {
    for (NSLayoutConstraint *constraint in self.constraints) {
        constraint.active = NO;
    }
}

#pragma mark - Needs superview

- (BOOL)addConstraintsWithEdgeInsets:(NSEdgeInsets)insets {
    if (!self.superview) {
        return NO;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithEdgeInsets:insets onView:self]];
    return YES;
}

- (BOOL)addConstraintCenterVertically {
    return [self addConstraintCenterVerticallyWithConstant:0.0];
}

- (BOOL)addConstraintCenterVerticallyWithConstant:(CGFloat)constant {
    return [self addConstraintCenterVerticallyWithMultiplier:1 constant:constant];
}

- (BOOL)addConstraintCenterVerticallyWithMultiplier:(CGFloat)multiplier {
    return [self addConstraintCenterVerticallyWithMultiplier:multiplier constant:0];
}

- (BOOL)addConstraintCenterVerticallyWithMultiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    if (!self.superview) {
        return NO;
    }
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:multiplier constant:constant];
    [self.superview addConstraint:constraint];
    return YES;
}

- (BOOL)addConstraintCenterHorizontally {
    if (!self.superview) {
        return NO;
    }
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.superview addConstraint:constraint];
    return YES;
}

- (BOOL)addHeightConstraint:(CGFloat)height {
    if (!self.superview) {
        return NO;
    }
    [self.superview addConstraint:[NSLayoutConstraint heightConstraint:height onView:self]];
    return YES;
}

- (BOOL)addWidthConstraint:(CGFloat)width {
    if (!self.superview) {
        return NO;
    }
    [self.superview addConstraint:[NSLayoutConstraint widthConstraint:width onView:self]];
    return YES;
}

- (BOOL)addConstraintCenteredWithScale:(NSSize)scale {
    return [self checkSuperviewAndRunCompletion:^{
        [self addConstraintCenterVertically];
        [self addConstraintCenterHorizontally];
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:scale.width constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeHeight multiplier:scale.height constant:0].active = YES;
    }];
}

#pragma mark - Frame constraints

- (BOOL)addConstraintsSize:(NSSize)size {
    return [self addHeightConstraint:size.height] && [self addWidthConstraint:size.width];
}

- (BOOL)addConstraintsOrigin:(NSPoint)origin {
    if (!self.superview) {
        return NO;
    }
    [self addConstraintX:origin.x];
    [self addConstraintY:origin.y];
    return YES;
}

- (BOOL)addConstraintsRect:(NSRect)frame {
    if (!self.superview) {
        return NO;
    }
    [self addConstraintsOrigin:frame.origin];
    [self addConstraintsSize:frame.size];
    return YES;
}

- (BOOL)addConstraintY:(CGFloat)y {
    if (!self.superview) {
        return NO;
    }
    [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-y].active = YES;
    return YES;
}

- (BOOL)addConstraintX:(CGFloat)x {
    if (!self.superview) {
        return NO;
    }
    [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:x].active = YES;
    return YES;
}

#pragma mark -

- (BOOL)addSuperviewSizedConstraints {
    return [self addConstraintsWithEdgeInsets:NSEdgeInsetsMake(0, 0, 0, 0)];
}

- (BOOL)addConstraintEqualWidth {
    return [self addConstraintEqualWidth:1];
}

- (BOOL)addConstraintEqualWidth:(CGFloat)multiplier {
    if (!self.superview) {
        return NO;
    }
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:multiplier constant:0]];
    return YES;
}

- (BOOL)addConstraintEqualHeight {
    return [self addConstraintEqualHeightWithMultiplier:1];
}

- (BOOL)addConstraintEqualHeightWithMultiplier:(CGFloat)multiplier {
    return [self addConstraintEqualHeightWithMultiplier:multiplier constant:0];
}

- (BOOL)addConstraintEqualHeightWithConstant:(CGFloat)constant {
    return [self addConstraintEqualHeightWithMultiplier:1 constant:constant];
}

- (BOOL)addConstraintEqualHeightWithMultiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    if (!self.superview) {
        return NO;
    }
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeHeight multiplier:multiplier constant:constant]];
    return YES;
}

- (void)embedInContainer:(NSView *)container positioned:(NSWindowOrderingMode)positioned relativeTo:(NSView*)relativeView {
    if ([container.subviews containsObject:self]) {
        return;
    }
    [container addSubview:self positioned:positioned relativeTo:relativeView];
    [self addSuperviewSizedConstraints];
}

- (void)embedInContainer:(NSView *)container {
    [self embedInContainer:container positioned:NSWindowOut relativeTo:nil];
}

#pragma mark - Constraint Factory

- (NSLayoutConstraint*)constraintCenterVertically {
    return [self constraintCenterVerticallyWithConstant:0];
}

- (NSLayoutConstraint*)constraintCenterVerticallyWithConstant:(CGFloat)constant {
    return [self constraintCenterVerticallyWithMultiplier:1 constant:constant];
}

- (NSLayoutConstraint*)constraintCenterVerticallyWithMultiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    if (self.superview) {
        return [NSLayoutConstraint constraintWithItem:self
                                            attribute:NSLayoutAttributeCenterY
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:self.superview
                                            attribute:NSLayoutAttributeCenterY
                                           multiplier:multiplier
                                             constant:constant];
    }
    return nil;
}

#pragma mark - Constraints instances

- (NSArray<NSLayoutConstraint *> *)contentSizeConstraints {
    NSArray *constraints = [self constraintsRelatedToView:self filterClass:NSClassFromString(@"NSContentSizeLayoutConstraint")];
    return constraints;
}

- (NSArray<NSLayoutConstraint *> *)innerConstraints {
    NSArray *constraints = [self constraintsRelatedToView:self filterClass:[NSLayoutConstraint class]];
    return constraints;
}

- (NSArray<NSLayoutConstraint *> *)outerConstraints {
    return [self.superview constraintsRelatedToView:self];
}

- (NSArray<NSLayoutConstraint*>*)constraintsRelatedToView:(NSView*)view filterClass:(Class)filterClass {
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    for (NSLayoutConstraint *c in self.constraints) {
        if (c.firstItem == view || c.secondItem == view) {
            if (!filterClass || (filterClass && [c isMemberOfClass:filterClass])) {
                [constraints addObject:c];
            }
        }
    }
    return constraints;
}

- (NSArray<NSLayoutConstraint*>*)constraintsRelatedToView:(NSView*)view {
    return [self constraintsRelatedToView:view filterClass:nil];
}

- (void)removeInnerConstraints {
    NSArray *innerConstraints = [self innerConstraints];
    [self removeConstraints:innerConstraints];
}

- (NSArray<NSLayoutConstraint *> *)removeAllRelativeConstraints {
    NSArray *innerConstraints = [self innerConstraints];
    NSArray *outerConstraints = [self outerConstraints];
    [self removeConstraints:innerConstraints];
    [self.superview removeConstraints:outerConstraints];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObjectsFromArray:innerConstraints];
    [result addObjectsFromArray:outerConstraints];
    return [NSArray arrayWithArray:result];
}

#pragma mark - Private

- (BOOL)checkSuperviewAndRunCompletion:(void(^)(void))completion {
    if (self.superview) {
        completion();
        return YES;
    }
    return NO;
}

@end
