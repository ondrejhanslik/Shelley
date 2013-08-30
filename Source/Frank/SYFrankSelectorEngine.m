//
//  SYFrankSelectorEngine.m
//  Shelley
//
//  Created by Thought Worker on 11/11/11.
//  Copyright (c) 2011 ThoughtWorks. All rights reserved.
//

#import "SYFrankSelectorEngine.h"
#import "Shelley.h"

#define xstr(s) str(s)
#define str(s) #s
#define VERSIONED_NAME "Shelley " xstr(SHELLEY_PRODUCT_VERSION)
const unsigned char what_string[] = "@(#)" VERSIONED_NAME "\n";

static NSString *const registeredName = @"shelley_compat";

@implementation SYFrankSelectorEngine

+(void)load{
    SYFrankSelectorEngine *registeredInstance = [[self alloc]init];
    [SelectorEngineRegistry registerSelectorEngine:registeredInstance WithName:registeredName];
    NSLog(@"%s registered with Frank as selector engine named '%@'", VERSIONED_NAME, registeredName);
    [registeredInstance release];
}

- (NSArray *) selectViewsWithSelector:(NSString *)selector {
    NSLog( @"Using %s to select views with selector: %@", VERSIONED_NAME, selector );
    
    Shelley *shelley = [Shelley withSelectorString:selector];
    
#if TARGET_OS_IPHONE
    return [shelley selectFromViews:[NSArray arrayWithObject: [UIApplication sharedApplication]]];
#else
    return [shelley selectFromViews:[NSArray arrayWithObject: [NSApplication sharedApplication]]];
#endif
}

@end
