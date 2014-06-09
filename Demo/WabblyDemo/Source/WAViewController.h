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
@property WAGetDirectionsPicker *getDirectionsPicker;
- (IBAction)pickGetDirectionsProviderAction:(id)sender;

@end
