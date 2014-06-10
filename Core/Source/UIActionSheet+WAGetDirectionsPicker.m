//
//  UIActionSheet+WAGetDirectionsPicker.m
//  WabblyDemo
//
//  Created by Denis Zamataev on 6/10/14.
//
//

#import "UIActionSheet+WAGetDirectionsPicker.h"
NSString * const kWAGetDiretionsPickerAssociationKey = @"kWAGetDiretionsPickerAssociationKey";
//static void * const kWAGetDiretionsPickerAssociationKey = (void*)&kWAGetDiretionsPickerAssociationKey;

@implementation UIActionSheet (WAGetDirectionsPicker)

- (void)setWa_getDirectionsPicker:(WAGetDirectionsPicker *)wa_getDirectionsPicker
{
    objc_setAssociatedObject(self, (__bridge const void *)(kWAGetDiretionsPickerAssociationKey), wa_getDirectionsPicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WAGetDirectionsPicker *)wa_getDirectionsPicker
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kWAGetDiretionsPickerAssociationKey));
}

@end
