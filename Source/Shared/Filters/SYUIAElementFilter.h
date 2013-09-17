//
//  SYUIAElementFilter.h
//  Shelley
//
//  Created by Ondrej Hanslik on 8/29/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "SYArrayFilterTemplate.h"

@interface SYUIAElementFilter : SYArrayFilterTemplate

@property (nonatomic, assign, readonly) UIAccessibilityTraits traitsFilter;

- (id)initWithTraitsFilter:(NSString *)traitsString;

@end
