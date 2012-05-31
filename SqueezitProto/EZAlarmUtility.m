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
#import "EZTask.h"

@implementation EZAlarmUtility


+ (void) setupAlarmBulk:(NSArray*)tasks
{
    for(EZScheduledTask* schTask in tasks){
        [self setupAlarm:schTask];
    }
}

+ (void) cancelAlarmBulk:(NSArray*)tasks
{
    for(EZScheduledTask* schTask in tasks){
        [self cancelAlarm:schTask];
    }
}

//Setup the alarm for task
+ (void) setupAlarm:(EZScheduledTask*)task
{
    EZDEBUG(@"Setup alarm for:%@",[task detail]);
    if(task.alarmNotification){
        [self cancelAlarm:task];
    }
    
    
    if([task.startTime timeIntervalSinceNow] <= 0){ //mean already passed.
        EZDEBUG(@"Do not setup alarm for %@, because it already passed, the time:%@",task.task.name,task.startTime);
        return;
    }
    
    UILocalNotification* nofication = [[UILocalNotification alloc] init];
    nofication.fireDate = task.startTime;
    nofication.alertBody = task.task.name;
    //Mean I can pick my own customized name?
    nofication.soundName = task.task.soundName;
    nofication.applicationIconBadgeNumber = 1;
    NSDictionary* infoDict = [NSDictionary dictionaryWithObjectsAndKeys:task.task.name,@"task",nil];
    nofication.userInfo = infoDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:nofication];
    task.alarmNotification = nofication;
    
}

//Cancel the alarm for task
+ (void) cancelAlarm:(EZScheduledTask*)task
{
    EZDEBUG(@"Cancel alarm for:%@",[task detail]);
    if(task.alarmNotification){
        [[UIApplication sharedApplication] cancelLocalNotification:task.alarmNotification];
        task.alarmNotification = nil;
    }
}

@end
