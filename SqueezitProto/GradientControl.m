//
//  GradientControl.m
//  GradientComponents
//
//  Created by Michael Stringer on 23/01/2012.
//  Copyright (c) 2012 Michael Stringer. All rights reserved.
//

#import "GradientControl.h"
#import "EZTaskHelper.h"


@interface GradientControl()

- (void) initInner;

@end


@implementation GradientControl

//I want to be able to create programmic way
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initInner];
    return self;
}

- (void) initInner
{
    self.backgroundColor = [UIColor clearColor];
    
    // set up background layers
    normalBackground = [CAGradientLayer layer];
    normalBackground.frame = self.bounds;
    normalBackground.cornerRadius = 10;
    normalBackground.borderWidth = 1;
    normalBackground.borderColor = [[UIColor whiteColor] CGColor];
    
    normalBackground.colors = [NSArray arrayWithObjects:
                               (id)[[UIColor createByHex:@"a9aeba"] CGColor],
                               (id)[[UIColor createByHex:@"7e8790"] CGColor],
                               (id)[[UIColor createByHex:@"6f778b"] CGColor],
                               (id)[[UIColor createByHex:@"5b657d"] CGColor],
                               nil];
    normalBackground.locations = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0],
                                  [NSNumber numberWithFloat:0.5],
                                  [NSNumber numberWithFloat:0.51],
                                  [NSNumber numberWithFloat:1],
                                  nil];
    
    highlightBackground = [CAGradientLayer layer];
    highlightBackground.frame = self.bounds;
    highlightBackground.cornerRadius = 10;
    highlightBackground.borderWidth = 1;
    highlightBackground.borderColor = [[UIColor whiteColor] CGColor];
    
    highlightBackground.colors = [NSArray arrayWithObjects:
                                  (id)[[UIColor createByHex:@"a9aeba"] CGColor],
                                  (id)[[UIColor createByHex:@"7e8790"] CGColor],
                                  (id)[[UIColor createByHex:@"4b5366"] CGColor],
                                  nil];
    highlightBackground.locations = [NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0],
                                     [NSNumber numberWithFloat:0.5],
                                     [NSNumber numberWithFloat:1],
                                     nil];
    
    [self.layer insertSublayer:normalBackground atIndex:0];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initInner];
    }
    
    return self;
}

- (void) setCornerRadius:(float)aCornerRadius
{
    normalBackground.cornerRadius = aCornerRadius;
    highlightBackground.cornerRadius = aCornerRadius;
}

- (void) setBorderColor:(UIColor *)aBorderColor
{
    normalBackground.borderColor = [aBorderColor CGColor];
    highlightBackground.borderColor = [aBorderColor CGColor];
}

- (void) setBorderWidth:(float)aBorderWidth;
{
    normalBackground.borderWidth = aBorderWidth;
    highlightBackground.borderWidth = aBorderWidth;
}

//To simplify the application level code.
- (void) changeToRed
{
    [self setNormalColors:[NSArray arrayWithObjects:
                                              [UIColor createByHex:@"f4b0b1"],
                                              [UIColor createByHex:@"db6b69"],
                                              [UIColor createByHex:@"d15b56"],
                                              [UIColor createByHex:@"c54546"],
                                              nil]
     
                               withLocations:[NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0],
                                              [NSNumber numberWithFloat:0.5],
                                              [NSNumber numberWithFloat:0.51],
                                              [NSNumber numberWithFloat:1],
                                              nil]];
    [self setHighlightColors:[NSArray arrayWithObjects:
                                                 [UIColor createByHex:@"f4b0b1"],
                                                 [UIColor createByHex:@"db6b69"],
                                                 [UIColor createByHex:@"c54546"],
                                                 nil]
                                  withLocations:[NSArray arrayWithObjects:
                                                 [NSNumber numberWithFloat:0],
                                                 [NSNumber numberWithFloat:0.5],
                                                 [NSNumber numberWithFloat:1],
                                                 nil]];

}

- (void) setNormalColors:(NSArray *)aColors withLocations:(NSArray *)aLocations
{
    if ([aColors count] != [aLocations count])
    {
        [NSException raise:@"Invalid normal colors"
                    format:@"Tried to set with %d colors and %d locations", [aColors count], [aLocations count]];
    }
    
    NSMutableArray *cgColorArray = [NSMutableArray array];
    
    for (UIColor *color in aColors)
    {
        [cgColorArray addObject:(id)[color CGColor]];
    }
    
    normalBackground.colors = cgColorArray;
    normalBackground.locations = aLocations;
}

//If something not take effect, I wish this could change it.
- (void) refresh
{
    if(self.highlighted){
        [highlightBackground removeFromSuperlayer];
        [self.layer addSublayer:highlightBackground]; 
    }else{
        [normalBackground removeFromSuperlayer];
        [self.layer addSublayer:normalBackground];
    }
}

- (void) setHighlightColors:(NSArray *)aColors withLocations:(NSArray *)aLocations
{
    if ([aColors count] != [aLocations count])
    {
        [NSException raise:@"Invalid highlight colors"
                    format:@"Tried to set with %d colors and %d locations", [aColors count], [aLocations count]];
    }
    
    NSMutableArray *cgColorArray = [NSMutableArray array];
    
    for (UIColor *color in aColors)
    {
        [cgColorArray addObject:(id)[color CGColor]];
    }
    
    highlightBackground.colors = cgColorArray;
    highlightBackground.locations = aLocations;
}

- (void) setHighlighted:(BOOL)aHighlighted
{
    BOOL oldHighlighted = self.highlighted;
    [super setHighlighted:aHighlighted];
    
    if (oldHighlighted == aHighlighted)
    {
        return;
    }
    
    if (aHighlighted)
    {
        [self.layer replaceSublayer:normalBackground with:highlightBackground];
    }
    else
    {
        [self.layer replaceSublayer:highlightBackground with:normalBackground];
    }
}

@end
