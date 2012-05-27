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
#import "EZScheduledDay.h"
#import "EZAvailableDay.h"
#import "EZQuotas.h"
#import "EZQuotasResult.h"
#import "EZTaskHelper.h"

#define TestValue 60*20

@interface EZTestSuite(private)

+ (void) testMainCase;
+ (void) testComprehansiveCase;
+ (void) testTaskStore;
+ (void) testAvailableTime;
+ (EZScheduledTask*) findTask:(EZTask*)task scheduled:(NSArray*)scheduleList;
+ (void) testTaskFetch;
+ (void) testAvailableTimeMatchWeekAndDay;
+ (void) testTaskPick;
+ (void) testExclusive;
+ (void) testTestData;
+ (void) testQuotasTask;
+ (void) testQuotasWithHistory;
@end

@implementation EZTestSuite



+ (void) testSchedule
{
    [EZTestSuite testComprehansiveCase];
    //[EZTestSuite testMainCase];
    [EZTestSuite testTaskStore];
    [EZTestSuite testTaskFetch];
    [EZTestSuite testAvailableTime];
    [EZTestSuite testAvailableTimeMatchWeekAndDay];
    [EZTestSuite testTaskPick];
    [EZTestSuite testExclusive];
    [EZTestSuite testTestData];
    [EZTestSuite testQuotasTask];
    [EZTestSuite testQuotasWithHistory];
    
    
    //Clear all the test data.
    //In the future what should I do with this.
    //Seems in this case, we need the test case ready
    //If it involve the test data cleanup.
    [[EZTaskStore getInstance] clean];
    
}

//
+ (void) testQuotasWithHistory
{
    EZDEBUG(@"Will test quotasWithHistory");
}

//The simplest Quotas test cases
+ (void) testQuotasTask
{
    EZTaskStore* store = [EZTaskStore getInstance];
    [store clean];
    EZAvailableDay* avDay = [[EZAvailableDay alloc] initWithName:@"All Time" weeks:ALLDAYS];
    EZAvailableTime* time1 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"06:00"] description:@"Taiji time" duration:120 environment:EZ_ENV_FITTING];
    EZAvailableTime* time2 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"08:00"] description:@"Programming time" duration:90 environment:EZ_ENV_FLOWING];
    EZAvailableTime* time3 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"10:00"] description:@"Reading and Thinking" duration:120 environment:EZ_ENV_FLOWING|EZ_ENV_READING];
    [avDay.availableTimes addObjectsFromArray:[NSArray arrayWithObjects:time1, time2, time3, nil]];
    [store.availableDays addObject:avDay];
    EZTask* task1 = [[EZTask alloc] initWithName:@"programming" duration:80 maxDur:80 envTraits:EZ_ENV_FLOWING];
    EZTask* task2 = [[EZTask alloc] initWithName:@"Martin Luther King" duration:20 maxDur:40 envTraits:EZ_ENV_READING];
    EZTask* task3 = [[EZTask alloc] initWithName:@"Gandhi" duration:30 maxDur:60 envTraits:EZ_ENV_READING];
    EZQuotas* quotas = [[EZQuotas alloc] init:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120526"] quotas:1200 type:CustomizedCycle cycleStartDate:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120526"] cycleLength:10];
    task1.quotas = quotas;
    [store.tasks addObjectsFromArray:[NSArray arrayWithObjects:task1, task2, task3, nil]];
    EZDEBUG(@"Begin call schedule");
    EZTaskScheduler* tscheduler = [[EZTaskScheduler alloc] init];
    NSDate* date = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120526"];
    EZQuotasResult* res = [tscheduler scheduleQuotasTask:store.tasks date:date avDay:[store getAvailableDay:date]];
    EZDEBUG(@"End call schedule");
    EZAvailableTime* adjustedTime1 = [res.availableDay.availableTimes objectAtIndex:0];
    EZAvailableTime* adjustedTime2 = [res.availableDay.availableTimes objectAtIndex:1];
    EZAvailableTime* adjustedTime3 = [res.availableDay.availableTimes objectAtIndex:2];
    
    assert(adjustedTime1.duration == time1.duration);
    assert(adjustedTime2.duration == 0);
    assert(adjustedTime3.duration == time3.duration - task1.duration);
}

