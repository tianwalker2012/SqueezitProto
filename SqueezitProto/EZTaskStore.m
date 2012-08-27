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
#import "EZTaskGroup.h"
#import "EZEnvFlag.h"
#import "EZGlobalLocalize.h"
#import "MEnvFlag.h"
#import "EZArray.h"
#import "EZScheduleStats.h"
#import "MScheduledDay.h"


@interface EZTaskStore(private)

@end


@implementation EZTaskStore
@synthesize flagToEnvFlag, envFlags, allFlagToEnvFlag, allEnvFlags;

//The purpose of this functionality is to fill the data which is necessary for the environment flag. 
//Previously, I am using the enum, but not extensible. 
//It is smelly, I pick this method. 
- (void) fillEnvFlag
{
    NSArray* flags = [NSArray arrayWithObjects:
                      [[EZEnvFlag alloc] initWithName:@"OutDoor" flag:2],
                      [[EZEnvFlag alloc] initWithName:@"Stable" flag:3],
                      [[EZEnvFlag alloc] initWithName:@"Quiet" flag:5],
                      [[EZEnvFlag alloc] initWithName:@"Socialize" flag:7],
                      [[EZEnvFlag alloc] initWithName:@"Private" flag:11]
                      , nil];
    [[EZTaskStore getInstance] storeObjects:flags];
}


