//
//  UIStoryboard+WAAdditions.m
//  Pods
//
//  Created by Admin on 12/01/15.
//
//

#import "UIStoryboard+WAAdditions.h"

UIStoryboard *_mainStoryboard = nil;

@implementation UIStoryboard (WAAdditions)
+ (instancetype)wa_MainStoryboard {
    if (!_mainStoryboard) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *storyboardName = [bundle objectForInfoDictionaryKey:@"UIMainStoryboardFile"];
        _mainStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:bundle];
    }
    return _mainStoryboard;
}
@end
