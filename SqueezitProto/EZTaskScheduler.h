//
//  EZTaskScheduler.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
///Users/apple/work_foot/ios/SqueezitProto/SqueezitProto/EZTask.h

#import <Foundation/Foundation.h>
#import "EZTaskHelper.h"

@class EZScheduledTask, EZAvailableTime, EZQuotasResult, EZQuotas, EZAvailableDay, EZTask;

@interface ScheduledFilterResult : NSObject

@property (strong, nonatomic) NSMutableArray* remainingTasks;
@property (strong, nonatomic) NSMutableArray* removedTasks;
@property (strong, nonatomic) NSDate* adjustedDate;

@end


//What's the purpose of this class?
//It will take care of all the schedule related activity.
//It have 2 inputs, the available task and available time.
//It will assign the available task randomly or specifically into a availableTime span.
@interface EZTaskScheduler : NSObject<EZValueObject>


+ (EZTaskScheduler*) getInstance;

// The exlusive list mean, do NOT choose from those already choosed
// Why Do I have exlusive?
// Because I don't want the task already allocated at today to be allocated again.
// Give other task a chance to get allocated.
- (EZScheduledTask*) scheduleTask:(NSDate*)startTime duration:(int)duration exclusiveList:(NSArray*)exclusive;

// Will select multiple task to assign, actually, I think, I actually need this method a lot.
// What's the difference between scheduleTaskByBulk and scheduleTask
- (NSArray*) scheduleTaskByBulk:(EZAvailableTime*)timeSlot exclusiveList:(NSArray*)exclusive tasks:(NSArray*)tasks;

//I am not satisfied so I need to change the task
- (NSArray*) rescheduleTask:(EZScheduledTask*)schTask existTasks:(NSArray*)schTasks;

//Do the same thing as the existed one, the only difference is that
//It will query all things from the database.
- (NSArray*) rescheduleStoredTask:(EZScheduledTask *)schTask;

//The purpose of this method is to schedule tasks which have quotas. 
//What's the meaning?
//It will modify the available time based on the statistic collected. 
//Then use the time to allocate the tasks.
- (EZQuotasResult*) scheduleQuotasTask:(NSArray*)tasks date:(NSDate*)date avDay:(EZAvailableDay*)avDay;


//What's the purpose of this function?
//Only the availableTime behind current date will left.
- (EZAvailableDay*) filterAvailebleDay:(EZAvailableDay*)avDay  byTime:(NSDate*)currentDate;


//This will be called when the refresh button get clicked
//What the effect will be achieved?
//Travel through the task that startTime already passed, will not be touched. 
//One minor edge case jump into my mind. what if the current task longer than the current date?
//My solution is that modify the date make it just at the time. 
//Who responsible to do the deletion?
//Let's this method do it.
//It will remove the task not timeout from the database.
//Then get the availble time out and filter it with current date.
//Then add the remaining task into the exclusion task list. 
//Go through task as the schduledTaskByDate
- (NSArray*) rescheduleAll:(NSArray*)scheduledTask date:(NSDate*)date;


//Will be invoked by rescheduleAll
//task startTime before the date will be kept in the remainTasks
//task startTime after the date will be will be added into removed task
//The date will be adjusted, to the the end of the latest task if that task's end time is later than current date.
//Cool, simple and clear
- (ScheduledFilterResult*) filterTask:(NSArray*)scheduledTask date:(NSDate*)date;

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

//What's the purpose of exposing this method. 
//For the test purpose.
- (NSArray*) allocTimeForTasks:(EZTask*)task avTimes:(NSArray*)times amount:(int)amount date:(NSDate*)date;

//Only expose this method for the test purpose.
//Complete this functionality before 9:00PM.
- (EZScheduledTask*) getTaskFromList:(NSArray*)tasks timeSlot:(EZAvailableTime*)timeSlot;

@end