// The purpose of this functinality 
// is to fill the store with the test data, so that we could go ahead and do the test accordingly.
// I love it.
- (void) fillTestData 
{
    
    [self fillEnvFlag];
    
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
    
    
    NSDate* now = [NSDate date];
    
    EZTaskGroup* fittingGroup = [[EZTaskGroup alloc] init];
    fittingGroup.name = @"WorkOut";
    fittingGroup.displayOrder = 1;
    fittingGroup.createdTime = now;
    fittingGroup.tasks = [NSArray arrayWithObjects:
                          //Fitting tasks
                          [[EZTask alloc] initWithName:@"Tai ji" duration:15 maxDur:90 envTraits:EZ_ENV_FITTING],
                          [[EZTask alloc] initWithName:@"Jujisu" duration:15 maxDur:90 envTraits:EZ_ENV_FITTING],
                          [[EZTask alloc] initWithName:@"Swimming" duration:60 maxDur:150 envTraits:EZ_ENV_FITTING],
                          nil];
    
    EZTaskGroup* quotasGroup = [[EZTaskGroup alloc] init];
    quotasGroup.name = @"Task With Quotas";
    quotasGroup.createdTime = now;
    quotasGroup.displayOrder = 0;
    quotasGroup.tasks = [NSArray arrayWithObjects:iosTask, codeReading, design, nil];
    
    EZTaskGroup* snippetGroup = [[EZTaskGroup alloc] init];
    snippetGroup.name = @"Snippet Tasks";
    snippetGroup.createdTime = now;
    snippetGroup.displayOrder = 2;
    snippetGroup.tasks = [NSArray arrayWithObjects:
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
    NSArray* groups = [NSArray arrayWithObjects:fittingGroup,quotasGroup,snippetGroup, nil];
    
    
    //[self.tasks addObjectsFromArray:tks];
    //[self storeObjects:tks];
    [self storeObjects:groups];
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
    
    //Fill test data to test the slider implementation
    EZScheduledDay* his1 = [[EZScheduledDay alloc] init];
    his1.scheduledDate = [[NSDate date] adjustDays:-4];
    
    EZScheduledDay* his2 = [[EZScheduledDay alloc] init];
    his2.scheduledDate = [[NSDate date] adjustDays:-3];
    
    EZScheduledDay* his3 = [[EZScheduledDay alloc] init];
    his3.scheduledDate = [[NSDate date] adjustDays:-2];
    
    EZScheduledDay* his4 = [[EZScheduledDay alloc] init];
    his4.scheduledDate = [[NSDate date] adjustDays:-1];
    
    [[EZTaskStore getInstance] storeObjects:[NSArray arrayWithObjects:his1, his2, his3, his4, nil]];
    
    
    EZScheduledTask* tk1 = [[EZScheduledTask alloc] init];
    tk1.startTime = his1.scheduledDate;
    tk1.duration = 10;
    tk1.task = iosTask;
    
    EZScheduledTask* tk2 = [[EZScheduledTask alloc] init];
    tk2.startTime = his2.scheduledDate;
    tk2.duration = 20;
    tk2.task = design;
    
    EZScheduledTask* tk3 = [[EZScheduledTask alloc] init];
    tk3.startTime = his3.scheduledDate;
    tk3.duration = 30;
    tk3.task = codeReading;
    
    EZScheduledTask* tk4 = [[EZScheduledTask alloc] init];
    tk4.startTime = his4.scheduledDate;
    tk4.duration = 40;
    tk4.task = iosTask;
    [[EZTaskStore getInstance] storeObjects:[NSArray arrayWithObjects:tk1, tk2, tk3, tk4, nil]];
    
    
}



//Since the ObjectID can be transfer to URL string, string is serailizeable
//So I am doing this now. 
- (EZScheduledTask*) fetchScheduledTaskByURL:(NSString*)urlStr
{
    NSArray* schTasks = [self fetchAllWithVO:[EZScheduledTask class] PO:[MScheduledTask class] sortField:@"startTime"];
    for(EZScheduledTask* schTask in schTasks){
        if([urlStr isEqualToString:schTask.PO.objectID.URIRepresentation.absoluteString]){
            return schTask;
        }
    }
    return nil;
}

//Read flags into a NSDictionary
//Every tiem somebody added a flag, this method will get called
- (void) populateEnvFlags
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"deleted != 1"];
    NSArray* flags = [self fetchWithPredication:predicate VO:[EZEnvFlag class] PO:[MEnvFlag class] sortField:@"flag"];
    self.envFlags = [NSMutableArray arrayWithArray:flags];
    //EZDEBUG(@"The last flag:%i, array Count:%i", ((EZEnvFlag*)[self.envFlags objectAtIndex:envFlags.count-1]).flag, self.envFlags.count);
    self.flagToEnvFlag = [[NSMutableDictionary alloc] init];
    for(EZEnvFlag* flag in flags){
        [self.flagToEnvFlag setObject:flag forKey:[[NSNumber alloc] initWithUnsignedInteger:flag.flag]];
    }
    
    //Even deleted flags will be included in this.
    NSArray* allFlags = [self fetchAllWithVO:[EZEnvFlag class] PO:[MEnvFlag class] sortField:@"flag"];
    
    self.allEnvFlags = [NSMutableArray arrayWithArray:allFlags];
    self.allFlagToEnvFlag = [[NSMutableDictionary alloc] init];
    for(EZEnvFlag* flag in allFlags){
        [self.allFlagToEnvFlag setObject:flag forKey:[[NSNumber alloc] initWithUnsignedInteger:flag.flag]];
    }
    
}

//Save the headache for memory management.
- (EZArray*) flagsToArray
{
    EZArray* res = [[EZArray alloc] initWithCapacity:envFlags.count];
    int i = 0;
    for(EZEnvFlag* flag in self.envFlags){
        res.uarray[i] = flag.flag;
    }
    return res;
}

//Who need clean? 
//What's the purpose of clean?
//Clean of what?
- (void) clean
{
}

