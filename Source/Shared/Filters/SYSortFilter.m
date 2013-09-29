//
//  SYSortFilter.m
//  Shelley
//
//  Created by Ondrej Hanslik on 9/19/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "SYSortFilter.h"

typedef enum {
    kSYSortTypeInvalid = 0,
    kSYSortTypePosition = 1
} SYSortType;

SYSortType SYSortTypeFromNSString(NSString* string) {
    if ([string isEqualToString:@"position"]) {
        return kSYSortTypePosition;
    }
    else {
        return kSYSortTypeInvalid;
    }
}

@interface SYSortFilter ()

@property (nonatomic, assign, readwrite) SYSortType sortType;

@end

@implementation SYSortFilter

@synthesize sortType = _sortType;

#pragma mark - Life cycle

- (id)initWithSortDescriptor:(NSString*)sortDescriptor {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.sortType = SYSortTypeFromNSString(sortDescriptor);
    
    if (self.sortType == kSYSortTypeInvalid) {
        [NSException raise:@"Invalid sort description" format:@"Uknown sort descriptor: \"%@\"", sortDescriptor];
    }
    
    return self;
}

- (void)dealloc {
    self.sortType = nil;
    
    [super dealloc];
}

#pragma mark - Filter implementation

- (void)setDoNotDescend:(BOOL)doNotDescend {
    //do nothing
}

- (BOOL)nextFilterShouldNotDescend {
    return NO;
}

- (NSComparisonResult(^)(id obj1, id obj2))positionComparator {
    NSComparisonResult (^positionComparator) (id obj1, id obj2) = ^NSComparisonResult(id obj1, id obj2) {
        //XXX: use NSObject!
        UIView* view1 = obj1;
        UIView* view2 = obj2;
        
        if (view1.window.windowLevel < view2.window.windowLevel) {
            return NSOrderedAscending;
        }
        else if (view1.window.windowLevel > view2.window.windowLevel) {
            return NSOrderedDescending;
        }
        
        CGRect frame1 = [view1.window convertRect:view1.bounds fromView:view1];
        CGRect frame2 = [view2.window convertRect:view2.bounds fromView:view2];

        if (fabsf(frame1.origin.y - frame2.origin.y) < 0.01f) {
            if (fabsf(frame1.origin.x - frame2.origin.x) < 0.01f) {
                return NSOrderedSame;
            }
            else if (frame1.origin.x < frame2.origin.x) {
                return NSOrderedAscending;
            }
            else {  //if (frame1.origin.x > frame2.origin.x) {
                return NSOrderedDescending;
            }
        }
        else if (frame1.origin.y < frame2.origin.y) {
            return NSOrderedAscending;
        }
        else { //if (frame1.origin.y > frame2.origin.y) {
            return NSOrderedDescending;
        }
    };
    
    return [[positionComparator copy] autorelease];
}

- (NSArray *)applyToViews:(NSArray *)views {
    NSMutableArray* sortedViews = [[views mutableCopy] autorelease];
    
    [sortedViews sortUsingComparator:[self positionComparator]];
    
    return sortedViews;
}

@end