+ (void) testTestData
{
    EZTaskStore* store = [EZTaskStore getInstance];
    [store clean];
    [store fillTestData];
    EZTaskScheduler* ts = [[EZTaskScheduler alloc] init];
    NSArray* scheduleTasks = [ts scheduleTaskByDate:[NSDate date] exclusiveList:nil];
    NSLog(@"Return length:%i",[scheduleTasks count]);
    for(EZScheduledTask* scht in scheduleTasks){
        NSLog(@"Detail:%@",[scht detail]);
    }
}

+ (void) testExclusive
{
    EZTaskStore* ets = [EZTaskStore getInstance];
    [ets clean];
    EZTask* task = [[EZTask alloc] initWithName:@"Taiji" duration:120 maxDur:120 envTraits:EZ_ENV_FITTING];
   
    
    [ets.tasks addObject:task];
    EZAvailableDay* aDay = [[EZAvailableDay alloc] init];
    aDay.assignedWeeks = ALLDAYS;
    NSDate* startTime = [NSDate date];
    EZAvailableTime* avTime = [[EZAvailableTime alloc] init:startTime description:@"Taiji time" duration:150 environment:EZ_ENV_FITTING];
    [aDay.availableTimes addObject:avTime];
    [ets.availableDays addObject:aDay];
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    NSArray* res = [scheduler scheduleTaskByBulk:avTime exclusiveList:nil tasks:ets.tasks];
    assert([res count] == 1);
    NSArray* exclusive = [NSArray arrayWithObject:task];
    res = [scheduler scheduleTaskByBulk:avTime exclusiveList:exclusive tasks:ets.tasks];
    assert([res count] == 0);
    
    res = [scheduler scheduleTaskByDate:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120526"] exclusiveList:nil];
    assert([res count] == 1);
    EZScheduledTask* sct = [res objectAtIndex:0];
    NSString* dateStr = [sct.startTime stringWithFormat:@"yyyyMMdd>HH:mm:ss"];
    NSString* combineStr = [NSString stringWithFormat:@"20120526>%@",[avTime.start stringWithFormat:@"HH:mm:ss"]];
    
    NSLog(@"combined:%@, in scheduled:%@", combineStr, dateStr);
    
    assert([combineStr compare:dateStr] == NSOrderedSame);
    
    res = [scheduler scheduleTaskByDate:[NSDate date] exclusiveList:exclusive];
    assert([res count] == 0);
}

+ (void) testTaskPick
{
    NSDate* startTime1 = [NSDate stringToDate:@"yyyy-MM-dd HH:mm:ss" dateString:@"2012-05-25 06:10:00"];
    
    NSDate* startTime2 = [NSDate stringToDate:@"yyyy-MM-dd HH:mm:ss" dateString:@"2012-05-25 07:10:00"];
    
    EZAvailableTime* av1 = [[EZAvailableTime alloc] init:startTime1 description:@"Practice" duration:5 environment:EZ_ENV_FITTING];
    
    EZAvailableTime* av2 = [[EZAvailableTime alloc] init:startTime2 description:@"Reading" duration:5 environment:EZ_ENV_READING];
    EZAvailableDay* availableDay = [[EZAvailableDay alloc] init];
    availableDay.assignedWeeks = ALLDAYS;
    [availableDay.availableTimes addObjectsFromArray:[NSArray arrayWithObjects:av1, av2, nil]];
    EZTaskStore* store = [EZTaskStore getInstance];
    [store clean];
    [store.availableDays addObject:availableDay];
    
    EZTask* task1 = [[EZTask alloc] initWithName:@"Read" duration:1 maxDur:1 envTraits:EZ_ENV_READING];
    
    EZTask* task2 = [[EZTask alloc] initWithName:@"Joke" duration:1 maxDur:1 envTraits:EZ_ENV_SOCIALING ];
    
    EZTask* task3 = [[EZTask alloc] initWithName:@"Taiji" duration:1 maxDur:1 envTraits:EZ_ENV_FITTING];
    [store.tasks addObjectsFromArray:[NSArray arrayWithObjects:task1, task2, task3, nil]];
    
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    
    NSArray* scheduledTasks = [scheduler scheduleTaskByDate:[NSDate date] exclusiveList:nil];
    
    NSLog(@"ScheduledTasks %@",scheduledTasks);
    
    for(EZScheduledTask* sct in scheduledTasks){
        NSLog(@"Detail:%@",[sct detail]);
    }
    
    assert([scheduledTasks count] == 2);
    
}

+ (void) testAvailableTimeMatchWeekAndDay
{
    EZAvailableDay* day1 = [[EZAvailableDay alloc] init];
    day1.assignedWeeks = MONDAY;
    day1.date = [NSDate stringToDate:@"yyyy-MM-dd" dateString:@"2012-05-20"];
    
    EZAvailableDay* day2 = [[EZAvailableDay alloc] init];
    day2.assignedWeeks = TUESDAY;
    day2.date = [NSDate stringToDate:@"yyyy-MM-dd" dateString:@"2012-05-21"];
    
    EZAvailableDay* day3 = [[EZAvailableDay alloc] init];
    day3.assignedWeeks = SUNDAY|WEDNESDAY|THURSDAY|FRIDAY;
    day3.date = [NSDate stringToDate:@"yyyy-MM-dd" dateString:@"2012-05-22"];
    
    EZTaskStore* store = [EZTaskStore getInstance];
    [store.availableDays addObjectsFromArray:[NSArray arrayWithObjects:day1, day2, day3, nil]];
    
    NSDate* genDate = [NSDate stringToDate:@"yyyy-MM-dd" dateString:@"2012-05-21"];
    NSLog(@"Generated date:%@",genDate);
    
    EZAvailableDay* res = [store getAvailableDay:[NSDate stringToDate:@"yyyy-MM-dd" dateString:@"2012-05-21"]];
    NSLog(@"day2 days:%i, genDay days:%i, day2.date:%@",[day2.date convertDays],[genDate convertDays],day2.date);
    assert(res.assignedWeeks == day2.assignedWeeks);
    
    res = [store getAvailableDay:[NSDate stringToDate:@"yyyy-MM-dd" dateString:@"2012-05-20"]];
    assert(res.assignedWeeks == day1.assignedWeeks);
    
    res = [store getAvailableDay:[NSDate stringToDate:@"yyyy-MM-dd" dateString:@"2012-05-24"]];
    assert(res.assignedWeeks == day3.assignedWeeks);
    
    
    res = [store getAvailableDay:[NSDate stringToDate:@"yyyy-MM-dd" dateString:@"2012-05-26"]];
    assert(res == nil);
}

+ (void) testAvailableTime
{
    EZTaskStore* store = [EZTaskStore getInstance];
    [store getAvailableDay:[NSDate date]];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate* date = [df dateFromString:@"20/05/2012"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    uint unitFlags = NSWeekdayCalendarUnit;
    NSDateComponents* dcomponent = [calendar components:unitFlags fromDate:date];
    int weekDay = [dcomponent weekday];

    NSLog(@"Sunday flag is:%i", [date weekDay]);
    assert([date weekDay] == SUNDAY);
    
    date = [df dateFromString:@"21/05/2012"];
     NSLog(@"Monday flag is:%i, detail:%@, stringFromDate:%@", [date weekDay], date, [df stringFromDate:date]);
    assert([date weekDay] == MONDAY);
    
    date = [df dateFromString:@"22/05/2012"];
    NSLog(@"Tuesday flag is:%i", [date weekDay]);
    assert([date weekDay] == TUESDAY);
    
    date = [df dateFromString:@"23/05/2012"];
    NSLog(@"Wednesday flag is:%i", [date weekDay]);
    assert([date weekDay] == WEDNESDAY);
    
    date = [df dateFromString:@"24/05/2012"];
    NSLog(@"Thursday flag is:%i", [date weekDay]);
    assert([date weekDay] == THURSDAY);
    
    date = [df dateFromString:@"25/05/2012"];
    NSLog(@"Friday flag is:%i", [date weekDay]);
    assert([date weekDay] == FRIDAY);
    
    date = [df dateFromString:@"26/05/2012"];
    NSLog(@"Saturday flag is:%i", [date weekDay]);
    assert([date weekDay] == SATURDAY);
    
}

+ (void) testTaskFetch
{
    EZTaskStore* store = [EZTaskStore getInstance];
    EZTask* task1 = [[EZTask alloc] initWithName:@"Read" duration:10 maxDur:10 envTraits:EZ_ENV_NONE];
    task1.envTraits = 1|4;
    
    EZTask* task2 = [[EZTask alloc] initWithName:@"Write" duration:10 maxDur:10 envTraits:EZ_ENV_NONE];
    task2.envTraits = 2;
    
    EZTask* task3 = [[EZTask alloc] initWithName:@"Think" duration:10 maxDur:10 envTraits:EZ_ENV_NONE];
    task3.envTraits = 8;
    [store.tasks addObjectsFromArray:[NSArray arrayWithObjects:task1, task2, task3, nil]];
    
    NSArray* res = [store getTasks:2];
    assert([res count] == 1);
    assert([res objectAtIndex:0] == task2);
    
    res = [store getTasks:16];
    assert([res count] == 0);
    
    res = [store getTasks:(1|2|4|8)];
    assert([res count] == 3);
    assert([res containsObject:task1]);
    assert([res containsObject:task2]);
    assert([res containsObject:task3]);
            
}

+ (void) testTaskStore
{
    EZTaskStore* store = [EZTaskStore getInstance];
    EZScheduledDay* yesterday = [[EZScheduledDay alloc] init];
    yesterday.scheduledDay = [[NSDate alloc] initWithTimeIntervalSinceNow:-60*60*24];
    
    EZScheduledDay* tomorrow = [[EZScheduledDay alloc] init];
    tomorrow.scheduledDay = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24];
    
    EZScheduledDay* today = [[EZScheduledDay alloc] init];
    today.scheduledDay = [NSDate date];
    
    [store.scheduleDays addObjectsFromArray:[NSArray arrayWithObjects:yesterday,tomorrow,today, nil]];
    NSArray* sortedDays = [store getSortedScheduledDays];
    EZScheduledDay* prev = nil;
    for(int i = 0; i < [sortedDays count]; i++){
        EZScheduledDay* day = [sortedDays objectAtIndex:i];
        NSLog(@"%i:%@",i,day.scheduledDay);
        if(prev){
            assert([prev.scheduledDay compare:day.scheduledDay] == NSOrderedAscending);
        }
        prev = day;
    }
    
    EZScheduledDay* res = [store getScheduledDayByDate:[NSDate date]];
    NSLog(@"Returned day %@, yesterday:%i,today:%i,tomorrow:%i, original value:%f",res.scheduledDay,[yesterday.scheduledDay convertDays], [today.scheduledDay convertDays], [tomorrow.scheduledDay convertDays],[tomorrow.scheduledDay timeIntervalSince1970]);
    
    double seconds = 45667.001;
    int dived = seconds/TestValue;
    NSLog(@"Value %i",dived);
    assert(res == today);
    
    
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
                       initWithName:@"small" duration:1 maxDur:1 envTraits:EZ_ENV_NONE]; 
    EZTask* middleTk  = [[EZTask alloc]initWithName:@"middle" duration:2 maxDur:2 envTraits:EZ_ENV_NONE];
    EZTask* largeTk = [[EZTask alloc]initWithName:@"large" duration:5 maxDur:5 envTraits:EZ_ENV_NONE];
    EZTask* illFitTask = [[EZTask alloc]initWithName:@"illFitTask" duration:14 maxDur:14 envTraits:EZ_ENV_NONE];
    
    EZTask* adjustTask = [[EZTask alloc]initWithName:@"adjustTask" duration:3 maxDur:3 envTraits:EZ_ENV_NONE];
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
    NSArray* tasks = [NSArray arrayWithObjects:[[EZTask alloc]initWithName:@"small" duration:1 maxDur:1 envTraits:EZ_ENV_NONE],
                      [[EZTask alloc]initWithName:@"middle" duration:2 maxDur:2 envTraits:EZ_ENV_NONE],
                      [[EZTask alloc]initWithName:@"large" duration:5 maxDur:5 envTraits:EZ_ENV_NONE],nil
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