//The stats for all the tasks during a period of times
- (NSArray*) statsTaskFrom:(NSDate*)from to:(NSDate*)to
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startTime > %@ AND startTime < %@", from, to];
    NSArray* tasks = [self fetchWithPredication:predicate VO:[EZScheduledTask class] PO:[MScheduledTask class] sortField:nil];
    
    //Alloc larger dictionary size
    //EZDEBUG(@"ScheduledTask count:%i", tasks.count);
    NSMutableDictionary* taskIDToStats = [[NSMutableDictionary alloc] initWithCapacity:tasks.count];
    [tasks iterate:^(EZScheduledTask* schTask){
        //EZDEBUG(@"fetch stats from dictionary, for:%@",schTask.task.name);
        EZScheduleStats* stats = [taskIDToStats objectForKey:schTask.task.PO.objectID];
        if(stats == nil){
            stats = [[EZScheduleStats alloc] initWithName:schTask.task.name];
            stats.statsStart = from;
            stats.statesEnd = to;
            [taskIDToStats setObject:stats forKey:schTask.task.PO.objectID];
        }
        stats.totalTime += schTask.duration;
    }];
 
    return [taskIDToStats.allValues sortedArrayUsingComparator:^(EZScheduleStats* stat1, EZScheduleStats* stat2){
        return stat2.totalTime - stat1.totalTime;
    }];
}

- (NSArray*) statsTaskClusterByGroupFrom:(NSDate*)from to:(NSDate*)to
{
    NSArray* taskGroups = [self fetchAllWithVO:[EZTaskGroup class] PO:[MTaskGroup class] sortField:nil];
    
    NSMutableDictionary* taskToGroup = [[NSMutableDictionary alloc] init];
    [taskGroups iterate:^(EZTaskGroup* group){
        [group.tasks iterate:^(EZTask* tk){
            [taskToGroup setObject:group forKey:tk.PO.objectID];
        }];
    }];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startTime > %@ AND startTime < %@", from, to];
    NSArray* schTasks = [self fetchWithPredication:predicate VO:[EZScheduledTask class] PO:[MScheduledTask class] sortField:nil];
    
    NSMutableDictionary* statsMap = [[NSMutableDictionary alloc] init];
    [schTasks iterate:^(EZScheduledTask* schTk){
        EZTaskGroup* tg = [taskToGroup objectForKey:schTk.task.PO.objectID];
        EZScheduleStats* stats = [statsMap objectForKey:tg.PO.objectID];
        if(stats == nil){
            stats = [[EZScheduleStats alloc] initWithName:tg.name];
            stats.statsStart = from;
            stats.statesEnd = to;
            [statsMap setObject:stats forKey:tg.PO.objectID];
        }
        stats.totalTime += schTk.duration;
        [stats.datas addObject:schTk];
    }];
    
    //Sort by the most consumed time
    return [statsMap.allValues sortedArrayUsingComparator:^(EZScheduleStats* stat1, EZScheduleStats* stat2){
        return stat2.totalTime - stat1.totalTime;
    }];
}

//Find the statistics for one particular task at this particular time period
- (EZScheduleStats*) findTaskStats:(EZTask*)tk from:(NSDate*)from to:(NSDate*)to
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"task.objectID = %@ AND startTime > %@ AND startTime < %@", tk.PO.objectID, from, to];
    NSArray* schTasks = [self fetchWithPredication:predicate VO:[EZScheduledTask class] PO:[MScheduledTask class] sortField:nil];
    EZScheduleStats* res = [[EZScheduleStats alloc] initWithName:tk.name];
    res.statsStart = from;
    res.statesEnd = to;
    EZDEBUG(@"Scheduled:%@, between:%@ and %@ is %i",tk.name, [from stringWithFormat:@"yyyyMMdd"], [to stringWithFormat:@"yyyyMMdd"],schTasks.count);
    [schTasks iterate:^(EZScheduledTask* scTk){
        res.totalTime += scTk.duration;
    }];
    return res;
    
}

