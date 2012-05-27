//
//  EZTaskStore.m
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTaskStore.h"
#import "EZTask.h"
#import "EZScheduledTask.h"
#import "EZAvailableTime.h"
#import "EZAvailableDay.h"
#import "EZScheduledDay.h"
#import "EZTaskHelper.h"

@interface EZTaskStore(private)

@end


@implementation EZTaskStore
@synthesize scheduleDays, tasks, achievedTasks, availableDays;

// The purpose of this functinality 
// is to fill the store with the test data, so that we could go ahead and do the test accordingly.
// I love it.
- (void) fillTestData 
{
     NSArray* tks = [NSArray arrayWithObjects:
                     //Fitting tasks
                     [[EZTask alloc] initWithName:@"Tai ji" duration:15 maxDur:90 envTraits:EZ_ENV_FITTING],
                     [[EZTask alloc] initWithName:@"Jujisu" duration:15 maxDur:90 envTraits:EZ_ENV_FITTING],
                     [[EZTask alloc] initWithName:@"Swimming" duration:60 maxDur:150 envTraits:EZ_ENV_FITTING],
                     
                     //Flowing tasks
                     [[EZTask alloc] initWithName:@"App design" duration:40 maxDur:90 envTraits:EZ_ENV_FLOWING],
                     [[EZTask alloc] initWithName:@"iOS development" duration:40 maxDur:120 envTraits:EZ_ENV_FITTING],
                     [[EZTask alloc] initWithName:@"Code reading" duration:40 maxDur:90 envTraits:EZ_ENV_FITTING],
                     
                     //Reading tasks
                     [[EZTask alloc] initWithName:@"Hacker News" duration:15 maxDur:30 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"How to win friends" duration:15 maxDur:30 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"Feynman" duration:30 maxDur:60 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"App design books" duration:30 maxDur:60 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"Thinking fast and slow" duration:15 maxDur:40 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"Founders at work" duration:15 maxDur:30 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"Gandhi" duration:15 maxDur:30 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"Martin Luther King" duration:15 maxDur:30 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"Road to freedom" duration:15 maxDur:30 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"Machine learning" duration:40 maxDur:60 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"Information theory" duration:40 maxDur:60 envTraits:EZ_ENV_READING],
                     [[EZTask alloc] initWithName:@"Poem" duration:5 maxDur:20 envTraits:EZ_ENV_READING],
                     //Video tasks
                     [[EZTask alloc] initWithName:@"TED" duration:10 maxDur:20 envTraits:EZ_ENV_LISTENING],
                     [[EZTask alloc] initWithName:@"Leadership" duration:10 maxDur:20 envTraits:EZ_ENV_LISTENING],
                     //Socialing tasks
                     [[EZTask alloc] initWithName:@"Tell story" duration:15 maxDur:45 envTraits:EZ_ENV_SOCIALING],
                     [[EZTask alloc] initWithName:@"Play game" duration:15 maxDur:45 envTraits:EZ_ENV_SOCIALING]
                     , nil];
    
    [self.tasks addObjectsFromArray:tks];
    EZAvailableDay* avDays = [[EZAvailableDay alloc] initWithName:@"Default setting" weeks:ALLDAYS];
    NSArray* avTimes = [NSArray arrayWithObjects:
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"05:30:00"] description:@"大便时段" duration:30 environment:EZ_ENV_READING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"06:00:00"] description:@"Morning reading" duration:60 environment:EZ_ENV_READING|EZ_ENV_LISTENING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"07:00:00"] description:@"晨练" duration:90 environment:EZ_ENV_FITTING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"09:00:00"] description:@"Walk to Metro" duration:25 environment:EZ_ENV_LISTENING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"09:30:00"] description:@"Metro" duration:30 environment:EZ_ENV_READING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"10:15:00"] description:@"Morning flow" duration:135 environment:EZ_ENV_FLOWING|EZ_ENV_READING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"14:00:00"] description:@"Afternoon flow" duration:240 environment:EZ_ENV_FLOWING|EZ_ENV_READING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"19:15:00"] description:@"After dinner" duration:60 environment:EZ_ENV_SOCIALING],
                         [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"20:30:00"] description:@"Night hours" duration:105 environment:EZ_ENV_FLOWING|EZ_ENV_LISTENING|EZ_ENV_READING]
                        , nil];
    [avDays.availableTimes addObjectsFromArray:avTimes];
    [self.availableDays addObject:avDays];
    
}

