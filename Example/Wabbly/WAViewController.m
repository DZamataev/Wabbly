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
    [self weakselfexample];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)weakselfexample {
    self.block = @weakself(^(NSObject * obj)) {
        NSLog(@"%@", [self description]);
        return 0;
    } @weakselfend;
    
    self.block([NSArray new]);
}

- (IBAction)pickGetDirectionsProviderAction:(id)sender {
    // can be unretained
    WAGetDirectionsPicker *getDirectionsPicker = [WAGetDirectionsPicker new];
    getDirectionsPicker.destinationAddress = [@"улица Широкая, Москва, Россия" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    getDirectionsPicker.sourceAddress = [@"улица Пришвина, Москва, Россия" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    getDirectionsPicker.startPointCoordinates = CGPointMake(55.751667,37.617778);
    getDirectionsPicker.endPointCoordinates = CGPointMake(55.819722, 37.611667);
    [getDirectionsPicker showInView:self.view];
}
@end
