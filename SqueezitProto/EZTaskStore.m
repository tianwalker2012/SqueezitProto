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
#import "EZQuotas.h"
#import "EZCoreAccessor.h"
#import "MTask.h"
#import "MScheduledTask.h"
#import "MQuotas.h"
#import "MTaskGroup.h"
#import "MAvailableDay.h"
#import "MAvailableTime.h"


@interface EZTaskStore(private)

@end


@implementation EZTaskStore
// The purpose of this functinality 
// is to fill the store with the test data, so that we could go ahead and do the test accordingly.
// I love it.
- (void) fillTestData 
{
    
    EZTask* design = [[EZTask alloc] initWithName:@"App design" duration:40 maxDur:90 envTraits:EZ_ENV_FLOWING];
    NSDate* startDate = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120528"];
    EZQuotas* designQuotas = [[EZQuotas alloc] init:startDate quotas:630 type:WeekCycle cycleStartDate:nil cycleLength:7];
    design.quotas = designQuotas;
    
    
    EZTask* iosTask = [[EZTask alloc] initWithName:@"iOS development" duration:40 maxDur:120 envTraits:EZ_ENV_FLOWING];
    EZQuotas* iosQuotas = [[EZQuotas alloc] init:startDate quotas:1260 type:WeekCycle cycleStartDate:nil cycleLength:7];
    iosTask.quotas = iosQuotas;
    
    EZTask* codeReading = [[EZTask alloc] initWithName:@"Code reading" duration:40 maxDur:90 envTraits:EZ_ENV_FLOWING];
    EZQuotas* codeReadingQuotas = [[EZQuotas alloc] init:startDate quotas:420 type:WeekCycle cycleStartDate:nil cycleLength:7];
    codeReading.quotas = codeReadingQuotas;
    
     NSArray* tks = [NSArray arrayWithObjects:
                     //Fitting tasks
                     [[EZTask alloc] initWithName:@"Tai ji" duration:15 maxDur:90 envTraits:EZ_ENV_FITTING],
                     [[EZTask alloc] initWithName:@"Jujisu" duration:15 maxDur:90 envTraits:EZ_ENV_FITTING],
                     [[EZTask alloc] initWithName:@"Swimming" duration:60 maxDur:150 envTraits:EZ_ENV_FITTING],
                     
                     //Flowing tasks
                     iosTask,
                     codeReading,
                     design,
                     
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
    
    //[self.tasks addObjectsFromArray:tks];
    [self storeObjects:tks];
    EZAvailableDay* avDays = [[EZAvailableDay alloc] initWithName:@"Default setting" weeks:ALLDAYS];
    NSArray* avTimes = [NSArray arrayWithObjects:
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"05:30:00"] name:@"大便时段" duration:30 environment:EZ_ENV_READING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"06:00:00"] name:@"Morning reading" duration:60 environment:EZ_ENV_READING|EZ_ENV_LISTENING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"07:00:00"] name:@"晨练" duration:90 environment:EZ_ENV_FITTING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"09:00:00"] name:@"Walk to Metro" duration:25 environment:EZ_ENV_LISTENING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"09:30:00"] name:@"Metro" duration:30 environment:EZ_ENV_READING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"10:15:00"] name:@"Morning flow" duration:135 environment:EZ_ENV_FLOWING|EZ_ENV_READING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"14:00:00"] name:@"Afternoon flow" duration:240 environment:EZ_ENV_FLOWING|EZ_ENV_READING],
                        [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"19:15:00"] name:@"After dinner" duration:60 environment:EZ_ENV_SOCIALING],
                         [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm:ss" dateString:@"20:30:00"] name:@"Night hours" duration:105 environment:EZ_ENV_FLOWING|EZ_ENV_LISTENING|EZ_ENV_READING]
                        , nil];
    [avDays.availableTimes addObjectsFromArray:avTimes];
    //[self.availableDays addObject:avDays];
    [self storeObject:avDays];
    
}

- (void) clean
{
}

- (id) init
{
    self = [super init];
    
    //[self fillTestData];
    return self;
}

- (void) storeObjects:(NSArray*) objects
{
    for(NSObject<EZValueObject>* obj in objects){
        [self storeObject:obj];
    }
}

