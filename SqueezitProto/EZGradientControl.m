//
//  EZGradientControl.m
//  SqueezitProto
//
//  Created by Apple on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZGradientControl.h"
#import <QuartzCore/QuartzCore.h>
#import "EZTaskHelper.h"

@interface EZGradientControl()
{
    CAGradientLayer* normalBackground;
    CAGradientLayer* highlightBackground;
    
}
@end


@implementation EZGradientControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = [UIColor clearColor];
        
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
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
