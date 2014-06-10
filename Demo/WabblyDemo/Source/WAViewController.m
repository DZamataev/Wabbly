//
//  WAViewController.m
//  WabblyDemo
//
//  Created by Denis Zamataev on 4/8/14.
//
//

#import "WAViewController.h"

@interface WAViewController ()

@end

@implementation WAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickGetDirectionsProviderAction:(id)sender {
    // can be not retained
    WAGetDirectionsPicker *getDirectionsPicker = [WAGetDirectionsPicker new];
    getDirectionsPicker.startPointCoordinates = CGPointMake(55.751667,37.617778);
    getDirectionsPicker.endPointCoordinates = CGPointMake(55.819722, 37.611667);
    [getDirectionsPicker showInView:self.view];
}
@end
