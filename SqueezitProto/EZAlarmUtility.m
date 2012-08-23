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
#import "MScheduledTask.h"
#import "EZTaskStore.h"
#import "EZGlobalLocalize.h"

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

//Although I don't know what to do in this method but just let us 
//Make all the processes weaved
+ (void) changeAlarmMode:(EZScheduledTask*)task
{
    EZDEBUG(@"Change Alarm Mode:%@, alarmType:%i",task.task.name,task.alarmType);
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
    NSDictionary* infoDict = [NSDictionary dictionaryWithObjectsAndKeys:task.PO.objectID.URIRepresentation.absoluteString ,EZNotificationKey ,nil];
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

//No test case to cover this. 
//Add one. As long as you are dealing with the code act as if you have the whole universe time with you.
+ (void) setupDailyNotification:(UILocalNotification*)notification
{
    EZTaskStore* store = [EZTaskStore getInstance];
    UILocalNotification* storeNotify = [store getDailyNotification];
    if(storeNotify){
        EZDEBUG(@"cancel existing nofication");
        [[UIApplication sharedApplication] cancelLocalNotification:storeNotify];
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [store setDailyNotification:notification];
}


+ (void) setupDailyNotificationDate:(NSDate*)date
{
    UILocalNotification* nofication = [[UILocalNotification alloc] init];
    //NSDate* tomorrow = [[NSDate date] adjustDays:1];
    nofication.fireDate = date;
    nofication.alertBody = Local(@"Time to schedule tomorrow's task for you.");
    //Mean I can pick my own customized name?
    nofication.soundName = UILocalNotificationDefaultSoundName;
    nofication.applicationIconBadgeNumber = 1;
    nofication.repeatCalendar = nil;
    nofication.repeatInterval = kCFCalendarUnitDay;
    
    //Anything it is very confusing and misleading, seems this is a test method.
    //Fix them one after another.
    NSDictionary* infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Tomorrow", EZAssignNotificationKey ,nil];
    nofication.userInfo = infoDict;

}


@end