- (void) storeObject:(NSObject<EZValueObject>*)obj
{
    [[EZCoreAccessor getInstance] store:obj.createPO];
}

- (void) removeObject:(NSObject<EZValueObject>*)obj
{
    if(obj.PO){
        [[EZCoreAccessor getInstance] remove:obj.PO];
    }
}

- (void) removeObjects:(NSArray*) objects
{
    for(NSObject<EZValueObject>* obj in objects){
        [self removeObject:obj];
    }
}

- (NSArray*) getAllTasks
{
    return [self fetchAllWithVO:[EZTask class] po:[MTask class]];
}

// So far it is clean, have a name for every PO seems a simpler solution
// You just set it as option, what harm it can cause us?
// Keep it as simple as possible.
- (NSArray*) fetchAllWithVO:(Class)voType po:(Class)poType
{
    NSArray* allPos = [[EZCoreAccessor getInstance] fetchAll:poType sortField:nil];
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:[allPos count]];
    for(NSManagedObject* po in allPos){
        NSObject<EZValueObject>* vo = [[voType alloc] initWithPO:po];
        [res addObject:vo];
    }
    return res;
}


//Need refractor later.
//As the history data keep increasing. 
//Learn how to do conditional query to get only record I interested out. 
- (NSArray*) getScheduledTaskByDate:(NSDate*)date
{
    NSString* keyStr = [date stringWithFormat:@"yyyyMMdd"];
    NSArray* schTasks = [[EZCoreAccessor getInstance] fetchAll:[MScheduledTask class] sortField:@"startTime"];
    //I am wondering how the sort could work? anyway let's try it
    NSMutableArray* res = [[NSMutableArray alloc] init];
    
    for(MScheduledTask* mschTask in schTasks){
        if([keyStr compare:[mschTask.startTime stringWithFormat:@"yyyyMMdd"]] == NSOrderedSame){
            [res addObject:[[EZScheduledTask alloc] initWithPO:mschTask]];
        }
    }
    return res;
}

//Including the date of start and end.
//
- (int) getTaskTime:(EZTask*)task start:(NSDate*)start end:(NSDate*)end
{
    int res = 0;
    MTask* mt = task.PO;
    NSArray* mschTasks = [[EZCoreAccessor getInstance] fetchAll:[MScheduledTask class] sortField:@"startTime"];
    for(MScheduledTask* schTask in mschTasks){
            if([schTask.task isEqual:mt] && [schTask.startTime InBetweenDays:start end:end]){
                res += schTask.duration.intValue;
            }
    }
    return res;
}

//Keep it simple and stupid.
//But for my functionality to work, I need NSMutableArray.
//Start do it now. 
//Keep it as simple and stupid as possible.
//Make the behavior like following
//If the list have nothing exist, will create the mutableArray.
//If already exist will be Append. Cool. 
- (void) storeScheduledTask:(NSArray*)stasks date:(NSDate*)date
{
    for(EZScheduledTask* schTask in stasks){
        [[EZCoreAccessor getInstance] store:schTask.createPO];
    }
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
    NSArray* mtasks = [[EZCoreAccessor getInstance] fetchAll:[MTask class] sortField:nil];
    NSLog(@"Fetch all returned: %i",[mtasks count]);
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:[mtasks count]];
    for(MTask* mt in mtasks){
        //Mean the environment meet the task requirements
        if((mt.envTraits.intValue & env) == mt.envTraits.intValue){
            [res addObject:[[EZTask alloc] initWithPO:mt]];
        }
    }
    return res;
}

// Pick a allocated pattern for that day
- (EZAvailableDay*) getAvailableDay:(NSDate*)date
{
    EZAvailableDay* matchedWeek = nil;
    EZWeekDayValue week = [date weekDay];
    NSArray* mDays = [[EZCoreAccessor getInstance] fetchAll:[MAvailableDay class] sortField:nil];
    for(MAvailableDay* day in mDays){
        if([day.date convertDays] == [date convertDays]){
            matchedWeek = [[EZAvailableDay alloc] initWithPO:day];
            break;
        }else if((day.assignedWeeks.intValue&week) == week){
            matchedWeek = [[EZAvailableDay alloc] initWithPO:day];
        }
    }
    EZDEBUG(@"Not match exact day, matched week %@",matchedWeek);
    return [matchedWeek duplicate];
}



@end
