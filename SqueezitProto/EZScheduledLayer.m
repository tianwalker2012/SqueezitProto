//
//  EZScheduledLayer.m
//  SqueezitProto
//
//  Created by Apple on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledLayer.h"

@implementation EZScheduledLayer
@synthesize infoLabel, button, clickedBlock, activityView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    activityView.alpha = 0;
}

- (IBAction)clicked:(id)sender
{
    if(clickedBlock){
        clickedBlock();
    }
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
