//
//  EZScheduledV2Cell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledV2Cell.h"

@implementation EZScheduledV2Cell
@synthesize taskName, startTime, endTime, alarmTitle, alarmStatus, nowSign;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setStatus:(EZScheduledStatus)status
{
    if(status == EZ_NOW){
        taskName.textColor = [UIColor blackColor];
        startTime.alpha = 0;
        endTime.alpha = 0;
    }else if(status == EZ_FUTURE){
        taskName.textColor = [UIColor blackColor];
        startTime.alpha = 1;
        endTime.alpha = 1;
    }else if(status == EZ_PASSED){
        taskName.textColor = [UIColor grayColor];
        startTime.alpha = 1;
        endTime.alpha = 1;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
