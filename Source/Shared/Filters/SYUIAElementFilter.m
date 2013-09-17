//
//  SYUIAElementFilter.m
//  Shelley
//
//  Created by Ondrej Hanslik on 8/29/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "SYUIAElementFilter.h"

@interface SYUIAElementFilter ()

@property (nonatomic, assign, readwrite) UIAccessibilityTraits traitsFilter;

@end

@implementation SYUIAElementFilter

@synthesize traitsFilter = _traitsFilter;

#pragma mark - Traits parsing

+ (UIAccessibilityTraits)traitFromString:(NSString *)traitString {
    traitString = [traitString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([traitString isEqualToString:@"button"]) {
        return UIAccessibilityTraitButton;
    }
    else if ([traitString isEqualToString:@"link"]) {
        return UIAccessibilityTraitLink;
    }
    else if ([traitString isEqualToString:@"header"]) {
        return UIAccessibilityTraitHeader;
    }
    else if ([traitString isEqualToString:@"search-field"]) {
        return UIAccessibilityTraitSearchField;
    }
    else if ([traitString isEqualToString:@"image"]) {
        return UIAccessibilityTraitImage;
    }
    else if ([traitString isEqualToString:@"selected"]) {
        return UIAccessibilityTraitSelected;
    }
    else if ([traitString isEqualToString:@"plays-sound"]) {
        return UIAccessibilityTraitPlaysSound;
    }
    else if ([traitString isEqualToString:@"keyboard-key"]) {
        return UIAccessibilityTraitKeyboardKey;
    }
    else if ([traitString isEqualToString:@"static-text"]) {
        return UIAccessibilityTraitStaticText;
    }
    else if ([traitString isEqualToString:@"not-enabled"]) {
        return UIAccessibilityTraitNotEnabled;
    }
    else if ([traitString isEqualToString:@"updates-frequently"]) {
        return UIAccessibilityTraitUpdatesFrequently;
    }
    else if ([traitString isEqualToString:@"starts-media-session"]) {
        return UIAccessibilityTraitStartsMediaSession;
    }
    else if ([traitString isEqualToString:@"adjustable"]) {
        return UIAccessibilityTraitAdjustable;
    }
    else if ([traitString isEqualToString:@"allows-direct-interaction"]) {
        return UIAccessibilityTraitAllowsDirectInteraction;
    }
    else if ([traitString isEqualToString:@"causes-page-turn"]) {
        return UIAccessibilityTraitCausesPageTurn;
    }
    else {
        [NSException raise:@"Invalid Accessibility Traits"
                    format:@"Cannot parse accessibility traits \"%@\"", traitString];
        
        return nil;
    }
}

+ (UIAccessibilityTraits)traitsFilterFromString:(NSString *)traitsString {
    NSArray *traitStrings = [traitsString componentsSeparatedByString:@","];
    
    UIAccessibilityTraits traitsFilter = UIAccessibilityTraitNone;
    
    for (NSString *traitString in traitStrings) {
        traitsFilter |= [self traitFromString:traitString];
    }
    
    return traitsFilter;
}

#pragma mark - Life cycle

- (id)init {
    return [self initWithTraitsFilter:nil];
}

- (id)initWithTraitsFilter:(NSString*)traitsString {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.traitsFilter = [[self class] traitsFilterFromString:traitsString];
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - Filter implementation

+ (NSArray *)allDescendantsOf:(NSObject *)element{
    NSMutableArray *descendants = [NSMutableArray array];
    
    if ([element isKindOfClass:[UIApplication class]]) {
        for (UIWindow *window in [(UIApplication *) element windows]) {
            [descendants addObject:window];
            [descendants addObjectsFromArray:[self allDescendantsOf:window]];
        }
    }
    else if ([element isKindOfClass:[UIView class]]) {
        for (UIView *subview in [(UIView *) element subviews]) {
            [descendants addObject:subview];
            [descendants addObjectsFromArray:[self allDescendantsOf:subview]];
        }
    }

    if (![element respondsToSelector:@selector(accessibilityElementCount)]) {
        return descendants;
    }

    NSInteger elementCount = [(id) element accessibilityElementCount];
    
    if (elementCount <= 0 || elementCount == NSNotFound) {
        return descendants;
    }
    
    for (NSInteger i = 0; i < elementCount; i++) {
        NSObject *subelement = [element accessibilityElementAtIndex:i];
        
        if (subelement != nil) {
            [descendants addObject:subelement];
        }
    }

    return descendants;
}

- (NSArray *)elementsToConsiderFromElement:(NSObject *)element {
    NSMutableArray *elements = [NSMutableArray array];
    
    [elements addObject:element];
    [elements addObjectsFromArray:[[self class] allDescendantsOf:element]];
    
    return elements;
}

-(NSArray *)applyToView:(NSObject *)view{
    NSArray *elements = [self elementsToConsiderFromElement:view];
    
    if (self.traitsFilter == UIAccessibilityTraitNone) {
        return elements;
    }
    
    NSMutableArray* filteredElements = [NSMutableArray array];
    
    for (NSObject *element in elements) {
        if ([element respondsToSelector:@selector(accessibilityTraits)]) {
            UIAccessibilityTraits accessibilityTraits = [element accessibilityTraits];
            
            if ((accessibilityTraits & self.traitsFilter) == self.traitsFilter) {
                [filteredElements addObject:element];
            }
        }
    }
    
    return filteredElements;
}

@end
