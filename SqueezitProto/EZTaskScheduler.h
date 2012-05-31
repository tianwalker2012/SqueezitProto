//
//  EZTaskScheduler.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
///Users/apple/work_foot/ios/SqueezitProto/SqueezitProto/EZTask.h

#import <Foundation/Foundation.h>

@class EZScheduledTask, EZAvailableTime, EZQuotasResult, EZQuotas, EZAvailableDay, EZTask;

@interface EZTaskScheduler : NSObject


+ (EZTaskScheduler*) getInstance;

// The exlusive list mean, do NOT choose from those already choosed
- (EZScheduledTask*) scheduleTask:(NSDate*)startTime duration:(int)duration exclusiveList:(NSArray*)exclusive;

// Will select multiple task to assign, actually, I think, I actually need this method a lot.
- (NSArray*) scheduleTaskByBulk:(EZAvailableTime*)timeSlot exclusiveList:(NSArray*)exclusive tasks:(NSArray*)tasks;

//I am not satisfied so I need to change the task
- (NSArray*) rescheduleTask:(EZScheduledTask*)schTask existTasks:(NSArray*)schTasks;

//The purpose of this method is to schedule tasks which have quotas. 
//What's the meaning?
//It will modify the available time based on the statistic collected. 
//Then use the time to allocate the tasks.
- (EZQuotasResult*) scheduleQuotasTask:(NSArray*)tasks date:(NSDate*)date avDay:(EZAvailableDay*)avDay;

//Sort scheduled task by time
- (NSArray*) sort:(NSArray*)schTasks;

//Normally this task will be called. 
- (NSArray*) scheduleTaskByDate:(NSDate*)date exclusiveList:(NSArray*)exclusive;

- (NSArray*) scheduleRandomTask:(NSDate*)date avTimes:(NSArray*)avTimes exclusiveList:(NSArray*)exlusive;

//According to the quotas and current data will get all the history date out.
- (int) calcHistoryTime:(EZTask*)task date:(NSDate*)date;

//Change task, will be called when user not satisfied one task
// What if I got zero tasks?
// Then ask user to take a vacation.
- (NSArray*) changeScheduledTask:(EZScheduledTask*)change;

@end
