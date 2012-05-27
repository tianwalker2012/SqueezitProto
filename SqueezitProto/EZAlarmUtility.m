//
//  EZAlarmUtility.m
//  SqueezitProto
//
//  Created by Apple on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAlarmUtility.h"
#import "Constants.h"
#import "EZScheduledTask.h"

@implementation EZAlarmUtility

//Setup the alarm for task
+ (void) setupAlarm:(EZScheduledTask*)task
{
    EZDEBUG(@"Setup alarm for:%@",[task detail]);
}

//Cancel the alarm for task
+ (void) cancelAlarm:(EZScheduledTask*)task
{
    EZDEBUG(@"Cancel alarm for:%@",[task detail]);
}

@end
