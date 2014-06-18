//
//  SenTestCase+Extensions.h
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#if TARGET_OS_IPHONE
#define ShelleyTestObject    UIView
#define ShelleyTestView      UIView
#define ShelleyTestButton    UIButton
#define ShelleyTestTableView UITableView
#define ShelleyTestTableCell UITableViewCell
#else
#define ShelleyTestObject    NSObject
#define ShelleyTestView      NSView
#define ShelleyTestButton    NSButton
#define ShelleyTestTableView NSTableView
#define ShelleyTestTableCell NSTextView
#endif

@interface SenTestCase(Extensions)
- (void) assertArray:(NSArray *)array containsObjects:(NSArray *)objects;
- (void) assertArray:(NSArray *)array containsExactlyObjects:(NSArray *)objects;
- (void) assertArray:(NSArray *)array containsObject:(id)object;
@end
