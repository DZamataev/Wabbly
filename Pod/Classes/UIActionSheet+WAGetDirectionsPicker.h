//
//  UIActionSheet+WAGetDirectionsPicker.h
//  WabblyDemo
//
//  Created by Denis Zamataev on 6/10/14.
//
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@class WAGetDirectionsPicker;

@interface UIActionSheet (WAGetDirectionsPicker)
- (void)setWa_getDirectionsPicker:(WAGetDirectionsPicker *)wa_getDirectionsPicker;

- (WAGetDirectionsPicker *)wa_getDirectionsPicker;
@end
