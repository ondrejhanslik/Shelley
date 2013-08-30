//
//  SYPredicateFilter.m
//  Shelley
//
//  Created by Ondrej Hanslik on 8/29/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "SYPredicateFilter.h"
#import "Shelley.h"

@interface SYPredicateFilter ()

@property (nonatomic, retain, readwrite) NSPredicate *predicate;

@end

@implementation SYPredicateFilter

@synthesize predicate = _predicate;

#pragma mark - Life cycle

- (id)initWithPredicateString:(NSString *)predicateString {
    self = [super init];
    
    if (!self) {
        return nil;
    }

    self.predicate = [NSPredicate predicateWithFormat:predicateString, nil];
    
    return self;
}

- (void)dealloc {
    [_predicate release];
    
    [super dealloc];
}

#pragma mark - Filter implementation

- (void)setDoNotDescend:(BOOL)doNotDescend {
    //do nothing
}

- (BOOL)nextFilterShouldNotDescend {
    return NO;
}

- (NSArray *)applyToViews:(NSArray *)views {
    NSMutableArray *results = [NSMutableArray array];
    
    BOOL matchesPredicate;
    
    for (ShelleyView *view in views) {
        @try {
            matchesPredicate = [self.predicate evaluateWithObject:view];
        }
        @catch (NSException *e) {
            matchesPredicate = NO;
        }
        
        if (matchesPredicate) {
            [results addObject:view];
        }
    }
    
    return results;
}

@end
