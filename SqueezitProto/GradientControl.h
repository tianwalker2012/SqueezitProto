//
//  GradientControl.h
//  GradientComponents
//
//  Created by Michael Stringer on 23/01/2012.
//  Copyright (c) 2012 Michael Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


//Honestly, I know nothing about GradiantLayers
//But I knew a little bit about Photoshop.
//Gradient layer, just like a layer. It can create some expected effects. 
//Based on the code, it made a assumption that once the color in the gradient layer changed, the effect will change accordingly. 
//Let's use a simple test to verify this. 
@interface GradientControl : UIControl
{
    @private
    // background layers
    CAGradientLayer *normalBackground;
    CAGradientLayer *highlightBackground;
}



- (void) setCornerRadius:(float)aCornerRadius;
- (void) setBorderColor:(UIColor *)aBorderColor;
- (void) setBorderWidth:(float)aBorderWidth;
- (void) setNormalColors:(NSArray *)aColors withLocations:(NSArray *)aLocations;
- (void) setHighlightColors:(NSArray *)aColors withLocations:(NSArray *)aLocations;

//If something not take effect, I wish this could change it.
- (void) refresh;

- (void) changeToRed;


@end
