//
//  EZScheduledCell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledCell.h"

@implementation EZScheduledCell
@synthesize title, timeSpanTitle, alarmButton, clickBlock;

- (void) setButtonStatus:(NSNumber*) numType
{
    EZAlarmType type = numType.integerValue;
    if(type == EZ_SOUND){
        alarmButton.titleLabel.text = @"V";
    }else if(type == EZ_SHAKE){
        alarmButton.titleLabel.text = @"S";
    }else{
        alarmButton.titleLabel.text = @"M";
    }
}

- (IBAction)buttonClicked:(id)sender
{
    if(clickBlock){
        clickBlock();
    }
}

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

@end
