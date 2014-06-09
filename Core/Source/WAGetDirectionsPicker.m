//
//  WAGetDirectionsPicker.m
//  WabblyDemo
//
//  Created by Denis Zamataev on 6/9/14.
//
//

#import "WAGetDirectionsPicker.h"

typedef enum {WAGetDirectionsPickerProviderTypeApple, WAGetDirectionsPickerProviderTypeGoogle, WAGetDirectionsPickerProviderTypeYandex} WAGetDirectionsPickerProviderType;

@implementation WAGetDirectionsPicker {
    NSDictionary *_buttonTitles;
}
//- (void)openMapsWithPoint:(CLLocationCoordinate2D)coord andTitle:(NSString *)title makeARoute:(BOOL)makeARoute{
//    
//    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary: nil];
//    
//    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
//    destination.name = title;
//    
//    
//    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
//    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
//                             MKLaunchOptionsDirectionsModeDriving,
//                             MKLaunchOptionsDirectionsModeKey,
//                             nil];
//    [MKMapItem openMapsWithItems: items launchOptions: options];
//    
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.endPointCoordinates = CGPointZero;
        self.startPointCoordinates = CGPointZero;
        self.makeARoute = YES;
    }
    return self;
}

- (void)showInView:(UIView*)view
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose application to get directions"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for (id titleKey in [[self buttonTitles] allKeys]) {
        
        NSNumber *numberForTitleKey = [[self buttonTitles] objectForKey:titleKey];
        if (numberForTitleKey) {
            WAGetDirectionsPickerProviderType providerType = (WAGetDirectionsPickerProviderType)[numberForTitleKey integerValue];
            NSString *urlScheme = [self urlSchemeForProviderType:providerType];
            if (urlScheme) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlScheme]]) {
                    [self.actionSheet addButtonWithTitle:NSLocalizedStringFromTable(titleKey, @"WAGetDirectionsPickerLocalizable", nil)];
                }
            }
        }
        
    }
    
    NSString *cancelButtonTitle = @"Cancel";
    [self.actionSheet addButtonWithTitle:cancelButtonTitle];
    self.actionSheet.cancelButtonIndex = [self.actionSheet numberOfButtons] - 1;
    
    [self.actionSheet showInView:view];
}

- (NSString*)urlSchemeForProviderType:(WAGetDirectionsPickerProviderType)providerType
{
    NSString *result = nil;
    switch (providerType) {
        case WAGetDirectionsPickerProviderTypeApple:
            result = @"http://maps.apple.com/";
            break;
            
        case WAGetDirectionsPickerProviderTypeGoogle:
            result = @"comgooglemaps://";
            break;
            
        case WAGetDirectionsPickerProviderTypeYandex:
            result = @"yandexnavi://";
            break;
            
        default:
            break;
    }
    return result;
}

- (NSDictionary*)buttonTitles {
    if (!_buttonTitles) {
        _buttonTitles = @{
                          @"Apple Maps": [NSNumber numberWithInteger:WAGetDirectionsPickerProviderTypeApple],
                          @"Google Maps": [NSNumber numberWithInteger:WAGetDirectionsPickerProviderTypeGoogle],
                          @"Yandex Navigator": [NSNumber numberWithInteger:WAGetDirectionsPickerProviderTypeYandex]
                          };
    }
    return _buttonTitles;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString *titleKey = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSNumber *numberForTitleKey = [[self buttonTitles] objectForKey:titleKey];
        if (numberForTitleKey) {
            WAGetDirectionsPickerProviderType providerType = (WAGetDirectionsPickerProviderType)[numberForTitleKey integerValue];
            [self getDirectionsFromProviderWithType:providerType];
        }
    }
}

- (void)getDirectionsFromProviderWithType:(WAGetDirectionsPickerProviderType)providerType
{
    switch (providerType) {
        case WAGetDirectionsPickerProviderTypeApple:
            [self showAppleMaps];
        break;
            
        case WAGetDirectionsPickerProviderTypeGoogle:
            [self showGoogleMaps];
        break;
        
        case WAGetDirectionsPickerProviderTypeYandex:
            [self showYandexMaps];
        break;

        default:
            break;
    }
}

- (void)showAppleMaps
{
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:[self urlSchemeForProviderType:WAGetDirectionsPickerProviderTypeApple]];
    [urlStr appendString:@"?"];
    [self appendStandardParametersToString:urlStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (void)showGoogleMaps
{
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:[self urlSchemeForProviderType:WAGetDirectionsPickerProviderTypeGoogle]];
    [urlStr appendString:@"?"];
    [self appendStandardParametersToString:urlStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (void)showYandexMaps
{
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:[self urlSchemeForProviderType:WAGetDirectionsPickerProviderTypeYandex]];
    [urlStr appendString:@"build_route_on_map?"];
    if (!CGPointEqualToPoint(self.startPointCoordinates, CGPointZero)) {
        [urlStr appendString:[NSString stringWithFormat:@"lat_from=%f&lon_from=%f&",self.startPointCoordinates.x, self.startPointCoordinates.y]];
    }
    if (!CGPointEqualToPoint(self.endPointCoordinates, CGPointZero)) {
        [urlStr appendString:[NSString stringWithFormat:@"lat_to=%f&lon_to=%f&",self.endPointCoordinates.x, self.endPointCoordinates.y]];
    }
    if ([[urlStr substringFromIndex:urlStr.length-1] isEqualToString:@"&"]) {
        [urlStr replaceCharactersInRange:NSMakeRange(urlStr.length-1, 1) withString:@""];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (void)appendStandardParametersToString:(NSMutableString*)urlStr
{
    if (!CGPointEqualToPoint(self.startPointCoordinates, CGPointZero)) {
        [urlStr appendString:[NSString stringWithFormat:@"saddr=%f,%f&", self.startPointCoordinates.x, self.startPointCoordinates.y]];
    }
    if (!CGPointEqualToPoint(self.endPointCoordinates, CGPointZero)) {
        [urlStr appendString:[NSString stringWithFormat:@"daddr=%f,%f&", self.endPointCoordinates.x, self.endPointCoordinates.y]];
    }
    if ([[urlStr substringFromIndex:urlStr.length-1] isEqualToString:@"&"]) {
        [urlStr replaceCharactersInRange:NSMakeRange(urlStr.length-1, 1) withString:@""];
    }
}


@end
