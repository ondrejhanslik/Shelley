//
//  SYClassFilter.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYClassFilter.h"

#if !TARGET_OS_IPHONE
@interface NSApplication (FrankAutomation)
- (NSSet*) FEX_menus;
@end
#endif

@implementation SYClassFilter
@synthesize target=_targetClass;

+ (NSArray *) allDescendantsOf:(ShelleyView *)view{
    NSMutableArray *descendants = [NSMutableArray array];
    
#if TARGET_OS_IPHONE
    if ([view isKindOfClass:[UIApplication class]]) {
        for (UIWindow *window in [(UIApplication* )view windows]) {
            [descendants addObject:window];
            [descendants addObjectsFromArray:[self allDescendantsOf:window]];
        }        
    }
    else if ([view isKindOfClass:[UIView class]]) {
        for (UIView *subview in [(UIView* )view subviews]) {
            [descendants addObject:subview];
            [descendants addObjectsFromArray:[self allDescendantsOf:subview]];
        }
    }
#else
    if ([view respondsToSelector: @selector(FEX_children)])
    {
        for (id child in [view performSelector: @selector(FEX_children)])
        {
            [descendants addObject: child];
            [descendants addObjectsFromArray: [self allDescendantsOf: child]];
        }
    }
    
#endif
    return descendants;
}

- (id)initWithClass:(Class)class {
    return [self initWithClass:class includeSelf:NO];
}

- (id)initWithClass:(Class)class includeSelf:(BOOL)includeSelf {
    self = [super init];
    if (self) {
        _targetClass = class;
		_includeSelf = includeSelf;
        _justFilter = NO;
    }
    return self;
}

- (void)setDoNotDescend:(BOOL)doNotDescend {
    _justFilter = doNotDescend;
}

-(NSArray *)viewsToConsiderFromView:(ShelleyView *)view{
    if( _justFilter )
        return [NSArray arrayWithObject:view];
    
    NSMutableArray *allViews = _includeSelf ? [NSMutableArray arrayWithObject:view] : [NSMutableArray array];
    [allViews addObjectsFromArray:[SYClassFilter allDescendantsOf:view]];
    return allViews;
}

-(NSArray *)applyToView:(ShelleyView *)view{
    NSArray *allViews = [self viewsToConsiderFromView:view];
	
    // TODO: look at using predicates
    NSMutableArray *filteredDescendants = [NSMutableArray array];
    for (ShelleyView *v in allViews) {
        if( [v isKindOfClass:_targetClass] ){
            [filteredDescendants addObject:v];
        }
    }
    
    return filteredDescendants;
}

@end