//This will get all the schedule task from to to.
//A EZScheduleStats object was created. 
//A total hours will be recorded in this object.
//Who will use this method?
//At the history stats page, I will pick the top 3 tasks to show off.
- (NSArray*) statsFetchScheduledTaskFrom:(NSDate*)from to:(NSDate*)to
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startTime > %@ AND startTime < %@",from ,to];
    NSArray* schTasks = [self fetchWithPredication:predicate VO:[EZScheduledTask class] PO:[MScheduledTask class] sortField:nil];
    NSMutableDictionary* dicts = [[NSMutableDictionary alloc] init];
    [schTasks iterate:^(EZScheduledTask* schTk){
        EZScheduleStats* ss = [dicts objectForKey:schTk.task.PO.objectID];
        if(ss == nil){
            ss = [[EZScheduleStats alloc] initWithName:schTk.task.name];
            [dicts setObject:ss forKey:schTk.task.PO.objectID];
            ss.statsStart = from;
            ss.statesEnd = to;
        }
        ss.totalTime += schTk.duration;
        [ss.datas addObject:schTk];
    }];
    
    //I will resturn a reverse organized objects. 
    return [dicts.allValues sortedArrayUsingComparator:^(EZScheduleStats* stat1, EZScheduleStats* stat2){
        return stat2.totalTime - stat1.totalTime;
    }];
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
    EZDEBUG(@"Remove object in TaskStore, PO is:%@", obj.PO);
    if(obj.PO){
        EZDEBUG(@"Remove object");
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
    return [self fetchAllWithVO:[EZTask class] PO:[MTask class] sortField:nil];
}

// So far it is clean, have a name for every PO seems a simpler solution
// You just set it as option, what harm it can cause us?
// Keep it as simple as possible.
- (NSArray*) fetchAllWithVO:(Class)voType PO:(Class)poType sortField:(NSString *)field
{
    NSArray* allPos = [[EZCoreAccessor getInstance] fetchObject:poType byPredicate:nil withSortField:field];
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:[allPos count]];
    for(NSManagedObject* po in allPos){
        NSObject<EZValueObject>* vo = [[voType alloc] initWithPO:po];
        [res addObject:vo];
    }
    return res;
}

//Fetch VO and PO with conditions
- (NSArray*) fetchWithPredication:(NSPredicate*)predicate VO:(Class)voType PO:(Class)poType sortField:(NSString*)field
{
    NSArray* fetched = [[EZCoreAccessor getInstance] fetchObject:poType byPredicate:predicate withSortField:field];
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:[fetched count]];
    for(NSManagedObject* po in fetched){
        NSObject<EZValueObject>* vo = [[voType alloc] initWithPO:po];
        [res addObject:vo];
    }
    return res;
    
}

//Strange I do the duplication check here.
//Should have no duplication of the date exist.
//Let's check where other place EZScheduledDay
//I get the point now.
//This is not a right place for this method. 
//Let's put it to EZTaskStore
- (EZScheduledDay*) createDayNotExist:(NSDate*)date
{
    NSDate* begin = date.beginning;
    NSDate* end = [begin adjust:SecondsPerDay - 1];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"scheduledDate >= %@ AND scheduledDate <= %@",begin, end];
    NSArray* scheduledDayArr = [self fetchWithPredication:predicate VO:[EZScheduledDay class] PO:[MScheduledDay class] sortField:nil];
    if(scheduledDayArr.count == 0){
        EZScheduledDay* sd = [[EZScheduledDay alloc] init];
        sd.scheduledDate = date;
        [self storeObject:sd];
        return sd;
    }else{
        //[scheduledDayArr iterate:^(EZScheduledDay* sd){
            //EZDEBUG(@"Date:%@",[sd.scheduledDate stringWithFormat:@"yyyyMMdd"]);
        //}];
        //assert(scheduledDayArr.count == 1);
        return [scheduledDayArr objectAtIndex:0];
    }
}

//Need refractor later.
//As the history data keep increasing. 
//Learn how to do conditional query to get only record I interested out. 
- (NSArray*) getScheduledTaskByDate:(NSDate*)date
{
    NSDate* begin  = date.beginning;
    NSDate* end = [begin adjust:SecondsPerDay-1];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"startTime > %@ AND startTime < %@",begin, end];
    return [[EZTaskStore getInstance]fetchWithPredication:predicate VO:[EZScheduledTask class] PO:[MScheduledTask class] sortField:@"startTime"];
}

