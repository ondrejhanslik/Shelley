//
//  SYUIAElementFilter.h
//  Shelley
//
//  Created by Ondrej Hanslik on 8/29/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "SYArrayFilterTemplate.h"

#if TARGET_OS_IPHONE
#define ACCESSIBILITY_TRAITS UIAccessibilityTraits
#else
#define ACCESSIBILITY_TRAITS NSUinteger
#endif

@interface SYUIAElementFilter : SYArrayFilterTemplate

#if TARGET_OS_IPHONE
@property (nonatomic, assign, readonly) ACCESSIBILITY_TRAITS traitsFilter;
#endif

- (id)initWithTraitsFilter:(NSString*)traitsString;

@end
