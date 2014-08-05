//
//  WAViewController.h
//  WabblyDemo
//
//  Created by Denis Zamataev on 4/8/14.
//
//

#import <UIKit/UIKit.h>
#import "Wabbly.h"

@interface WAViewController : UIViewController
- (IBAction)pickGetDirectionsProviderAction:(id)sender;
@property (nonatomic, copy) int (^block)(NSObject * obj);
@end
