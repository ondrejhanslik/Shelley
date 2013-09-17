//
//  SYPredicateFilter.h
//  Shelley
//
//  Created by Ondrej Hanslik on 8/29/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "SYFilter.h"

@interface SYPredicateFilter : NSObject <SYFilter>

@property (nonatomic, retain, readonly) NSPredicate *predicate;

- (id)initWithPredicateString:(NSString *)predicateString;

@end
