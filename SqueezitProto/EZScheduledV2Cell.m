//
//  EZScheduledV2Cell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledV2Cell.h"

@interface EZScheduledV2Cell()
{
    UIView* nowSign;
}

@end


@implementation EZScheduledV2Cell
@synthesize taskName, startTime, endTime, alarmTitle, alarmStatus;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setStatus:(EZScheduledStatus)status nowSign:(UIView*)cv
{
    if(status == EZ_NOW){
        taskName.textColor = [UIColor blackColor];
        startTime.alpha = 0;
        endTime.alpha = 0;
        nowSign = cv;
        [self addSubview:nowSign];
    }else if(status == EZ_FUTURE){
        if(nowSign){
           [nowSign removeFromSuperview];
            nowSign = nil;
            EZDEBUG(@"Remove for future:%@", self.taskName.text);
        }
        taskName.textColor = [UIColor blackColor];
        startTime.alpha = 1;
        endTime.alpha = 1;
    }else if(status == EZ_PASSED){
        if(nowSign){
            [nowSign removeFromSuperview];
            nowSign = nil;
            EZDEBUG(@"Remove for passed:%@", self.taskName.text);
        }
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