- (void) clean
{
    [scheduledDays removeAllObjects];
    [tasks removeAllObjects];
    [achievedTasks removeAllObjects];
    [availableDays removeAllObjects];
}

- (id) init
{
    self = [super init];
    //Will load all the data from the persistence storage.
    scheduleDays = [[NSMutableArray alloc] init];
    tasks = [[NSMutableArray alloc] init];
    achievedTasks = [[NSMutableArray alloc] init];
    availableDays = [[NSMutableArray alloc] init];
    storedScheduledTasks = [[NSMutableDictionary alloc] init];
    
    //[self fillTestData];
    return self;
}

- (NSArray*) getScheduledTaskByDate:(NSDate*)date
{
    NSString* keyStr = [date stringWithFormat:@"yyyyMMdd"];
    return [storedScheduledTasks objectForKey:keyStr];
}

//Including the date of start and end.
- (int) getTaskTime:(EZTask*)task start:(NSDate*)start end:(NSDate*)end
{
    int res = 0;
    for(EZScheduledTask* schTask in storedScheduledTasks){
        if([schTask.task isEqual:task] && [schTask.startTime InBetweenDays:start end:end]){
            res += schTask.duration;
        }
    }
    return res;
}

- (void) storeScheduledTask:(NSArray*)stasks date:(NSDate*)date
{
    NSString* keyStr = [date stringWithFormat:@"yyyyMMdd"];
    [storedScheduledTasks setObject:stasks forKey:keyStr];
}

+ (EZTaskStore*) getInstance
{
    static EZTaskStore* res;
    if(res){
        return res;
    }
    res = [[EZTaskStore alloc] init];
    return res;
}

- (NSArray*) getTasks:(int)env
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:[tasks count]];
    for(int i = 0; i < [tasks count]; i++){
        EZTask* task = [tasks objectAtIndex:i];
        //Mean the environment meet the task requirements
        if((task.envTraits & env) == task.envTraits){
            [res addObject:task];
        }
    }
    return res;
}

NSInteger comparator(id obj1, id obj2, void* ctx)
{
    EZScheduledDay* day1 = (EZScheduledDay*)obj1;
    EZScheduledDay* day2 = (EZScheduledDay*)obj2;
    return [day1.scheduledDay compare:day2.scheduledDay];
}

// The result are sorted by date, mean the latest are at the beginning
- (NSArray*) getSortedScheduledDays
{
    NSArray* res = nil;
    res = [scheduleDays sortedArrayUsingFunction:comparator context:nil];
    return res;
}


// Find the scheduledDay for a particular date.
- (EZScheduledDay*) getScheduledDayByDate:(NSDate*)date
{
    for(int i = 0; i < [scheduleDays count]; i++ ){
        EZScheduledDay* sday = [scheduleDays objectAtIndex:i];
        if([sday.scheduledDay convertDays] == [date convertDays]){
            return sday;
        }
    }
    return nil;
}


// Pick a allocated pattern for that day 
- (EZAvailableDay*) getAvailableDay:(NSDate*)date
{
    EZAvailableDay* matchedWeek = nil;
    EZWeekDayValue week = [date weekDay];
    for(int i = 0; i < [availableDays count]; i++ ){
        EZAvailableDay* sday = [availableDays objectAtIndex:i];
        if([sday.date convertDays] == [date convertDays]){
            matchedWeek = sday;
            break;
        }else if((sday.assignedWeeks&week) == week){
            matchedWeek = sday;
        }
    }
    EZDEBUG(@"Not match exact day, matched week %@",matchedWeek);
    return [matchedWeek duplicate];
}



@end
