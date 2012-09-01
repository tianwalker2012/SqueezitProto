//
//  CustomGradientButon.m
//  GradientComponents
//
//  Created by Michael Stringer on 23/01/2012.
//  Copyright (c) 2012 Michael Stringer. All rights reserved.
//

#import "CustomGradientButon.h"
#import "EZTaskHelper.h"


@interface CustomGradientButon()

- (void) initInner;

@end

@implementation CustomGradientButon

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self initInner];
    }
    return self;
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initInner];
    }

    return self;
}

- (void) initInner
{
    [self setNormalColors:[NSArray arrayWithObjects:
                           [UIColor createByHex:@"a9aeba"],
                           [UIColor createByHex:@"7e8790"],
                           [UIColor createByHex:@"6f778b"],
                           [UIColor createByHex:@"5b657d"],
                           nil]
            withLocations:[NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.51],
                           [NSNumber numberWithFloat:1],
                           nil]];
    
    [self setHighlightColors:[NSArray arrayWithObjects:
                              [UIColor createByHex:@"a9aeba"],
                              [UIColor createByHex:@"7e8790"],
                              [UIColor createByHex:@"4b5366"],
                              nil]
               withLocations:[NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1],
                              nil]];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 6, 200, 20)];
    titleLabel.text = @"Custom Component";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    
    subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, 200, 20)];
    subtitleLabel.text = @"Created from code...";
    subtitleLabel.font = [UIFont systemFontOfSize:13];
    subtitleLabel.backgroundColor = [UIColor clearColor];
    subtitleLabel.textColor = [UIColor whiteColor];
    [self addSubview:subtitleLabel];

}

@end
