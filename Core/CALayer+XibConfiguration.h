#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (XibConfiguration)

@property (nonatomic, assign) UIColor* borderUIColor;
@property (nonatomic, assign) UIColor* shadowUIColor;
@property (nonatomic, assign) BOOL rasterizationScaleWithMainScreenScale;
@end
