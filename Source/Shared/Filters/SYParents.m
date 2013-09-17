//
//  SYParents.m
//  Shelley
//
//  Created by Pete Hodgson on 7/20/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYParents.h"


@implementation SYParents

-(NSArray *)applyToView:(ShelleyView *)view{
    NSMutableArray *ancestors = [NSMutableArray array];
    
#if TARGET_OS_IPHONE
    ShelleyView *currentView = view;
    
    if (![view isKindOfClass:[UIView class]]) {
        return ancestors;
    }
    
    while(( currentView = [(UIView*) currentView superview] )){
        [ancestors addObject:currentView];
    }
#else
    id currentView = view;
    
    while (currentView != nil) {
        if ([currentView respondsToSelector: @selector(FEX_parent)])
        {
            currentView = [currentView performSelector: @selector(FEX_parent)];
        }
        else
        {
            currentView = nil;
        }
        
        if (currentView != nil) {
            [ancestors addObject: currentView];
        }
    }
    
#endif
    
    return ancestors;
}

- (BOOL) nextFilterShouldNotDescend {
    return YES;
}

@end
