//
//  EZButtonCell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZButtonCell.h"

@implementation EZButtonCell
@synthesize button, clickedOps;

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

- (IBAction) buttonClicked:(id)sender
{
    if(clickedOps){
        clickedOps(self);
    }
}

@end
