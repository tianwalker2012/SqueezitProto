//
//  EZAlarmUtility.h
//  SqueezitProto
//
//  Created by Apple on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EZScheduledTask;

@interface EZAlarmUtility : NSObject

+ (void) setupAlarmBulk:(NSArray*)tasks;

+ (void) cancelAlarmBulk:(NSArray*)tasks;

//Setup the alarm for task
+ (void) setupAlarm:(EZScheduledTask*)task;

//Cancel the alarm for task
+ (void) cancelAlarm:(EZScheduledTask*)task;

+ (void) changeAlarmMode:(EZScheduledTask*)task;

//Outside world will call this to setup the notification
//Previously it is locate at the EZTaskStore not a proper place to call. 
+ (void) setupDailyNotification:(UILocalNotification*)notification;

//Hide all the notification setup detail.
+ (void) setupDailyNotificationDate:(NSDate*)date;

//Who will call this? 
//Application level will call it. 
//If will try to fetch from the NSUserDefault
//+ (UILocalNotification*) createTomorrowNotification;


//+ (void) assignTomorrowNofication;

@end
