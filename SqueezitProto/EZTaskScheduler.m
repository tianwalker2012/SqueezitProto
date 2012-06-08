//
//  EZTaskScheduler.m
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTaskScheduler.h"
#import "EZTask.h"
#import "EZScheduledTask.h"
#import "Constants.h"
#import "EZTaskStore.h"
#import "EZAvailableTime.h"
#import "EZAvailableDay.h"
#import "EZQuotasResult.h"
#import "EZQuotas.h"
#import "EZTaskHelper.h"

//Block definition, maybe useful very soon.
//typedef NSComparisonResult (^NSComparator)(id obj1, id obj2);


@interface EZTaskScheduler(private)

- (EZScheduledTask*) getTaskFromList:(NSArray*)tasks timeSlot:(EZAvailableTime*)timeSlot;

- (NSMutableArray*) tasksRemovedExclusive:(NSArray*)tasks exclusiveList:(NSArray*)exclusive envTraits:(EZEnvironmentTraits)envTraits;

- (BOOL) contain:(NSArray*)list object:(id)obj;

- (NSDate*) combineDate:(NSDate*)date time:(NSDate*)time;

- (void) addExclusive:(NSMutableArray*)exclusive tasks:(NSArray*)tasks;

- (EZAvailableTime*) createAvTimeFromScheduledTask:(EZScheduledTask*)schTask;

- (NSArray*) sortAvailableTimes:(NSArray*)avTimes;

@end

@implementation EZTaskScheduler

//Singleton
+ (EZTaskScheduler*) getInstance
{
    static EZTaskScheduler* instance;
    if(!instance){
        instance = [[EZTaskScheduler alloc] init];
    }
    return instance;
}

- (EZAvailableTime*) createAvTimeFromScheduledTask:(EZScheduledTask*)schTask
{
    EZAvailableTime* res = [[EZAvailableTime alloc] init:schTask.startTime name:schTask.task.name duration:schTask.duration environment:schTask.envTraits];
    return res;
}


- (NSArray*) rescheduleTask:(EZScheduledTask*)schTask existTasks:(NSArray*)schTasks
{
    EZAvailableTime* avTime = [self createAvTimeFromScheduledTask:schTask];
    NSMutableArray* exclusive = [[NSMutableArray alloc] initWithCapacity:[schTasks count]];
    [self addExclusive:exclusive tasks:schTasks];
    return [self scheduleTaskByBulk:avTime exclusiveList:exclusive tasks:[[EZTaskStore getInstance] getAllTasks]];
}
//Why do we need this?
//We need to collect the history date to help us calculate how many time we should 
//Assign today. 
- (int) calcHistoryTime:(EZTask*)task date:(NSDate*)date
{

    NSDictionary* histResult = [EZTaskHelper calcHistoryBegin:task.quotas date:date];
    NSDate* historyStart = [histResult objectForKey:@"beginDate"];
    int padDay = [(NSNumber*)[histResult objectForKey:@"padDays"] intValue];
    if([historyStart equalWith:date format:@"yyyyMMdd"]){
        //Mean there is 
        return 0;
    }
    EZTaskStore* store = [EZTaskStore getInstance];
    int taskTime = [store getTaskTime:task start:historyStart end:[date adjustDays:-1]];
    //This is only for the cases of the first iteration of the quotas.
    //But we need to handle this cases since this case happen a lot. 
    if(padDay > 0){
        taskTime += (task.quotas.quotasPerCycle/task.quotas.cycleLength) * padDay;
    }
    return taskTime;
}

//This function have serve side-effect. The avTimes will get changed. 
- (NSArray*) allocTimeForTasks:(EZTask*)task avTimes:(NSArray*)times amount:(int)amount date:(NSDate*)date
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    int totalAmount = amount;
    for(EZAvailableTime* time in times){
        //Get the actual date combined with the specified time
        if(totalAmount <= 0){ //Allocated enough time.
            break;
        }
        if((time.envTraits & task.envTraits) != task.envTraits){
            //Not meet the requirements
            continue;
        }
        
        time.start = [self combineDate:date time:time.start];
        int maxDur = MAX(task.duration, totalAmount);
        int miniDur = task.duration;
        if(time.duration >= miniDur){
            int actualAmount = MIN(maxDur, time.duration);
            EZScheduledTask* schTask = [[EZScheduledTask alloc] init];
            schTask.duration = actualAmount;
            schTask.envTraits = time.envTraits;
            schTask.startTime = time.start;
            schTask.task = task;
            [res addObject:schTask];
            time.duration = time.duration - actualAmount;
            time.start = [time.start adjustMinutes:actualAmount];
            totalAmount -= actualAmount;
        }else{
            EZDEBUG(@"Not meet the minimum duration requirements:%@,Mini:%i,available Amount:%i",time.description,miniDur,time.duration);
        }
        
    }
    EZCONDITIONLOG(totalAmount > 0, @"still left some amount: %i",totalAmount);
    return res;
}




