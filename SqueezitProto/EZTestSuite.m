//
//  EZTestSuite.m
//  SqueezitProto
//
//  Created by Apple on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTestSuite.h"
#import "EZTaskScheduler.h"
#import "EZTaskStore.h"
#import "EZAvailableTime.h"
#import "Constants.h"
#import "EZTask.h"
#import "EZScheduledTask.h"

@interface EZTestSuite(private)

+ (void) testMainCase;
+ (void) testComprehansiveCase;
+ (EZScheduledTask*) findTask:(EZTask*)task scheduled:(NSArray*)scheduleList;

@end

@implementation EZTestSuite

+ (void) testSchedule
{
    [EZTestSuite testComprehansiveCase];
    //[EZTestSuite testMainCase];
}


//Following case will be tested in this method
//1. Make sure all available task will get scheduled and only once
//2. Make sure duration longer than available can not get in
//3. Make sure the maxDuration are setted for the duration
//4. Make sure the start time are adjusted
//5. Make sure the time are sorted in the return scheduledTask
+ (void) testComprehansiveCase
{
    NSLog(@"My second test");
    NSDate* startTime = [NSDate date];
    EZAvailableTime* avTime = [[EZAvailableTime alloc] init:startTime description:@"Test scheduler" duration:13 environment:EZ_ENV_NONE];
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    // NSArray* tasks = [EZTaskStore getTasks:avTime.environmentTraits];
    
    EZTask* smallTk = [[EZTask alloc]
                       initWithName:@"small" description:@"small" duration:1]; 
    EZTask* middleTk  = [[EZTask alloc]initWithName:@"middle" description:@"middle" duration:2];
    EZTask* largeTk = [[EZTask alloc]initWithName:@"large" description:@"large" duration:5];
    EZTask* illFitTask = [[EZTask alloc]initWithName:@"illFitTask" description:@"illFitTask" duration:14];
    
    EZTask* adjustTask = [[EZTask alloc]initWithName:@"adjustTask" description:@"adjustTask" duration:3];
    adjustTask.maxDuration = 4;
    
    NSArray* tasks = [NSArray arrayWithObjects:smallTk,
                      middleTk,
                      largeTk,
                      illFitTask,
                      adjustTask,
                      nil
                      ];
    NSArray* scheduledTask = [scheduler scheduleTaskByBulk:avTime exclusiveList:[[NSArray alloc]init] tasks:tasks];
    NSLog(@"Result array length:%i, detail:%@",[scheduledTask count],[scheduledTask description]);

    EZScheduledTask* st = [EZTestSuite findTask:illFitTask scheduled:scheduledTask];
    assert(st == nil);
    st = [EZTestSuite findTask:smallTk scheduled:scheduledTask];
    assert(st.task == smallTk);
    assert(st.duration == smallTk.duration);
    
    st = [EZTestSuite findTask:adjustTask scheduled:scheduledTask];
    assert(st.task == adjustTask);
    assert(st.duration == 4);
    NSLog(@"Started Time:%@",avTime.start);
    for(int i = 0; i< [scheduledTask count]; i++){
        EZScheduledTask* est = (EZScheduledTask*)[scheduledTask objectAtIndex:i];
        NSLog(@"%i, name:%@,Time:%@,duration:%i",i,est.task.name,est.startTime,est.duration);
    }
    
    NSLog(@"St duration:%i, startedTime:%f, task name:%@",st.duration,[st.startTime timeIntervalSinceDate:startTime],st.task.name);
    
}

+ (void) testMainCase
{
    NSLog(@"My first home made test");
    EZAvailableTime* avTime = [[EZAvailableTime alloc] init:[NSDate date] description:@"Test scheduler" duration:10 environment:EZ_ENV_NONE];
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    // NSArray* tasks = [EZTaskStore getTasks:avTime.environmentTraits];
    NSArray* tasks = [NSArray arrayWithObjects:[[EZTask alloc]initWithName:@"small" description:@"small" duration:1],
                      [[EZTask alloc]initWithName:@"middle" description:@"middle" duration:2],
                      [[EZTask alloc]initWithName:@"large" description:@"large" duration:5],nil
                      ];
    NSArray* scheduledTask = [scheduler scheduleTaskByBulk:avTime exclusiveList:[[NSArray alloc]init] tasks:tasks];
    NSLog(@"Result array length:%i, detail:%@",[scheduledTask count],[scheduledTask description]);
    assert(true);
    
    assert([scheduledTask count]==3);

}

+ (EZScheduledTask*) findTask:(EZTask*)task scheduled:(NSArray*)scheduleList
{
    for(int i = 0; i< [scheduleList count]; i++){
        EZScheduledTask* st = (EZScheduledTask*)[scheduleList objectAtIndex:i];
        if(st.task == task){
            return st;
        }
    }
    return nil;
}

@end
