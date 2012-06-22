//
//  EZScheduledTaskCell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledTaskCell.h"

@implementation EZScheduledTaskCell
@synthesize taskName, timeSpan, alarmType, switchButton, switchChange, nowSign;

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

- (IBAction) switchTapped:(id)sender
{
    if(switchChange){
        switchChange(sender);
    }
}

@end
