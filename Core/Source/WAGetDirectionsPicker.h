//
//  WAGetDirectionsPicker.h
//  WabblyDemo
//
//  Created by Denis Zamataev on 6/9/14.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    WAGetDirectionsPickerProviderTypeApple,
    WAGetDirectionsPickerProviderTypeGoogle,
    WAGetDirectionsPickerProviderTypeYandexNavigator,
    WAGetDirectionsPickerProviderTypeYandexMaps
}
WAGetDirectionsPickerProviderType;

@interface WAGetDirectionsPicker : NSObject <UIActionSheetDelegate>
@property CGPoint startPointCoordinates; // defaults to CGPointZero
@property CGPoint endPointCoordinates; // defaults to CGPointZero
@property BOOL makeARoute; // defaults to YES
@property UIActionSheet *actionSheet;

- (void)showInView:(UIView*)view;

- (void)getDirectionsFromProviderWithType:(WAGetDirectionsPickerProviderType)providerType;

- (void)showAppleMaps;

- (void)showGoogleMaps;

- (void)showYandexNavigator;

- (void)showYandexMaps;

@end
