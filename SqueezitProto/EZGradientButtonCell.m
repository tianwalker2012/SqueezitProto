//
//  EZGradientButtonCell.m
//  SqueezitProto
//
//  Created by Apple on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZGradientButtonCell.h"

@implementation EZGradientButtonCell
@synthesize buttonTitle, gradientCtrl, clickedOps;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction) clicked:(id)sender
{
    if(clickedOps){
        clickedOps();
    }
}

@end
