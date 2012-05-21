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

@interface EZTaskScheduler(private)

- (EZScheduledTask*) getTaskFromList:(NSArray*)tasks timeSlot:(EZAvailableTime*)timeSlot exclusiveList:(NSArray*)exclusive;

- (BOOL) contain:(NSArray*)list object:(id)obj;

@end

@implementation EZTaskScheduler


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
- (NSArray*) scheduleTaskByBulk:(EZAvailableTime*)timeSlot exclusiveList:(NSArray*)exclusive
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    NSMutableArray* exclusiveMut = [[NSMutableArray alloc] initWithArray:exclusive];
    EZAvailableTime* timeSlotMut = [[EZAvailableTime alloc] init:timeSlot];
    NSArray* tasks = [EZTaskStore getTasks:timeSlot.environmentTraits];
    //Tasks should be available for this time slot.
    NSLog(@"Tasks count:%i",[tasks count]);
    while(true){
        EZScheduledTask* task = [self getTaskFromList:tasks timeSlot:timeSlotMut exclusiveList:exclusiveMut];
        
        if(task){
            [exclusiveMut addObject:task];
            [res addObject:task];
        } else { // No available tasks
            break;
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

- (EZScheduledTask*) getTaskFromList:(NSArray*)tasks timeSlot:(EZAvailableTime*)timeSlot exclusiveList:(NSArray*)exclusive
{
    EZScheduledTask* res = nil;
    int maxTry = 2*[tasks count];
    for(int i = 0; i< maxTry; i++){
        int selected = arc4random()%[tasks count];
        EZTask* tk = [tasks objectAtIndex:selected];
        if(timeSlot.duration > tk.duration && ![self contain:exclusive object:tk]){
            res = [[EZScheduledTask alloc] init];
            res.task = tk;
            int actualDur = tk.maxDuration;
            if(actualDur > timeSlot.duration){
                actualDur = timeSlot.duration;
            }
            res.duration = actualDur;
            res.startTime = timeSlot.start;
            timeSlot.duration = timeSlot.duration - actualDur;
            [timeSlot adjustStartTime:actualDur];
            break;
        }
    }
    return res;
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
