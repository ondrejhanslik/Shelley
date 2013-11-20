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
#if TARGET_OS_IPHONE
    return [self selectViewsWithSelector:selector inWindows:[[UIApplication sharedApplication] windows]];
#else
    return [self selectViewsWithSelector:selector inWindows:[NSArray arrayWithObject: [NSApplication sharedApplication]]];
#endif
}

- (NSArray *) selectViewsWithSelector:(NSString *)selector inWindows:(NSArray *)windows
{
    NSLog( @"Using %s to select views with selector: %@ in windows: %@", VERSIONED_NAME, selector, windows );

    Shelley *shelley = [Shelley withSelectorString:selector];
    return [shelley selectFromViews:windows];
}

@end