//When and where we try to find we just don't have enough time to do so?
//Can do this at the beginning of the method.
//First make sure this task have enough data to run. 
//Once you add some quotas, I will calculate one cycle see if I have enough time allow this
//Quotas to execute.
- (EZQuotasResult*) scheduleQuotasTask:(NSArray*)tasks date:(NSDate*)date avDay:(EZAvailableDay*)avDay
{
    EZQuotasResult* res = [[EZQuotasResult alloc] init];
    //EZTaskStore* store = [EZTaskStore getInstance];
    //EZAvailableDay* avDay = [store getAvailableDay:date];
    for(EZTask* tk in tasks){
        if(tk.quotas){
            int historyTime = [self calcHistoryTime:tk date:date];
            if(historyTime >= tk.quotas.quotasPerCycle){
                //Already completed the required task, so no special treatment now.
                continue;
            }
            int remain = tk.quotas.quotasPerCycle - historyTime;
            int avg = remain/[EZTaskHelper cycleRemains:tk.quotas date:date];
            int amount = avg * 1.1;
            NSArray* scts = [self allocTimeForTasks:tk avTimes:[self sortAvailableTimes:avDay.availableTimes] amount:amount date:date];
            [res.scheduledTasks addObjectsFromArray:scts];
            EZDEBUG(@"%@:remain:%i,avg:%i,currentAmount:%i,createdTask:%i",tk.name,remain,avg,amount,[scts count]);
        }
    }
    res.availableDay = avDay;
    return res;
}

- (NSArray*) sortAvailableTimes:(NSArray*)avTimes
{
    return [avTimes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        EZAvailableTime* av1 = obj1;
        EZAvailableTime* av2 = obj2;
        return [av1.start timeIntervalSince1970] - [av2.start timeIntervalSince1970];
    }];
}

- (void) addExclusive:(NSMutableArray*)exclusive tasks:(NSArray*)tasks
{
    for(EZScheduledTask* st in tasks){
        [exclusive addObject:st.task];
    }
}

- (NSDate*) combineDate:(NSDate*)date time:(NSDate*)time
{
    NSString* dateStr = [date stringWithFormat:@"yyyy-MM-dd"];
    NSString* timeStr = [time stringWithFormat:@"HH:mm:ss"];
    NSString* combineStr = [NSString stringWithFormat:@"%@ %@",dateStr,timeStr];
    return [NSDate stringToDate:@"yyyy-MM-dd HH:mm:ss" dateString:combineStr];
}


//This method only take care of the random arranged tasks
- (NSArray*) scheduleRandomTask:(NSDate*)date avDay:(EZAvailableDay*)avDay exclusiveList:(NSArray*)exclusive
{
    EZTaskStore* store = [EZTaskStore getInstance];
    NSMutableArray* res = [[NSMutableArray alloc] init];
    NSMutableArray* exclusiveTasks = [NSMutableArray arrayWithArray:exclusive]; 
    //EZDEBUG(@"Available Time count:%i",[avDay.availableTimes count]);
    for(EZAvailableTime* avTime in avDay.availableTimes){
        avTime.start = [self combineDate:date time:avTime.start];
        NSArray* scheduledTasks = [self scheduleTaskByBulk:avTime exclusiveList:exclusiveTasks tasks:[store getAllTasks]];
        [self addExclusive:exclusiveTasks tasks:scheduledTasks];
        //EZDEBUG(@"add %i tasks to %@(%@)",[scheduledTasks count],avTime.description,[avTime.start stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]);
        [res addObjectsFromArray:scheduledTasks];
    }
    
    return res;
}


// Now this function meet my requirements.
// Let's test on the really equipment, see how's going. 
- (NSArray*) scheduleTaskByDate:(NSDate*)date exclusiveList:(NSArray*)exclusive 
{
    EZTaskStore* store = [EZTaskStore getInstance];
    EZAvailableDay* day = [store getAvailableDay:date];
    NSMutableArray* res = [[NSMutableArray alloc] init];
    if(!day){
        EZDEBUG(@"Didn't find schedule for %@",[date stringWithFormat:@"yyyy-MM-dd"]);
        return res;
    }
    NSArray* tasks = store.getAllTasks;
    EZQuotasResult* qres = [self scheduleQuotasTask:tasks date:date avDay:day];
    NSMutableArray* exclusiveMut = [NSMutableArray arrayWithArray:exclusive];
    [self addExclusive:exclusiveMut tasks:qres.scheduledTasks];
    
    [res addObjectsFromArray:qres.scheduledTasks];
    [res addObjectsFromArray:[self scheduleRandomTask:date avDay:day exclusiveList:exclusiveMut]];
    
    return [self sort:res];
    
}

