//
//  WAGetDirectionsPicker.m
//  WabblyDemo
//
//  Created by Denis Zamataev on 6/9/14.
//
//

#import "WAGetDirectionsPicker.h"

@implementation WAGetDirectionsPicker {
    NSArray *_providers;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.endPointCoordinates = CGPointZero;
        self.startPointCoordinates = CGPointZero;
        self.makeARoute = YES;
        _providers = @[
                       [NSNumber numberWithInteger:WAGetDirectionsPickerProviderTypeApple],
                       [NSNumber numberWithInteger:WAGetDirectionsPickerProviderTypeGoogle],
                       [NSNumber numberWithInteger:WAGetDirectionsPickerProviderTypeYandexNavigator],
                       [NSNumber numberWithInteger:WAGetDirectionsPickerProviderTypeYandexMaps]
                       ];
    }
    return self;
}

- (void)showInView:(UIView*)view
{
    NSString *localizationTableName = @"WAGetDirectionsPickerLocalizable";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedStringFromTable(@"Choose application to get directions", localizationTableName, nil)
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for (NSNumber *num in _providers) {
        WAGetDirectionsPickerProviderType providerType = (WAGetDirectionsPickerProviderType)[num integerValue];
        NSString *keyName = [self keyNameForProviderType:providerType];
        NSString *urlScheme = [self urlSchemeForProviderType:providerType];
        NSString *localizedTitle = NSLocalizedStringFromTable(keyName, localizationTableName, nil);
        NSURL *urlFromScheme = [NSURL URLWithString:urlScheme];
        if ([[UIApplication sharedApplication] canOpenURL:urlFromScheme]) {
            [actionSheet addButtonWithTitle:localizedTitle];
        }
    }
    
    NSString *cancelButtonTitle = NSLocalizedStringFromTable(@"Cancel", localizationTableName, nil);
    [actionSheet addButtonWithTitle:cancelButtonTitle];
    actionSheet.cancelButtonIndex = [actionSheet numberOfButtons] - 1;
    actionSheet.wa_getDirectionsPicker = self;
    [actionSheet showInView:view];
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
            
        case WAGetDirectionsPickerProviderTypeYandexNavigator:
            result = @"yandexnavi://";
            break;
            
        case WAGetDirectionsPickerProviderTypeYandexMaps:
            result = @"yandexmaps://";
            break;
            
        default:
            break;
    }
    return result;
}


- (NSString*)keyNameForProviderType:(WAGetDirectionsPickerProviderType)providerType
{
    NSString *result = nil;
    switch (providerType) {
        case WAGetDirectionsPickerProviderTypeApple:
            result = @"Apple Maps";
            break;
            
        case WAGetDirectionsPickerProviderTypeGoogle:
            result = @"Google Maps";
            break;
            
        case WAGetDirectionsPickerProviderTypeYandexNavigator:
            result = @"Yandex Navigator";
            break;
            
        case WAGetDirectionsPickerProviderTypeYandexMaps:
            result = @"Yandex Maps";
            break;
            
        default:
            break;
    }
    return result;
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
        
        case WAGetDirectionsPickerProviderTypeYandexNavigator:
            [self showYandexNavigator];
        break;
            
        case WAGetDirectionsPickerProviderTypeYandexMaps:
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

- (void)showYandexNavigator
{
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:[self urlSchemeForProviderType:WAGetDirectionsPickerProviderTypeYandexNavigator]];
    [urlStr appendString:@"build_route_on_map?"];
    if (!CGPointEqualToPoint(self.startPointCoordinates, CGPointZero)) {
        [urlStr appendFormat:@"lat_from=%f&lon_from=%f&",self.startPointCoordinates.x, self.startPointCoordinates.y];
    }
    if (!CGPointEqualToPoint(self.endPointCoordinates, CGPointZero)) {
        [urlStr appendFormat:@"lat_to=%f&lon_to=%f&",self.endPointCoordinates.x, self.endPointCoordinates.y];
    }
    if ([[urlStr substringFromIndex:urlStr.length-1] isEqualToString:@"&"]) {
        [urlStr replaceCharactersInRange:NSMakeRange(urlStr.length-1, 1) withString:@""];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (void)showYandexMaps
{
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:[self urlSchemeForProviderType:WAGetDirectionsPickerProviderTypeYandexMaps]];
    [urlStr appendString:@"maps.yandex.ru/?"];
    if (!CGPointEqualToPoint(self.endPointCoordinates, CGPointZero)) {
        [urlStr appendFormat:@"ll=%f,%f&z=12&l=map&pt=%f,%f", self.endPointCoordinates.y, self.endPointCoordinates.x, self.endPointCoordinates.y, self.endPointCoordinates.x];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (void)appendStandardParametersToString:(NSMutableString*)urlStr
{
    if (!CGPointEqualToPoint(self.startPointCoordinates, CGPointZero)) {
        [urlStr appendFormat:@"saddr=%f,%f&", self.startPointCoordinates.x, self.startPointCoordinates.y];
    }
    if (!CGPointEqualToPoint(self.endPointCoordinates, CGPointZero)) {
        [urlStr appendFormat:@"daddr=%f,%f&", self.endPointCoordinates.x, self.endPointCoordinates.y];
    }
    if ([[urlStr substringFromIndex:urlStr.length-1] isEqualToString:@"&"]) {
        [urlStr replaceCharactersInRange:NSMakeRange(urlStr.length-1, 1) withString:@""];
    }
}


#pragma mark - UIActionSheetDelegate protocol implementation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSNumber *num = _providers[buttonIndex];
        WAGetDirectionsPickerProviderType providerType = (WAGetDirectionsPickerProviderType)[num integerValue];
        [self getDirectionsFromProviderWithType:providerType];
    }
//    actionSheet.delegate = nil;
//    actionSheet.wa_getDirectionsPicker = nil;
}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
//    actionSheet.delegate = nil;
//    actionSheet.wa_getDirectionsPicker = nil;
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    actionSheet.delegate = nil;
//    actionSheet.wa_getDirectionsPicker = nil;
}
@end
