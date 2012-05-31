//
//  EZScheduledTask.m
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledTask.h"
#import "EZTask.h"
#import "EZTaskHelper.h"

@implementation EZScheduledTask
@synthesize startTime, duration, task, envTraits, alarmNotification;

- (NSString*) detail
{
    return [NSString stringWithFormat:@"Name:%@, start at:%@, duration:%i, envTraits:%i",task.name,[startTime stringWithFormat:@"yyyyMMdd>HH:mm:ss"],duration,envTraits];
}

@end
