//
//  SYSortFilter.h
//  Shelley
//
//  Created by Ondrej Hanslik on 9/19/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "SYArrayFilterTemplate.h"

@interface SYSortFilter : SYArrayFilterTemplate

- (id)initWithSortDescriptor:(NSString*)sortDescriptor;

@end
