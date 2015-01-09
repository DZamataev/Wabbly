//
//  NSDate+HumanInterval.h
//  Buzzalot
//
//  Created by David E. Wheeler on 2/18/10.
//  Copyright 2010-2011 Lunar/Theory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (WAAdditions)
- (NSString *)wa_humanIntervalSinceNow;
- (NSString *)wa_humanIntervalAgoSinceNow;
@end