//Change task, will be called when user not satisfied one task
// What if I got zero tasks?
// Then ask user to take a vacation.
- (NSArray*) changeScheduledTask:(EZScheduledTask*)change exclusiveList:(NSArray*)exclusive
{
    EZAvailableTime* avTime = [[EZAvailableTime alloc] init:change.startTime name:change.task.name duration:change.duration environment:change.envTraits];
    EZTaskStore* store = [EZTaskStore getInstance];
    return [self scheduleTaskByBulk:avTime exclusiveList:exclusive tasks:store.getAllTasks];
}

// What this function do?
// select an array of list based on the setting of the timeSlot
// What's carried in the exclusive?
// This is the task already selected. 
// Currently I am implemented as simple as possible.
// So that if the task selected again, then not select it a a while
// Should I keep the exclusiveList increase?
// It should be determined by outside functionality.
// It turn out 2 places to determine what inside the exclusive list.
// Within this method, I have to increase the exclusive list as task get selected.
// 
- (NSArray*) scheduleTaskByBulk:(EZAvailableTime*)timeSlot exclusiveList:(NSArray*)exclusive tasks:(NSArray*)tasks
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    //NSMutableArray* exclusiveMut = [[NSMutableArray alloc] initWithArray:exclusive];
    EZAvailableTime* timeSlotMut = [[EZAvailableTime alloc] init:timeSlot];
    //Tasks should be available for this time slot.
    //NSLog(@"Tasks count:%i, exclusive task count:%i",[tasks count],[exclusive count]);
    NSMutableArray* tasksMut = [self tasksRemovedExclusive:tasks exclusiveList:exclusive envTraits:timeSlot.envTraits];
    //NSLog(@"Removed tasks count %i",[tasksMut count]);
    
    while(true){
        EZScheduledTask* task = [self getTaskFromList:tasksMut timeSlot:timeSlotMut];
        
        if(task){
            //[exclusiveMut addObject:task];
            [tasksMut removeObject:task.task];
            [res addObject:task];
        } else { // No available tasks
            break;
        }
    }
    EZDEBUG(@"Allocate %i tasks for duration:%i",[res count], timeSlot.duration);
    return res;
}

//Remove the exclusive tasks from the tasks list 
//So that all the tasks with the list are good to go
- (NSMutableArray*) tasksRemovedExclusive:(NSArray*)tasks exclusiveList:(NSArray*)exclusive envTraits:(EZEnvironmentTraits)envTraits
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:[tasks count]];
    for(int i = 0; i < [tasks count]; i++){
        EZTask* tk = (EZTask*)[tasks objectAtIndex:i];
        if(![exclusive containsObject:tk] && (tk.envTraits & envTraits) == tk.envTraits){
            [res addObject:tk];
        }
    }
    
    return res;
}


//What's the responsibility of the method?
//Randomly pick a task from the list.
//Will update the timeslot remaining minutes and start time accordingly
//There are possbility that the remaining time have something left. 
//Will add gap logic to fill the lefted gap. 
//Add logic to add padding time later.
//Focus on the main logic now.

- (EZScheduledTask*) getTaskFromList:(NSArray*)tasks timeSlot:(EZAvailableTime*)timeSlot
{
    EZScheduledTask* res = nil;
    //int maxTry = 2*[tasks count];
    NSMutableArray* filteredTasks = [[NSMutableArray alloc] initWithCapacity:[tasks count]];
    for(EZTask* tk in tasks){
        if(timeSlot.duration >= tk.duration){
            [filteredTasks addObject:tk];
        }
    }
    if([filteredTasks count] == 0){
        EZDEBUG(@"Find no task for timeSlot:%@,Duration:%i",timeSlot,timeSlot.duration);
        return res;
    }
    int selected = arc4random()%[filteredTasks count];
    EZTask* tk = [filteredTasks objectAtIndex:selected];
    res = [[EZScheduledTask alloc] init];
    res.task = tk;
    int actualDur = tk.maxDuration;
    if(actualDur > timeSlot.duration){
        actualDur = timeSlot.duration;
    }
    res.duration = actualDur;
    res.startTime = timeSlot.start;
    res.envTraits = timeSlot.envTraits;
    //res.description = timeSlot.description;
    timeSlot.duration = timeSlot.duration - actualDur;
    [timeSlot adjustStartTime:actualDur];
    EZDEBUG(@"Find task:%@, duration:%i, remain time:%i", tk.name, res.duration, timeSlot.duration);
    return res;
}


- (NSArray*) sort:(NSArray *)schTasks
{
    return [schTasks sortedArrayUsingComparator:^(id obj1, id obj2){
        EZScheduledTask* task1 = (EZScheduledTask*)obj1;
        EZScheduledTask* task2 = (EZScheduledTask*)obj2;
        return [task1.startTime compare:task2.startTime];
    }];
}

- (BOOL) contain:(NSArray*)list object:(id)objin
{
    //BOOL res = false;
    for(int i = 0; i < [list count]; i++){
        EZScheduledTask* tk = (EZScheduledTask*)[list objectAtIndex:i];
        if(tk.task == objin){
            return true;
        }
    }
    return false;
}

@end
