//
//  WAGetDirectionsPicker.h
//  WabblyDemo
//
//  Created by Denis Zamataev on 6/9/14.
//
//

#import <Foundation/Foundation.h>

@interface WAGetDirectionsPicker : NSObject <UIActionSheetDelegate>
@property CGPoint startPointCoordinates;
@property CGPoint endPointCoordinates;
@property BOOL makeARoute;
@property UIActionSheet *actionSheet;
@property NSString *title;

- (void)showInView:(UIView*)view;
@end
