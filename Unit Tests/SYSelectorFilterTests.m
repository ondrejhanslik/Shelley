//
//  SYSelectorFilterTests.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYSelectorFilterTests.h"

#import "SYSelectorFilter.h"

@interface DummyView : ShelleyView
{
    BOOL methodWasCalled;
    BOOL returnValue;
}
@property BOOL methodWasCalled,returnValue;
@end

@implementation DummyView
@synthesize methodWasCalled,returnValue;

- (id)init {
    self = [super init];
    if (self) {
        methodWasCalled = NO;
    }
    return self;
}

- (BOOL) dummyMethod{
    methodWasCalled = YES;
    return returnValue;
}

@end


@implementation SYSelectorFilterTests

- (void) testGracefullyHandlesViewNotRespondingToSelector{
    ShelleyView *view = [[[ShelleyView alloc] init]autorelease];
    SYSelectorFilter *filter = [[[SYSelectorFilter alloc] initWithSelector:@selector(notPresent) args:[NSArray array]] autorelease];
    
    NSArray *filteredViews = [filter applyToView:view];
    STAssertNotNil(filteredViews, nil);
    STAssertEquals((NSUInteger)0, [filteredViews count], nil);
}

- (void) testCallsPredicateMethodOnView{
    DummyView *view = [[[DummyView alloc] init]autorelease];
    
    SYSelectorFilter *filter = [[[SYSelectorFilter alloc] initWithSelector:@selector(dummyMethod) args:[NSArray array]] autorelease];
    
    STAssertFalse([view methodWasCalled],nil);
    [filter applyToView:view];
    STAssertTrue([view methodWasCalled],nil);
}

- (void) testFiltersOutViewIfPredicateReturnsNO{
    DummyView *view = [[[DummyView alloc] init]autorelease];
    view.returnValue = NO;
    
    SYSelectorFilter *filter = [[[SYSelectorFilter alloc] initWithSelector:@selector(dummyMethod) args:[NSArray array]] autorelease];
    
    NSArray *filteredViews = [filter applyToView:view];
    STAssertNotNil(filteredViews, nil);
    STAssertEquals((NSUInteger)0, [filteredViews count], nil);
}

- (void) testDoesNotFiltersOutViewIfPredicateReturnsYES{
    DummyView *view = [[[DummyView alloc] init]autorelease];
    view.returnValue = YES;
    
    SYSelectorFilter *filter = [[[SYSelectorFilter alloc] initWithSelector:@selector(dummyMethod) args:[NSArray array]] autorelease];
    
    NSArray *filteredViews = [filter applyToView:view];
    STAssertNotNil(filteredViews, nil);
    STAssertEquals((NSUInteger)1, [filteredViews count], nil);
    STAssertEquals(view, [filteredViews objectAtIndex:0], nil);
}



@end
