//
//  NSView+FEXHierarchy.m
//  Shelley
//
//  Created by Buckley on 9/30/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "NSView+FEXHierarchy.h"

@implementation NSView (FEXHierarchy)

- (id) FEX_parent
{
    return [self superview];
}

- (NSArray*) FEX_children
{
    return [self subviews];
}

@end