//Why do we need a specific method for delete taskGroup.
//Because we want to only delete the group still keep the task. 
//Why?
//Otherwise, the history scheduledTask will failed to get any information.
//Man, this is cool.
//Only code walk through could give you idea like this.
- (void) deleteTaskgroup:(EZTaskGroup*) tgroup
{
    //I have an assumption here. Mean system will on delete the group without touch the tasks.
    //Need a test.
    //Do you understand why we encounter errors?
    //Because the tgroups will remove all the tasks under it. 
    //So it will store the tasks with ObjectID, coreData have some rule regarding the objectID. I guess. So it failed
    NSArray* tasks =[NSArray arrayWithArray: tgroup.tasks];
    [tgroup.tasks removeAllObjects];
    [self storeObject:tgroup];
    [self removeObject:tgroup];
    [self deleteTasks:tasks];
    
}

- (void) deleteFlag:(EZEnvFlag*)evFlag
{
    evFlag.deleted = TRUE;
    [self storeObject:evFlag];
}

- (void) deleteTask:(EZTask*)task
{
    task.deleted = true;
    [self storeObject:task];
}

- (void) deleteTasks:(NSArray*)tasks
{
    [tasks iterate:^(EZTask* tk){
        [self deleteTask:tk];
    }];
}

//I assume the flag in database is 1 for true, zero for false.
//Let's test it accordingly.
- (NSArray*) getTasks
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"deleted != 1"];
    return [[EZTaskStore getInstance]fetchWithPredication:predicate VO:[EZTask class] PO:[MTask class] sortField:nil];
}

//Remove the tasks in one particular day
- (void) removeScheduledTaskByDate:(NSDate*)date
{
    NSArray* schTasks = [self getScheduledTaskByDate:date];
    [self removeObjects:schTasks];
}

