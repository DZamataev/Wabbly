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
    // should be retained
    self.getDirectionsPicker = [WAGetDirectionsPicker new];
    self.getDirectionsPicker.title = @"Москва";
    self.getDirectionsPicker.startPointCoordinates = CGPointMake(51,30);
    self.getDirectionsPicker.endPointCoordinates = CGPointMake(50.0, 30.0);
    [self.getDirectionsPicker showInView:self.view];
}
@end