//Including the date of start and end.
//
- (int) getTaskTime:(EZTask*)task start:(NSDate*)start end:(NSDate*)end
{
    int res = 0;
    //MTask* mt = task.PO;
    NSArray* mschTasks = [self fetchAllWithVO:[EZScheduledTask class] PO:[MScheduledTask class] sortField:@"startTime"];
    for(EZScheduledTask* schTask in mschTasks){
            if([schTask.task isEqual:task] && [schTask.startTime InBetweenDays:start end:end]){
                res += schTask.duration;
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

- (NSArray*) getTasks:(NSUInteger)env
{
    NSArray* mtasks = [[EZCoreAccessor getInstance] fetchAll:[MTask class] sortField:nil];
    NSLog(@"Fetch all returned: %i",[mtasks count]);
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:[mtasks count]];
    for(MTask* mt in mtasks){
        //Mean the environment meet the task requirements
        if(isContained(mt.envTraits.unsignedIntegerValue, env)){
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
    return [matchedWeek cloneVO];
}

//What's kind of Env involved in this flags
- (NSArray*) EnvStringForFlags:(NSUInteger)flags
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    for(EZEnvFlag* flag in self.envFlags){
        if(isContained(flag.flag, flags)){
            [res addObject:EZLocalizedString(flag.name, nil)];
        }
    }
    return res;
}

- (NSString*) StringForFlags:(NSUInteger)flags
{
    return [[self StringArrayForFlags:flags] componentsJoinedByString:@" "];
}

- (NSArray*) StringArrayForFlags:(NSUInteger)flags
{
    NSMutableArray* res = [[NSMutableArray alloc] init];
    for(EZEnvFlag* flag in self.allEnvFlags){
        if(isContained(flag.flag, flags)){
            [res addObject:EZLocalizedString(flag.name, nil)];
        }
    }
    if(res.count == 0){
        [res addObject:EZLocalizedString(@"Env None", nil)];
    }
    return res;    
}

//Need a test see if the only setup for the time 
//Will enable this notification to get fired?
//Easy to test.
- (UILocalNotification*) createDailyNotificationByDate:(NSDate*)date
{
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    notification.alertBody = Local(@"Would you like shedule for tomorrow");
    //Mean I can pick my own customized name?
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    notification.repeatCalendar = nil;
    notification.repeatInterval = kCFCalendarUnitDay;
    NSDictionary* infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[date stringWithFormat:@"MMdd HH:mm"], EZAssignNotificationKey ,nil];
    notification.userInfo = infoDict;
    return notification;
}

//Get current used daily notification
- (UILocalNotification*) getDailyNotification
{
    NSString* tomorrowNofityKey = @"TomorrowNotificationKey";
    NSUserDefaults* userSetting = [NSUserDefaults standardUserDefaults];
    id notifyObj = [userSetting objectForKey:tomorrowNofityKey];
    if(notifyObj){
        return [NSKeyedUnarchiver unarchiveObjectWithData:notifyObj];
    }
    return nil;
}


//Will cancel the old notification and store and setup the new notification
- (void) setDailyNotification:(UILocalNotification*)notification
{
    NSString* tomorrowNofityKey = @"TomorrowNotificationKey";
    NSUserDefaults* userSetting = [NSUserDefaults standardUserDefaults];
    [userSetting setValue:[NSKeyedArchiver archivedDataWithRootObject:notification] forKey:tomorrowNofityKey];
}


//Will be called to check if it is the first time application start
//So the logic is simple and straightforward
//If it is the first time mean there is not value under the key
//Otherwise mean it is not the first time
- (BOOL) isFirstTime
{
    NSString* firstTimeKey = @"FirstTimeKey";
    NSUserDefaults* userSetting = [NSUserDefaults standardUserDefaults];
    return [userSetting valueForKey:firstTimeKey] ? false:true;
}

//Setup the firstTime flag.
- (void) setFirstTime:(BOOL)firstTime
{
    NSString* firstTimeKey = @"FirstTimeKey";
    NSUserDefaults* userSetting = [NSUserDefaults standardUserDefaults];
    if(firstTime){
        //Mean I want to continue first Time what should I do?
        //Remove the flag from the dictionary.
        [userSetting removeObjectForKey:firstTimeKey];
        
    }else{
        [userSetting setValue:@"SecondTime" forKey:firstTimeKey];
    }
}

//What's the purpose of this method?
//Because the envFlags flag will need to be the next prime number so can not be 
//Initialize at will. 
//This Method will generate the next prime number and instantiate EZEnvFlag 
- (EZEnvFlag*) createNextFlagWithName:(NSString *)name
{
    NSUInteger nextFlag = findPrimeAfter(((EZEnvFlag*)allEnvFlags.lastObject).flag);
    EZDEBUG(@"The nextFlag is:%i", nextFlag);
    EZEnvFlag* res = [[EZEnvFlag alloc] initWithName:name flag:nextFlag];
    [self storeObject:res];
    //[self.envFlags addObject:res];
    return res;
    
}

@end

NSString* envTraitsToString(NSUInteger envTraits)
{
    if(envTraits == EZ_ENV_NO_REQ){
        return Local(@"None");
    }
    if(envTraits == EZ_ENV_SUIT_ALL){
        return Local(@"Suitable For All");
    }
    //NSMutableString* res = [[NSMutableString alloc] init];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    NSArray* flags = [EZTaskStore getInstance].allEnvFlags;
    NSUInteger flagCount = envTraits;
    for(EZEnvFlag* flag in flags){
        if(flagCount== 1){
            break;
        }
        if(isContained(flag.flag, flagCount)){
            [arr addObject:Local(flag.name)];
            flagCount = flagCount/flag.flag;
        }
    }
    return [arr componentsJoinedByString:@" "];
}


