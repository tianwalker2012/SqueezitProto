//
//  EZTestSuite.m
//  SqueezitProto
//
//  Created by Apple on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
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
#import "EZReleaseDetector.h"
#import "EZCoreAccessor.h"
#import "MAvailableDay.h"
#import "MTask.h"
#import "MTaskGroup.h"
#import "MQuotas.h"
#import "MScheduledTask.h"
#import "MImageOwner.h"
#import "EZCoreAccessor.h"
#import "MAvailableTime.h"
#import "EZGlobalLocalize.h"
#import "EZTaskGroup.h"
#import "EZArray.h"
#import "EZEditLabelCellHolder.h"
#import "EZScheduledCell.h"
#import "EZScheduledDay.h"
#import "MScheduledDay.h"
#import "EZLRUMap.h"


#define TestValue 60*20

//Block definition
//No copy and paste, typing every code by your hand. Learn with your whole body.
typedef void(^TestBlock)(id obj);


typedef int(^ClosureTest)();

@interface ComparedObject : NSObject

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) NSInteger age;

@end

@implementation ComparedObject
@synthesize name, age;

@end

@interface ComparedObjectEx : NSObject

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) NSInteger age;

@end

@implementation ComparedObjectEx
@synthesize name, age;

- (BOOL) isEqual:(ComparedObjectEx*)object
{
    if(object == self){
        return true;
    }
    return [self.name isEqual:object.name] && (self.age == object.age);
}

@end


@interface IntCarrier : NSObject

@property (assign, nonatomic) int value;
@property (assign, nonatomic) BOOL animated;

@end

@implementation IntCarrier
@synthesize  value, animated;

- (BOOL) isAnimated
{
    EZDEBUG(@"isAnimated get called");
    return false;
}

- (BOOL) getAnimated
{
    EZDEBUG(@"getAnimated get called");
    return false;
};

- (BOOL) animated
{
    EZDEBUG(@"Animated get called");
    return false;
}

- (void) setAnimated:(BOOL)at
{
    EZDEBUG(@"Set animated get called");
    animated = at;
}

@end


@interface WeakReferObject : NSObject
//@property(, nonatomic) id referred;
@property(strong, nonatomic) TestBlock strongRef;
@property(strong, nonatomic) EZReleaseDetector* strongRed;
@end

@implementation WeakReferObject

- (void) dealloc
{
    EZDEBUG(@"WeakReferObject dealloc");
}
//@synthesize referred;
@synthesize strongRef, strongRed;
@end

@interface TestObject1 : NSObject

- (NSArray*) generateArray;

- (TestBlock) createBlock;

@end


@implementation TestObject1

- (NSArray*) generateArray
{
    return [NSArray arrayWithObject:@"Coolguy"];
}

- (TestBlock) createBlock
{
    EZReleaseDetector* dectector = [[EZReleaseDetector alloc] initWithName:@"Released" hasStackTrace:TRUE];
    static int count = 0;
    
    return ^(id obj){ 
        EZDEBUG(@"Time %i,Check name:%@",count,dectector.name);
        if(count == 0){
            assert(dectector != nil);
        } else {
            assert(dectector != nil);
        }
        ++ count;
    };
}

@end

@interface EZTestSuite(private)

+ (void) innerTestAll;
+ (void) testMainCase;
+ (void) testComprehansiveCase;
//+ (void) testTaskStore;
+ (void) testAvailableTime;
+ (EZScheduledTask*) findTask:(EZTask*)task scheduled:(NSArray*)scheduleList;
+ (void) testTaskFetch;
+ (void) testAvailableTimeMatchWeekAndDay;
+ (void) testTaskPick;
+ (void) testExclusive;
+ (void) testTestData;
+ (void) testQuotasTask;
+ (void) testQuotasWithHistory;
+ (void) testIndexPath;
+ (void) testTimeIntervelSinceNow;
+ (void) testMethodAsProperty;
+ (void) testBlockMemory;
+ (WeakReferObject*) withBlockCall:(EZReleaseDetector*)dect;
+ (WeakReferObject*) withDetector:(EZReleaseDetector*)dect;

+ (void) testSimpleData;

+ (void) initializeDB;

+ (EZAvailableTime*) findTimeByObjectID:(NSManagedObjectID*)objID list:(NSArray*)list;

+ (void) testTimePassed;

+ (void) testTimeSort;

+ (void) testInBetween;

+ (void) testTrim;

+ (void) testI18N;

+ (void) testCascadeDelete;

+ (void) testStoreSideEffect;

+ (void) testPrimeSeries;

+ (void) testMemorySet;

+ (void) testMemoryCopy;

+ (void) testArrayFilter;

+ (void) testAvTimeRelationship;

+ (void) testEZQuotasProperty;

+ (void) testCellCreatorSingleton;

+ (void) testClosure;

+ (void) testAvailableTimeFilter;

+ (void) testRescheduleFilter;

+ (void) testRescheduleAll;

+ (void) testInterToHex;

+ (void) testQuotasEffective;

+ (void) testGetPaddingDay;

+ (void) testCalcHistoryTime;

+ (void) testCalcHistoryTimeWithPadding;

+ (void) testNumberOutput;

+ (void) testObjectIDSerialize;

+ (void) testNSMutableArray;

+ (void) testPredicate;

+ (void) testFetchWithPredicate;

+ (void) testBooleanAccessor;

+ (void) testArrayContainAndStringEqual;

+ (void) testPredicateForScheduledDay;

+ (void) testLRUMap;

+ (void) testArrayExchange;

+ (void) testAvDayCascadeStore;

+ (void) testTaskGroupCascade;

//Used to clean the notification, make a clean room for myself.
+ (void) cleanAllLocalNotification;



@end

@implementation EZTestSuite



//The entrance it here. 
//So I just comments it out. Will not execute any test cases
+ (void) testSchedule
{
    //
    //[EZTestSuite testArrayContainAndStringEqual];
   //[EZTestSuite innerTestAll];
    //[EZTestSuite cleanAllLocalNotification];
    [EZTestSuite testArrayExchange];
    [EZTestSuite testAvDayCascadeStore];
    [EZTestSuite testTaskGroupCascade];
    //[EZTestSuite cleanOrphanTask];
    [EZCoreAccessor setInstance:nil];
    
}


+ (void) innerTestAll
{
    [EZTestSuite initializeDB];
    
    [EZTestSuite testComprehansiveCase];
    //[EZTestSuite testMainCase];
    //[EZTestSuite testTaskStore];
    [EZTestSuite testTaskFetch];
    [EZTestSuite testAvailableTime];
    [EZTestSuite testAvailableTimeMatchWeekAndDay];
    [EZTestSuite testTaskPick];
    [EZTestSuite testExclusive];
    [EZTestSuite testTestData];
    [EZTestSuite testQuotasTask];
    [EZTestSuite testQuotasWithHistory];
    [EZTestSuite testIndexPath];
    [EZTestSuite testTimeIntervelSinceNow];
    [EZTestSuite testMethodAsProperty];
    //[EZTestSuite testBlockMemory];
    [EZTestSuite testSimpleData];
    [EZTestSuite testTimePassed];
    [EZTestSuite testTimeSort];
    [EZTestSuite testInBetween];
    [EZTestSuite testTrim];
    [EZTestSuite testI18N];
    [EZTestSuite testCascadeDelete];
    [EZTestSuite testStoreSideEffect];
    [EZTestSuite testPrimeSeries];
    [EZTestSuite testMemorySet];
    [EZTestSuite testMemoryCopy];
    [EZTestSuite testArrayFilter];
    [EZTestSuite testAvTimeRelationship];
    [EZTestSuite testEZQuotasProperty];
    [EZTestSuite testCellCreatorSingleton];
    [EZTestSuite testClosure];
    [EZTestSuite testAvailableTimeFilter];
    [EZTestSuite testRescheduleFilter];
    [EZTestSuite testRescheduleAll];
    [EZTestSuite testInterToHex];
    //[EZTestSuite testQuotasEffective];
    [EZTestSuite testGetPaddingDay];
    [EZTestSuite testCalcHistoryTime];
    [EZTestSuite testCalcHistoryTimeWithPadding];
    [EZTestSuite testNumberOutput];
    [EZTestSuite testNSMutableArray];
    [EZTestSuite testPredicate];
    [EZTestSuite testFetchWithPredicate];
    [EZTestSuite testBooleanAccessor];
    [EZTestSuite testPredicateForScheduledDay];
    [EZTestSuite testLRUMap];
    //Clear all the test data.
    //In the future what should I do with this.
    //Seems in this case, we need the test case ready
    //If it involve the test data cleanup.
    //[[EZTaskStore getInstance] clean];
    
    //Make sure the application don't use 
    //Test database.
    
    
}

+ (BOOL) isTaskExist:(EZTask*)tk inList:(NSArray*)tkList
{
    for(EZTask* task in tkList){
        if([task.PO.objectID isEqual:tk.PO.objectID]){
            return true;
        }
    }
    return false;
}

+ (void) cleanOrphanTask
{
    NSArray* groups = [[EZTaskStore getInstance] fetchAllWithVO:[EZTaskGroup class] PO:[MTaskGroup class] sortField:nil];
    
    NSMutableArray* tasks =[NSMutableArray arrayWithArray:[[EZTaskStore getInstance] fetchAllWithVO:[EZTask class] PO:[MTask class] sortField:nil]];
    
    NSMutableArray* taskInGroups = [[NSMutableArray alloc] initWithCapacity:tasks.count];
    for(EZTaskGroup* tg in groups){
        [taskInGroups addObjectsFromArray:tg.tasks];
    }
    
    EZDEBUG(@"Test in group:%i, total tasks:%i",taskInGroups.count, tasks.count);
    NSMutableArray* remove = [[NSMutableArray alloc] init];
    for(int i = 0; i < tasks.count; i++){
        EZTask* cTask = [tasks objectAtIndex:i];
        if(![EZTestSuite isTaskExist:cTask inList:taskInGroups]){
            [remove addObject:cTask];
            EZDEBUG(@"Found orphan:%@",cTask.name);
        }
    }
    EZDEBUG(@"Total orphan is:%i", remove.count);
    if(remove.count > 0){
        [[EZTaskStore getInstance] removeObjects:remove];
        [EZTestSuite cleanOrphanTask];
    }
    //assert(false);
    
}

+ (void) cleanAllLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    EZDEBUG(@"All local notification get called");
    assert(false);
}


//The first time must be ok, why?
//Because I can fill test data into the database. 
//Things maybe happened with the second time
//Let's verify it
+ (void) testAvDayCascadeStore
{
    [EZTestSuite initializeDB];
    EZAvailableDay* avDay = [[EZAvailableDay alloc] initWithName:@"TestDay" weeks:2];
    EZAvailableTime* avTime1 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"07:00"] name:@"Daily practice" duration:90 environment:EZ_ENV_FITTING];
    
    EZAvailableTime* avTime2 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"10:30"] name:@"Morning flow" duration:120 environment:EZ_ENV_FLOWING];
    [avDay.availableTimes addObject:avTime1];
    [avDay.availableTimes addObject:avTime2];
    [[EZTaskStore getInstance] storeObject:avDay];
    
    NSArray* res = [[EZTaskStore getInstance]fetchAllWithVO:[EZAvailableDay class] PO:[MAvailableDay class] sortField:nil];
    assert(res.count == 1);
    
    EZAvailableDay* avDayRes = res.lastObject;
    
    assert(avDayRes.availableTimes.count == 2);
    
    EZAvailableTime* avTime3 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"14:30"] name:@"Afternoon flow" duration:240 environment:EZ_ENV_FLOWING];
    [avDay.availableTimes addObject:avTime3];
    [[EZTaskStore getInstance] storeObject:avDay];
    
    res = [[EZTaskStore getInstance] fetchAllWithVO:[EZAvailableDay class] PO:[MAvailableDay class] sortField:nil];
    avDayRes = res.lastObject;
    
    assert(avDayRes.availableTimes.count == 3);
    
    [avDayRes.availableTimes removeObjectAtIndex:2];
    [[EZTaskStore getInstance] storeObject:avDayRes];
    
    res = [[EZTaskStore getInstance] fetchAllWithVO:[EZAvailableDay class] PO:[MAvailableDay class] sortField:nil];
    avDayRes = res.lastObject;
    assert(avDayRes.availableTimes.count == 2);
    
    
    
    
    
    res = [[EZTaskStore getInstance] fetchAllWithVO:[EZAvailableTime class] PO:[MAvailableTime class] sortField:nil];
    EZDEBUG(@"res count:%i", res.count);
    assert(res.count == 3);
    
    EZAvailableTime* avTimeRes = avDayRes.availableTimes.lastObject;
    EZDEBUG(@"time name:%@",avTimeRes.name);
    [[EZTaskStore getInstance] removeObject:avTimeRes];
    EZDEBUG(@"after remove");
    
    EZAvailableDay* avDayUpdated = [[EZTaskStore getInstance]fetchAllWithVO:[EZAvailableDay class] PO:[MAvailableDay class] sortField:nil].lastObject;
    EZDEBUG(@"get updated");
    assert(avDayUpdated.availableTimes.count == 1);
    
    EZDEBUG(@"Before refresh, count:%i", avDayRes.availableTimes.count);
    [avDayRes refresh];
    EZDEBUG(@"After refresh, count:%i", avDayRes.availableTimes.count);
    assert(avDayRes.availableTimes.count == 1);
    
    
    
    [[EZTaskStore getInstance] removeObject:avDayRes];
    res = [[EZTaskStore getInstance] fetchAllWithVO:[EZAvailableDay class] PO:[MAvailableDay class] sortField:nil];
    assert(res.count == 0);
    
    res = [[EZTaskStore getInstance] fetchAllWithVO:[EZAvailableTime class] PO:[MAvailableTime class] sortField:nil];
    
    //Remove parent, will not get child removed?
    //Didn't I get the cascade setting write?
    //Mean the cascade deletion is work. 
    //But we have a availableTime left in previous disband operation.
    //So, 1 have been removed with the availableDay.
    assert(res.count == 1);
    //assert(false);
    
    
}

+ (void) testTaskGroupCascade
{
    [EZTestSuite initializeDB];
    EZTaskGroup* group = [[EZTaskGroup alloc] init];
    group.name = @"Test Group";
    EZTask* task1 = [[EZTask alloc] initWithName:@"iOS coding"];
    EZTask* task2 = [[EZTask alloc] initWithName:@"Lisp study"];
    [group.tasks addObjectsFromArray:[NSArray arrayWithObjects:task1, task2, nil]];
    [[EZTaskStore getInstance] storeObject:group];
    EZTaskGroup* resGroup = [[EZTaskStore getInstance] fetchAllWithVO:[EZTaskGroup class] PO:[MTaskGroup class] sortField:nil].lastObject;
    assert(resGroup.tasks.count == 2);
    [resGroup.tasks removeObjectAtIndex:1];
    [[EZTaskStore getInstance] storeObject:resGroup];
    resGroup = [[EZTaskStore getInstance] fetchAllWithVO:[EZTaskGroup class] PO:[MTaskGroup class] sortField:nil].lastObject;
    assert(resGroup.tasks.count == 1);
    
    
    EZDEBUG(@"Before refresh");
    [group refresh];
    EZDEBUG(@"After refresh:%i",group.tasks.count);
    assert(group.tasks.count == 1);
    
    EZTask* task3 = [[EZTask alloc] initWithName:@"Feynman reading"];
    [group.tasks addObject:task3];
    [[EZTaskStore getInstance] storeObject:group];
    
    [resGroup refresh];
    assert(resGroup.tasks.count == 2);
    
    NSArray* allTasks = [[EZTaskStore getInstance] fetchAllWithVO:[EZTask class] PO:[MTask class] sortField:nil];
    assert(allTasks.count == 3);
    [[EZTaskStore getInstance]removeObject:resGroup];
    
    allTasks = [[EZTaskStore getInstance] fetchAllWithVO:[EZTask class] PO:[MTask class] sortField:nil];
    assert(allTasks.count == 1);
    //assert(false);
}


+ (void) testArrayExchange
{
    NSMutableArray* arr = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", nil];
    [arr exchangeObjectAtIndex:0 withObjectAtIndex:2];
    assert([@"3" isEqualToString:[arr objectAtIndex:0]]);
    assert([@"1" isEqualToString:[arr objectAtIndex:2]]);
   //assert(false);
}

+ (void) testLRUMap
{
    EZLRUMap* lruMap = [[EZLRUMap alloc] initWithLimit:4];
    [lruMap setObject:@"1" forKey:@"1"];
    [lruMap setObject:@"2" forKey:@"2"];
    [lruMap setObject:@"3" forKey:@"3"];
    [lruMap setObject:@"4" forKey:@"4"];
    assert([@"1" isEqualToString:[lruMap setObject:@"5" forKey:@"5"]]);
    
    [lruMap getObjectForKey:@"2"];
    assert([@"3" isEqualToString:[lruMap setObject:@"6" forKey:@"6"]]);
    
    [lruMap getObjectForKey:@"4"];
    assert([@"5" isEqualToString:[lruMap setObject:@"7" forKey:@"7"]]);
    
    
    //assert(false);
}

+ (void) testPredicateForScheduledDay
{
    [EZTestSuite initializeDB];
    EZScheduledDay* ed = [[EZScheduledDay alloc] init];
    ed.scheduledDate = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120623"];
    EZScheduledDay* ed1 = [[EZScheduledDay alloc] init];
    ed1.scheduledDate = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120624"];
    EZScheduledDay* ed2 = [[EZScheduledDay alloc] init];
    ed2.scheduledDate = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120625"];
    [[EZTaskStore getInstance] storeObjects:[NSArray arrayWithObjects:ed1, ed, ed2, nil]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"scheduledDate < %@",ed2.scheduledDate];
    NSArray* result = [[EZTaskStore getInstance] fetchWithPredication:predicate VO:[EZScheduledDay class] PO:[MScheduledDay class] sortField:@"scheduledDate"];
    EZDEBUG(@"Result length:%i", result.count);
    assert(result.count == 2);
    
    EZScheduledDay* res1 = [result objectAtIndex:0];
    EZScheduledDay* res2 = [result objectAtIndex:1];
    assert([res1.scheduledDate isEqualToDate:ed.scheduledDate]);
    assert([res2.scheduledDate isEqualToDate:ed1.scheduledDate]);
    
    //assert(false);
    
}

+ (void) testArrayContainAndStringEqual
{
    NSString* str1 = [NSString stringWithFormat:@"str%i",1];
    NSString* str2 = [NSString stringWithFormat:@"str%i",2];
    NSArray* arr = [NSArray arrayWithObjects:str1, str2, nil];
    NSString* found = [NSString stringWithFormat:@"str%i",1];
    assert([arr containsObject:found]);
    assert([str1 isEqual:found]);
    
    assert(((int)str1) != ((int)found));
    
    ComparedObject* obj1 = [[ComparedObject alloc] init];
    obj1.name = str1;
    obj1.age = 35;
    ComparedObject* obj2 = [[ComparedObject alloc] init];
    obj2.name = found;
    obj2.age = 35;
    assert(![obj1 isEqual:obj2]);
    
    NSArray* arr2 = [NSArray arrayWithObjects:obj1,nil];
    assert([arr2 containsObject:obj1]);
    assert(![arr2 containsObject:obj2]);
    
    
    ComparedObjectEx* obje1 = [[ComparedObjectEx alloc] init];
    obje1.name = str1;
    obje1.age = 35;
    ComparedObjectEx* obje2 = [[ComparedObjectEx alloc] init];
    obje2.name = found;
    obje2.age = 35;
    assert([obje1 isEqual:obje2]);
    
    NSArray* arre2 = [NSArray arrayWithObjects:obje1,nil];
    assert([arre2 containsObject:obje1]);
    assert([arre2 containsObject:obje2]);
    
    assert(false);
    //assert(false);
    
}

+ (void) testBooleanAccessor
{
    IntCarrier* ic = [[IntCarrier alloc] init];
    ic.animated = true;
    assert(!ic.animated);
}

+ (void) testFetchWithPredicate
{
    [EZTestSuite initializeDB];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name like %@",@"Tian"];
    EZTask* task1 = [[EZTask alloc] initWithName:@"Tian" duration:20 maxDur:40 envTraits:2];
    EZTask* task2 = [[EZTask alloc] initWithName:@"Tian1" duration:21 maxDur:45 envTraits:3];
    
    EZTask* task3 = [[EZTask alloc] initWithName:@"TianFinal" duration:2 maxDur:42 envTraits:3];
    
    [[EZTaskStore getInstance] storeObjects:[NSArray arrayWithObjects:task1, task2, task3, nil]];
    NSArray* arr = [[EZCoreAccessor getInstance] fetchObject:[MTask class] byPredicate:predicate withSortField:nil];
    assert(arr.count == 1);
    
    arr = [[EZCoreAccessor getInstance] fetchObject:[MTask class] byPredicate:nil withSortField:@"duration"];
    assert(arr.count == 3);
    MTask* mt = [arr objectAtIndex:0];
    assert(mt.duration.intValue == 2);
    
    arr = [[EZCoreAccessor getInstance] fetchObject:[MTask class] byPredicate:nil withSortField:@"maxDuration"];
    assert(arr.count == 3);
    mt = [arr objectAtIndex:0];
    assert(mt.maxDuration.intValue == 40);

    
    //assert(false);
     
    
}

+ (void) testPredicate
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name like %@",@"Tian"];
    
    EZTask* task1 = [[EZTask alloc] initWithName:@"Tian" duration:20 maxDur:40 envTraits:2];
    EZTask* task2 = [[EZTask alloc] initWithName:@"Tian1" duration:21 maxDur:41 envTraits:3];
    NSArray* arr = [NSArray arrayWithObjects:task1, task2, nil];
    NSArray* filterResult = [arr filteredArrayUsingPredicate:predicate];
    EZDEBUG(@"Result is %i",filterResult.count);
    assert(filterResult.count == 1);
    
    predicate = [NSPredicate predicateWithFormat:@"duration > %i",20];
    
    filterResult = [arr filteredArrayUsingPredicate:predicate];
    EZDEBUG(@"Result is %i",filterResult.count);
    assert(filterResult.count == 1);
    EZTask* resTK = [filterResult objectAtIndex:0];
    assert(resTK.duration == 21);
    
    predicate = [NSPredicate predicateWithFormat:@"(duration > %i) AND (envTraits == %i)", 20, 2];
    
    filterResult = [arr filteredArrayUsingPredicate:predicate];
    assert(filterResult.count == 0);
    
    predicate = [NSPredicate predicateWithFormat:@"(duration > %i) AND (envTraits == %i)", 20, 3];
    
    filterResult = [arr filteredArrayUsingPredicate:predicate];
    assert(filterResult.count == 1);
    resTK = [filterResult objectAtIndex:0];
    assert((resTK.duration == 21) && (resTK.envTraits == 3));
    
    EZScheduledTask* schTask1 = [[EZScheduledTask alloc] init];
    schTask1.startTime = [NSDate stringToDate:@"yyyyMMdd:HH" dateString:@"20120622:15"];
    schTask1.task = task1;
    
    EZScheduledTask* schTask2 = [[EZScheduledTask alloc] init];
    schTask2.startTime = [NSDate stringToDate:@"yyyyMMdd:HH" dateString:@"20120622:08"];
    schTask2.task = task2;
    
    NSArray* schTasks = [NSArray arrayWithObjects:schTask1,schTask2, nil];
    predicate = [NSPredicate predicateWithFormat:@"task.name like[c] %@", @"TIAN"];
    filterResult = [schTasks filteredArrayUsingPredicate:predicate];
    assert(filterResult.count == 1);
    EZScheduledTask* scTK = [filterResult objectAtIndex:0];
    assert(scTK.task == task1);
    
    predicate = [NSPredicate predicateWithFormat:@"startTime > %@", [NSDate stringToDate:@"yyyyMMdd:HH" dateString:@"20120622:10"]];
    filterResult = [schTasks filteredArrayUsingPredicate:predicate];
    assert(filterResult.count == 1);
    scTK = [filterResult objectAtIndex:0];
    assert(scTK == schTask1);
    
    
    //assert(false);
    
}   

+ (void) testNSMutableArray
{
    NSString* str1 = @"1";
    NSString* str2 = @"2";
    NSMutableArray* arr = [[NSMutableArray alloc] initWithObjects:str1, str2, nil];
    
    assert(arr.count == 2);
    [arr removeObject:str2];
    assert(arr.count == 1);
    NSInteger pos = [arr indexOfObject:str1];
    assert(pos == 0);
    pos = [arr indexOfObject:str2];
    //[arr containsObject:
    EZDEBUG(@"Position for not exist:%i", pos);
    
    assert(pos > [arr count]);

    //assert(false);
    
}

+ (void) testObjectIDSerialize
{
    [EZTestSuite initializeDB];
    EZTask* task = [[EZTask alloc] initWithName:@"TestID"];
    [[EZTaskStore getInstance]storeObject:task];
    
    
}

//The purpose of this test is to make sure the number output is correct
+ (void) testNumberOutput
{
    NSString* outPut = [NSString stringWithFormat:@"%2d",123456];
    EZDEBUG(@"Output:%@", outPut);
    //assert([@"01" isEqualToString:outPut]);
    
}
//Follow the principle. Do NOT even copy myself.
//Fully grasp my code and my logic
//What's the purpose my this test.
//Make sure the calculate the history behave as I expected with the 
//Quotas have Padding date.
//Set the cycle start date 2 days behind the cycle nature start date.
//So the the system will add paddingDay*avg days into the history time. 
//Let's verify this is the cases
+ (void) testCalcHistoryTimeWithPadding
{
    [EZTestSuite initializeDB];
    EZTask* iOSTask = [[EZTask alloc] initWithName:@"iOS" duration:4 maxDur:10 envTraits:2];
    EZQuotas* quotas = [[EZQuotas alloc] init:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120619"] quotas:70 type:WeekCycle cycleStartDate:nil cycleLength:7];
    iOSTask.quotas = quotas;
    [[EZTaskStore getInstance] storeObject:iOSTask];
    EZScheduledTask* task1 = [[EZScheduledTask alloc] init];
    task1.duration = 13;
    task1.startTime = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120619"];
    task1.task = iOSTask;
    EZScheduledTask* task2 = [[EZScheduledTask alloc] init];
    task2.duration = 14;
    task2.startTime = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120620"];
    task2.task = iOSTask;
    [[EZTaskStore getInstance] storeObjects:[NSArray arrayWithObjects:task1, task2, nil]];
    
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    
    int histTime = [scheduler calcHistoryTime:iOSTask date:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120621"]];
    
    EZDEBUG(@"expected:47, actual:%i",histTime);
    assert(histTime == 47);
    
    EZAvailableDay* avDay = [[EZAvailableDay alloc] initWithName:@"AvDay" weeks:ALLDAYS];
    EZAvailableTime* avTime = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"10:30"] name:@"work" duration:10 environment:2];
    [avDay.availableTimes addObject:avTime];
    [[EZTaskStore getInstance] storeObject:avDay];
    
    NSArray* schTasks = [scheduler scheduleTaskByDate:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120621"] exclusiveList:nil];
    assert(schTasks.count == 1);
    EZScheduledTask* st = [schTasks objectAtIndex:0];
    EZDEBUG(@"duration:%i, assignedTime:%@",st.duration, [st.startTime stringWithFormat:@"yyyyMMdd HH:mm"]);
    assert(st.duration == 7);
    
    //assert(false);
    
}

//First Let's try the simplest case.
//No padding day will be involved.
//Have all the environment under control including the Time.
+ (void) testCalcHistoryTime
{
    [EZTestSuite initializeDB];
    NSDate* startTime = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120617"];
    EZTask* iOSTask = [[EZTask alloc] initWithName:@"IOSTask"];
        
    EZQuotas* quotas = [[EZQuotas alloc] init:startTime quotas:100 type:WeekCycle cycleStartDate:startTime cycleLength:7];
    iOSTask.quotas = quotas;
    [[EZTaskStore getInstance] storeObject:iOSTask];
        
    EZScheduledTask* task1 = [[EZScheduledTask alloc] init];
    task1.task = iOSTask;
    task1.startTime = startTime;
    task1.duration = 10;
    
    [[EZTaskStore getInstance] storeObject:task1];
    
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    NSDate* day1 = [startTime adjustDays:1];
    
    int historyTime = [scheduler calcHistoryTime:iOSTask date:day1];
    assert(historyTime == task1.duration);
    
    EZScheduledTask* task2 = [[EZScheduledTask alloc] init];
    task2.task = iOSTask;
    task2.startTime = day1;
    task2.duration = 20;
    
    [[EZTaskStore getInstance] storeObject:task2];
    NSDate* day2 = [startTime adjustDays:2];
    historyTime = [scheduler calcHistoryTime:iOSTask date:day2];
    assert(historyTime == (task1.duration + task2.duration));
    
    
}
//It is strange for important functionality as 
//This, I don't even have test cases to cover it. 
//This is the right time to get things straight.

+ (void) testGetPaddingDay
{
    EZQuotas* quotas = [[EZQuotas alloc] init:[NSDate date] quotas:100 type:WeekCycle cycleStartDate:[NSDate date] cycleLength:8];
    
    
    EZCycleResult* result = [EZTaskHelper calcHistoryBegin:quotas date:[NSDate date]];
    //assert(result.paddingDays == 2);
    assert([result.beginDate equalWith:[NSDate date] format:@"yyyyMMdd"]);
    
    
    quotas = [[EZQuotas alloc] init:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120620"] quotas:100 type:CustomizedCycle cycleStartDate:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120601"] cycleLength:10];
    result = [EZTaskHelper calcHistoryBegin:quotas date:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120620"]];
    assert(result.paddingDays == 9);
    assert([result.beginDate equalWith:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120620"] format:@"yyyyMMdd"]);
    
    
    quotas = [[EZQuotas alloc] init:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120618"] quotas:100 type:CustomizedCycle cycleStartDate:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120601"] cycleLength:10];
    
    result = [EZTaskHelper calcHistoryBegin:quotas date:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120622"]];
    assert(result.paddingDays == 0);
    assert([result.beginDate equalWith:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120621"] format:@"yyyyMMdd"]);
    EZDEBUG(@"beginDate:%@",[result.beginDate stringWithFormat:@"yyyyMMdd"]);
   
    quotas = [[EZQuotas alloc] init:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120601"] quotas:100 type:CustomizedCycle cycleStartDate:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120601"] cycleLength:10];
    
    result = [EZTaskHelper calcHistoryBegin:quotas date:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120601"]];
    //assert(result.paddingDays == 0);
    
    EZDEBUG(@"beginDate:%@",[result.beginDate stringWithFormat:@"yyyyMMdd"]);   

    
    // assert([result.beginDate equalWith:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120621"] format:@"yyyyMMdd"]);
    NSDate* toDay = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120601"];
    int gapDays = 0;
    
    assert([[toDay adjustDays:-gapDays] equalWith:toDay format:@"yyyyMMdd"]);
    
    //assert(false);
}

// Create a normal test cases
// What do you mean by normal.
// I have 3 tasks, 1 time period, it can be used by all 3 tasks,
// I have 1 task with quotas.
// Let's allocate the task from the cycle start until the end of the cycle. 
// Check the what's the amount I allocated on daily basis. 
// See if it meet my assumption or not.

// Let's remove some history and start in the middle of the cycle,
// The purpose of this test is that, The Allocated time should increase, as the time is urgent and not enough have completed. 
// Make use of the daily maximum. 
// If not set, I will use the 6 hour maximum as default. 
// This value should go with the EZQuotas.

// Should I show a warning sign to user when we don't have enough time for the quotas? 
//When to show warning sign?
//If have no enough avTime to allocate for today's quotas
//Or today's quotas have reach the daily maximum.

// Is there any reason, we allow user to allocate task for tomorrow or the day after tomorrow?
// We should, How to we calculate the Quotas?
// Can we just treat it as today?
// Should we use today's assignment as history?
// As long as things not happened, It will not be used as history. 
// Only based on really history. 
// This is make sense to me. 

//One thing come into my mind, what if the daily time allocation is not the same.
//How to calculate the quotas?
//The same right?
//I am worry about how I am going to know that there is not enough time left.
//It is easy. 
//Following is the process to make sure whether we have enough time left or not.
//From now to the end of the cyle, get amount of suitable time for this task.
//Check the remaining amount see if we have enough amount left.
//What if more tasks competing for this time snippet resource. 
//What should I do?
// Or what is the user's expectation?
// This is linear formula.

//Why not 2 tasks. Let's go ahead make it run
+ (void) testQuotasEffective
{
    [EZTestSuite initializeDB];
    EZTask* taskBook = [[EZTask alloc] initWithName:@"Gandhi" duration:30 maxDur:50 envTraits:2];
     EZTask* taskBook2 = [[EZTask alloc] initWithName:@"Martine Ruther" duration:30 maxDur:50 envTraits:2];
    
    EZTask* taskiOS = [[EZTask alloc] initWithName:@"iOS" duration:60 maxDur:90 envTraits:3];
    NSDate* startDate = [NSDate date];
    
    EZQuotas* quotas = [[EZQuotas alloc] init:startDate quotas:1200 type:WeekCycle cycleStartDate:startDate cycleLength:7];
    taskiOS.quotas = quotas;
    [[EZTaskStore getInstance] storeObjects:[NSArray arrayWithObjects:taskBook, taskBook2, taskiOS, nil]];
    
    EZAvailableDay* avDay = [[EZAvailableDay alloc] initWithName:@"Default" weeks:ALLDAYS];
    
    EZAvailableTime* avTime = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"19:30"] name:@"HardWork" duration:240 environment:2*3];
    [avDay.availableTimes addObject:avTime];
    [[EZTaskStore getInstance] storeObject:avDay];
    
    NSArray* existSchTasks = [[EZTaskStore getInstance] fetchAllWithVO:[EZScheduledTask class] PO:[MScheduledTask class] sortField:@"startTime"];
    assert(existSchTasks.count == 0);
    
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    NSDate* date = [NSDate date];
    NSMutableArray* allTasks = [[NSMutableArray alloc] init];
    NSMutableArray* flatedTasks = [[NSMutableArray alloc] init];
    for(int i = 0; i < 3; ++i){
        NSDate* schDate = [date adjustDays:i];
        NSArray* schTasks = [scheduler scheduleTaskByDate:schDate exclusiveList:nil];
        [[EZTaskStore getInstance] storeObjects:schTasks];
        [allTasks addObject:schTasks];
        [flatedTasks addObjectsFromArray:schTasks];
    }
    existSchTasks = [[EZTaskStore getInstance] fetchAllWithVO:[EZScheduledTask class] PO:[MScheduledTask class] sortField:@"startTime"];
    assert(existSchTasks.count > 0);
    
    
    NSDate* allocDate = [date adjustDays:3];
    
    assert(taskiOS.PO != nil);
    
    int history = [scheduler calcHistoryTime:taskiOS date:allocDate];
    
    int pureDuration = [[EZTaskStore getInstance] getTaskTime:taskiOS start:[NSDate date] end:allocDate];
    
    NSArray* schTasks = [scheduler scheduleTaskByDate:allocDate exclusiveList:nil];
    EZScheduledTask* iosSchTask = nil;
    for(EZScheduledTask* scTask in schTasks){
        if([scTask.task.name isEqualToString:taskiOS.name]){
            iosSchTask = scTask;
            break;
        }
    }
    [[EZTaskStore getInstance] storeObjects:schTasks];
    assert(iosSchTask != nil);
    assert(iosSchTask.duration > 0);
    
    int updatedPureDuration = [[EZTaskStore getInstance] getTaskTime:taskiOS start:[NSDate date] end:[allocDate adjustDays:1]];
    EZDEBUG(@"duration:%i, updatedDuration:%i", pureDuration, updatedPureDuration);
    
    int newHistory = [scheduler calcHistoryTime:taskiOS date:[allocDate adjustDays:2]];
    EZDEBUG(@"newHistory:%i, history:%i, duration:%i, model duration:%i",newHistory, history, iosSchTask.duration, iosSchTask.PO.duration.integerValue);
    
    //Let's shake it a little bit.
    [[EZTaskStore getInstance] removeObject:iosSchTask];
    int deleteHistory = [scheduler calcHistoryTime:taskiOS date:[allocDate adjustDays:2]];
    EZDEBUG(@"After delete the history is:%i",deleteHistory);
    
    
    assert(newHistory == (iosSchTask.duration + history));
    
    
    
    //The reason I do this because there is a lot of unnecessary logs
    //Which burried real information, Let's get them quit before lunch
    for(int i = 0; i < 6; ++i){
        NSDate* schDate = [date adjustDays:i];
        EZDEBUG(@"For date:%@", [schDate stringWithFormat:@"yyyyMMdd"]);
        NSArray* schTks = [allTasks objectAtIndex:i];
        for(EZScheduledTask* scTask in schTks){
            EZDEBUG(@"TaskName:%@, duration:%i", scTask.task.name, scTask.duration);
        }
        
    }
    
    
    assert(false);
    
}

+ (void) testInterToHex
{
    NSInteger value = 160;
    NSString* hexStr = [NSString stringWithFormat:@"%X",value];
    NSString* hexSmall = [NSString stringWithFormat:@"%x",value];
    EZDEBUG(@"Converted is:%@, small x is:%@",hexStr, hexSmall);
    assert([@"A0" isEqualToString:hexStr]);
    NSInteger backVal = hexStr.intValue;
    EZDEBUG(@"Back value:%i",backVal);
    //assert(value == backVal);
    //NSNumber* num = [[NSNumber alloc] initWithInt:10];
    NSInteger result =  strtoul([hexStr cStringUsingEncoding:NSASCIIStringEncoding], 0, 16);
    
    CGFloat divVal = 1/5.0;
    assert((divVal > 0.19) && (divVal < 0.21));
    //assert(divVal == 0.2);
    assert(result == value);
    
    UIColor* color = [UIColor createByHex:@"FFFFFF"];
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    assert([color getRed:&red green:&green blue:&blue alpha:&alpha]);
    
    int redInt = 255*red;
    int greenInt = 255*green;
    int blueInt = 255*blue;
    
    EZDEBUG(@"Red:%f, Green:%f, Blue:%f, alpha:%f: Red:%X,Green:%X,Blue:%X",red, green, blue, alpha, redInt, greenInt, blueInt);
    
    NSString* resultStr = color.toHexString;
    EZDEBUG(@"Result string is %@",resultStr);
    //assert([@"FFFFFF" isEqualToString:resultStr]);
    
    color = [UIColor createByHex:@"CCC"];
    resultStr = color.toHexString;
    EZDEBUG(@"Half result is %@",resultStr);
    assert([@"CCCCCC" isEqualToString:resultStr]);
    
    color = [UIColor createByHex:@"ABCDEF"];
    resultStr = color.toHexString;
    assert([@"ABCDEF" isEqualToString:resultStr]);
    
}

+ (void) testRescheduleAll
{
    [EZTestSuite initializeDB];
    EZTask* task1 = [[EZTask alloc] initWithName:@"Taiji" duration:30 maxDur:30 envTraits:2];
    EZTask* task2 = [[EZTask alloc] initWithName:@"iOS" duration:40 maxDur:40 envTraits:2];
    EZTask* task3 = [[EZTask alloc] initWithName:@"Martial arts" duration:50 maxDur:50 envTraits:2];
    [[EZTaskStore getInstance] storeObjects:[NSArray arrayWithObjects:task1, task2, task3, nil]];
    EZAvailableTime* avTime1 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"07:00"] name:@"morning" duration:50 environment:2];
    
    EZAvailableTime* avTime2 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"14:00"] name:@"afternoon" duration:50 environment:2];
    
    EZAvailableDay* avDay = [[EZAvailableDay alloc] initWithName:@"All day" weeks:ALLDAYS];
    [avDay.availableTimes addObjectsFromArray:[NSArray arrayWithObjects:avTime1, avTime2, nil]];
    [[EZTaskStore getInstance] storeObject:avDay];
    
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    NSArray* schTasks = [scheduler scheduleTaskByDate:[NSDate stringToDate:@"yyyyMMdd-HH:mm" dateString:@"20120614-06:00"] exclusiveList:nil];
    
    [schTasks iterate:^(EZScheduledTask* task){
        EZDEBUG(@"first round:%@",task.detail);
    }];
    
    EZScheduledTask* firstSchTask1 = [schTasks objectAtIndex:0];
    EZScheduledTask* firstSchTask2 = [schTasks objectAtIndex:1];
    
    
    assert(schTasks.count == 2);
    
    EZTask* scTask1 = ((EZScheduledTask*)[schTasks objectAtIndex:1]).task;
    [[EZTaskStore getInstance] removeObject:scTask1];
    
    NSArray* schTasks2 = [scheduler rescheduleAll:schTasks date:[NSDate stringToDate:@"yyyyMMdd-HH:mm" dateString:@"20120614-10:00"]];
    assert(schTasks2.count == 2);
    [schTasks2 iterate:^(EZScheduledTask* task){
        EZDEBUG(@"second round:%@",task.detail);
    }];
    
    EZScheduledTask* secondSchTask1 = [schTasks2 objectAtIndex:0];
    EZScheduledTask* secondSchTask2 = [schTasks2 objectAtIndex:1];

    assert(firstSchTask1.task.duration == secondSchTask1.task.duration);
    assert(firstSchTask2.task.duration != secondSchTask2.task.duration);

}

+ (void) testRescheduleFilter
{
    EZScheduledTask* task1 = [[EZScheduledTask alloc] init];
    task1.duration = 20;
    task1.startTime = [NSDate stringToDate:@"yyyyMMdd-HH:mm" dateString:@"20120614-12:10"];
    
    EZScheduledTask* task2 = [[EZScheduledTask alloc] init];
    task2.duration = 80;
    task2.startTime = [NSDate stringToDate:@"yyyyMMdd-HH:mm" dateString:@"20120614-13:10"];
    
    EZScheduledTask* task3 = [[EZScheduledTask alloc] init];
    task3.duration = 100;
    task3.startTime = [NSDate stringToDate:@"yyyyMMdd-HH:mm" dateString:@"20120614-15:10"];
    
    NSArray* schTasks = [NSArray arrayWithObjects:task1, task2, task3, nil];
    
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    NSDate* currentDate = [NSDate stringToDate:@"yyyyMMdd-HH:mm" dateString:@"20120614-13:30"];
    
    
    ScheduledFilterResult* sfr = [scheduler filterTask:schTasks date:currentDate];
    assert(sfr.remainingTasks.count == 2);
    assert(sfr.removedTasks.count == 1);
    assert([@"20120614-14:30" isEqualToString:[sfr.adjustedDate stringWithFormat:@"yyyyMMdd-HH:mm"]]);
    EZScheduledTask* removed = [sfr.removedTasks objectAtIndex:0];
    assert(removed.duration == 100);
    
}

+ (void) testAvailableTimeFilter
{
    EZAvailableDay* avDay = [[EZAvailableDay alloc] initWithName:@"Coolest Day" weeks:1];
    EZAvailableTime* time1 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"11:40"] name:@"Morning" duration:20 environment:3];
    EZAvailableTime* time2 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"12:40"] name:@"Noon" duration:80 environment:5];
    EZAvailableTime* time3 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"15:40"] name:@"Afternoon" duration:120 environment:7];
    
    [avDay.availableTimes addObjectsFromArray:[NSArray arrayWithObjects:time1,time2,time3, nil]];
    
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    EZAvailableDay* convertDay = [scheduler filterAvailebleDay:avDay byTime:[NSDate stringToDate:@"yyyyMMdd-HH:mm" dateString:@"19770611-12:50"]];
    
    assert(convertDay.availableTimes.count == 2);
    
    EZAvailableTime* resTime1 = [convertDay.availableTimes objectAtIndex:0];
    EZAvailableTime* resTime2 = [convertDay.availableTimes objectAtIndex:1];
    assert(resTime1.duration == 70);
    assert([@"12:50" isEqualToString:[resTime1.start stringWithFormat:@"HH:mm"]]);
    
    assert(resTime2.duration == 120);
    
    
}

//The purpose of this test is to make sure once the closure objet have been created the change of the scene will not affect the closure object. 

+ (void) testClosure
{
    IntCarrier* car1 = [[IntCarrier alloc] init];
    car1.value = 1;
    
    IntCarrier* car2 = [[IntCarrier alloc] init];
    car2.value = 2;
    
    ClosureTest block = ^(){
        return car1.value;
    };
    car1 = car2;
    assert(block() == 1);
}

+ (void) testCellCreatorSingleton
{
    EZEditLabelCellHolder* holder = [EZEditLabelCellHolder getInstance];
    EZEditLabelCellHolder* newHolder = [[EZEditLabelCellHolder alloc] init];
    
    assert(holder != newHolder);
    
    EZEditLabelCellHolder* olderHolder = [EZEditLabelCellHolder getInstance];
    assert(holder == olderHolder);
    
    EZScheduledCell* schCell = [EZEditLabelCellHolder createScheduledCell];
    assert(schCell != nil);
    
    EZScheduledCell* newCell = [EZEditLabelCellHolder createScheduledCell];
    assert(newCell != nil);
    
    assert(schCell != newCell);
    
}

+ (void) testEZQuotasProperty
{
    
    EZDEBUG(@"Local string:%@",Local(@"Happy"));
    EZQuotas* eq = [[EZQuotas alloc] init:[NSDate date] quotas:100 type:WeekCycle cycleStartDate:[NSDate date] cycleLength:14];
    
    assert(eq.cycleLength == 7);
    
    eq.cycleType = MonthCycle;
    assert(eq.cycleLength == 30);
    
    eq.cycleType = CustomizedCycle;
    assert(eq.cycleLength == 14);
    
}

+ (void) testAvTimeRelationship
{
    [EZTestSuite initializeDB];
    EZAvailableDay* day = [[EZAvailableDay alloc] initWithName:@"Test Day" weeks:1];
    EZAvailableTime* avTime = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HHmm" dateString:@"0630"] name:@"Meditation Period" duration:50 environment:2];
    [day.availableTimes addObject:avTime];
    [[EZTaskStore getInstance] storeObject:day];
    
    MAvailableDay* storedDay = [[[EZCoreAccessor getInstance] fetchAll:[MAvailableDay class] sortField:nil] objectAtIndex:0];
    assert(storedDay.availableTimes.count == 1);
    
    MAvailableTime* storedTime = [storedDay.availableTimes anyObject];
    assert([storedTime.avDay.name isEqualToString:day.name]);
    
    MAvailableTime* mTime = [[[EZCoreAccessor getInstance] fetchAll:[MAvailableTime class] sortField:nil] objectAtIndex:0];
    assert([mTime.avDay.name isEqualToString:day.name]);
}

+ (void) testArrayFilter
{
    NSArray* strArr = [NSArray arrayWithObjects:@"me",@"tian",@"me", nil];
    NSArray* filterResult = [strArr filter:^BOOL(id obj) {
        return [@"me" isEqualToString:obj];
    }];
    assert(filterResult.count == 2);
}

+ (void) testMemoryCopy
{
    NSUInteger* source = malloc(10*sizeof(NSUInteger));
    NSUInteger* target = malloc(10*sizeof(NSUInteger));
    
    for(int i = 1 ; i < 11;  ++i){
        target[i-1] = i;
        source[i-1] = 10+i;
    }
    
    memcpy(target, source, 10*sizeof(NSUInteger));
    
    //assert(target[9] == source[9]);
    
    for(int i = 0; i < 10; ++i){
        EZDEBUG(@"compare %i, target:%i, source:%i",i, source[i], target[i]);
        assert(target[i] == source[i]);
    }
    
    
    source = malloc(10*sizeof(NSUInteger));
    target = malloc(10*sizeof(NSUInteger));
    for(int i = 1 ; i < 11;  ++i){
        target[i-1] = i;
        source[i-1] = 10+i;
    }
    
    memcpy((void*)target,(void*)source, 10*4);
    
    for(int i = 0; i < 10; ++i){
        EZDEBUG(@"Second compare %i, target:%i, source:%i",i, source[i], target[i]);
        assert(target[i] == source[i]);
    }    
    
}

+ (void) testMemorySet
{
    EZDEBUG(@"Size of void* %i , size of UInteger:%i , size of long:%i , size of int:%i",sizeof(void*),sizeof(NSUInteger),sizeof(long),sizeof(int));
    
    NSUInteger* uarray = malloc(10*sizeof(NSUInteger));
    uarray[8] = 19;
    uarray[9] = 20;
    memset(uarray, 0, 9*4);
    
    EZDEBUG(@"The position 9 is %i, size of whole array:%i",uarray[9], sizeof(uarray));
    assert(uarray[9] == 20);
    assert(uarray[8] == 0);
    assert(sizeof(uarray) == 4);
    free(uarray);
    @try {
        //[NSString stringWithFormat:@"Value:%i",uarray[9]];
        EZDEBUG(@"Value after freed:%i", uarray[9]);
        EZDEBUG(@"Second time,Value after freed:%i", uarray[9]);
        //assert(uarray[9] == 20);
        
        //Suppose to encounter exception
        //assert(false);
    }
    @catch (NSException *exception) {
        EZDEBUG(@"Exception detail %@",exception);
    }
    @finally {
        
    }
    
    //assert(false);
}


+ (void) testPrimeSeries
{
    NSUInteger fractors[] = {2,3,5,7};
    assert(findNextFlag([[EZArray alloc] initWithArray:fractors length:4]) == 11);
    
    NSUInteger fractors1[] = {2,3,5,7,11};
    //assert(findNextFlag(fractors1, 5) == 13);
    assert(findNextFlag([[EZArray alloc] initWithArray:fractors1 length:5]) == 13);
    
    NSUInteger fractors2[] = {2,3,5,7,11,13};
    //assert(findNextFlag(fractors2, 6) == 17);
    assert(findNextFlag([[EZArray alloc] initWithArray:fractors2 length:6]) == 17);
    
    NSUInteger fractors3[] = {2,3,5,7,11,13,17};
    //assert(findNextFlag(fractors3, 7) == 19);
    assert(findNextFlag([[EZArray alloc] initWithArray:fractors3 length:7]) == 19);
    
    NSUInteger fractors4[] = {2,3,5,7,11,13,17,19};
    //assert(findNextFlag(fractors4, 8) == 23);
    assert(findNextFlag([[EZArray alloc] initWithArray:fractors4 length:8]) == 23);
    
    NSUInteger fractors5[] = {2,3,5,7,11,13,17,19,23};
    //assert(findNextFlag(fractors5, 9) == 29);
    assert(findNextFlag([[EZArray alloc] initWithArray:fractors5 length:9]) == 29);
    
    
}

//The store will get the list fetched again.
+ (void) testStoreSideEffect
{
    [EZTestSuite initializeDB];
    EZTaskGroup* tg = [[EZTaskGroup alloc] init];
    tg.name = @"Test Side Effect";
    EZTask* task1 = [[EZTask alloc] initWithName:@"Orange"];
    EZTask* task2 = [[EZTask alloc] initWithName:@"Apple"];
    [tg.tasks addObjectsFromArray:[NSArray arrayWithObjects:task1,task2, nil]];
    [[EZTaskStore getInstance] storeObject:tg];
    EZTask* res1 = [tg.tasks objectAtIndex:0];
    EZTask* res2 = [tg.tasks objectAtIndex:1];
    //The first time is the exception?
    
    //Default sort is name and alpha bata
    assert([task1.name isEqualToString:res1.name]);
    assert([task2.name isEqualToString:res2.name]);
    EZTask* task3 = [[EZTask alloc] initWithName:@"Babicue"];
    [tg.tasks addObject:task3];
    
    [[EZTaskStore getInstance] storeObject:tg];
    res1 = [tg.tasks objectAtIndex:0];
    res2 = [tg.tasks objectAtIndex:1];
    EZTask* res3 = [tg.tasks objectAtIndex:2];
    
    EZDEBUG(@"res1:%@, res2:%@, res3:%@",res1.name, res2.name, res3.name
            );
    
    assert([task1.name isEqualToString:res1.name]);
    assert([task2.name isEqualToString:res2.name]);
    assert([task3.name isEqualToString:res3.name]);
    //Confirmed that storage have no side effect. 
    //The side effect caused by the refresh.
    tg.name = @"Real Side effect";
    
    [tg refresh];
    
    res1 = [tg.tasks objectAtIndex:0];
    res2 = [tg.tasks objectAtIndex:1];
    res3 = [tg.tasks objectAtIndex:2];
    
    EZDEBUG(@"after refresh: res1:%@, res2:%@, res3:%@",res1.name, res2.name, res3.name
            );

    //assert([task1.name isEqualToString:res3.name]);
    //assert([task2.name isEqualToString:res1.name]);
    //assert([task3.name isEqualToString:res2.name]);
    
     
}

+ (void) testCascadeDelete
{
    [EZTestSuite initializeDB];
    EZTask* task = [[EZTask alloc] initWithName:@"Tian" duration:20 maxDur:20 envTraits:4];
    [[EZTaskStore getInstance] storeObject:task];
    NSArray* array = [[EZTaskStore getInstance] fetchAllWithVO:[EZTask class] PO:[MTask class] sortField:nil];
    assert(array.count == 1);
    
    //Verify what's wrong with the Persistent framework.
    
    EZTask* taskFresh = [[EZTask alloc] initWithName:@"Hou" duration:40 maxDur:60 envTraits:8];
    
    EZTaskGroup* taskGroup = [[EZTaskGroup alloc] init];
    taskGroup.name = @"Cool group";
    [taskGroup.tasks addObject:taskFresh];
    [taskGroup.tasks addObject:task];
    //Make sure task get inserted into the task of group
    assert(taskGroup.tasks.count == 2);
    
    
    [[EZTaskStore getInstance] storeObject:taskGroup];
    array = [[EZTaskStore getInstance] fetchAllWithVO:[EZTaskGroup class] PO:[MTaskGroup class] sortField:nil];
    assert(array.count == 1);
    
    
    
    
    EZTaskGroup* res = [array objectAtIndex:0];
    NSLog(@"Group %@, task count:%i", res.name, res.tasks.count);
    assert(res.tasks.count == 2);
    
    array = [[EZTaskStore getInstance] fetchAllWithVO:[EZTask class] PO:[MTask class] sortField:nil];
    assert(array.count == 2);
    
    
    [[EZTaskStore getInstance] removeObject:res];
    
    //Make sure the task get removed when the taskGroup get remove.
    //we called this cascade remove mechanism. 
    //Cool.
    array = [[EZTaskStore getInstance] fetchAllWithVO:[EZTask class] PO:[MTask class] sortField:nil];
    EZDEBUG(@"The final task count:%i",array.count);
    assert(array.count == 0);
    //Make sure there is no side effect.
    
    taskGroup = [[EZTaskGroup alloc] init];
    taskGroup.name = @"Cool group";
    [taskGroup.tasks addObject:[[EZTask alloc] initWithName:@"Tian ge 2" duration:25 maxDur:25 envTraits:25]];
    [[EZTaskStore getInstance] storeObject:taskGroup];
    
    array = [[EZTaskStore getInstance] fetchAllWithVO:[EZTaskGroup class] PO:[MTaskGroup class] sortField:nil];
    assert(array.count == 1);
    
    EZTaskGroup* resGroup = [array objectAtIndex:0];
    resGroup.name = @"Tian ge updated";
    [[EZTaskStore getInstance] storeObject:resGroup];
    
    array = [[EZTaskStore getInstance] fetchAllWithVO:[EZTaskGroup class] PO:[MTaskGroup class] sortField:nil];
    EZTaskGroup* resGroupStored = [array objectAtIndex:0];
    assert([resGroupStored.name isEqualToString:resGroup.name]);
    //Make sure no side effect happened
    assert(resGroupStored.tasks.count == 1);
    
    //Make sure no side effect happened
    array = [[EZTaskStore getInstance] fetchAllWithVO:[EZTask class] PO:[MTask class] sortField:nil];
    assert(array.count == 1);
    
    
}

+ (void) testI18N
{
    NSString* test = EZLocalizedString(@"Test",@"Test");
    NSLog(@"Result:%@",test);
    assert([@"English" isEqualToString:test]);
}

+ (void) testTrim
{
    NSString* orgin = @"  haha   \n";
    NSString* trimmed = orgin.trim;
    assert([trimmed isEqualToString:@"haha"]);
}

+ (void) testInBetween
{
    NSDate* now = [NSDate date];
    NSDate* b4 = [now adjustMinutes:-1];
    NSDate* after = [now adjustMinutes:1];
    NSDate* b44 = [now adjustMinutes:-2];
    NSDate* afterr = [now adjustMinutes:2];
    
    assert([now InBetween:b4 end:after]);
    assert(![b44 InBetween:b4 end:after]);
    assert(![afterr InBetween:b4 end:after]);
    EZDEBUG(@"now:%@, before:%@, after:%@, before4:%@ , afterr:%@",now, b4, after, b44, afterr);
}


+ (void) testTimeSort
{
    NSDate* now = [NSDate date];
    NSDate* before = [now adjustMinutes:-20];
    NSDate* after = [now adjustMinutes:20];
    NSArray* times = [NSArray arrayWithObjects:now, before, after, nil];
    NSArray* result = [times sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate* d1 = obj1;
        NSDate* d2 = obj2;
        return [d1 timeIntervalSince1970] - [d2 timeIntervalSince1970];
    }];
    NSDate* prev = nil;
    for(NSDate* dt in result){
        if(prev){
            assert([prev timeIntervalSince1970] < [dt timeIntervalSince1970]);
        }
        prev = dt;
    }
}

+ (void) testTimePassed
{
    NSDate* time = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120501"];
    assert([time isPassed:[NSDate date]]);
}

+ (EZAvailableTime*) findTimeByObjectID:(NSManagedObjectID*)objID list:(NSArray*)list
{
    for(EZAvailableTime* avTime in list){
        EZDEBUG(@"Target objectID:%@, Source objectID:%@",avTime.PO.objectID, objID);
        if([avTime.PO.objectID isEqual:objID]){
            return avTime;
        }
    }
    return nil;
}

+ (void) initializeDB
{
    NSString* testDB = @"TestDB.sqlite";
    [EZCoreAccessor cleanDB:testDB];
    EZCoreAccessor* accessor = [[EZCoreAccessor alloc] initWithDBName:testDB modelName:CoreModelName];
    [EZCoreAccessor setInstance:accessor];
}

+ (void) testSimpleData 
{
    NSString* testDB = @"TestTasks.sqlite";
    [EZCoreAccessor cleanDB:testDB];
    
    EZCoreAccessor* accessor = [[EZCoreAccessor alloc] initWithDBName:testDB modelName:CoreModelName];
    MAvailableDay* day = (MAvailableDay*)[accessor create:[MAvailableDay class]];
    EZDEBUG(@"Instanciated %@", day);
    assert(day != nil);
    day.date = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120601"];
    [accessor store:day];
    NSArray* days = [accessor fetchAll:[day class] sortField:@"name"];
    EZDEBUG(@"The count is:%i",[days count]);
    assert([days count] == 1);
    
    MTaskGroup* group = [accessor create:[MTaskGroup class]];
    group.name = @"Gym";
    
    MTask* task = [accessor create:[MTask class]];
    task.name = @"Taiji";
    EZDEBUG(@"Task ID detail %@, hash %i",task.objectID, task.objectID.hash);
    [group addTasksObject:task];
    [accessor store:group];
    NSArray* groups = [accessor fetchAll:[MTaskGroup class] sortField:nil];
    assert([groups count] == 1);
    
    MTaskGroup* storedGroup = [groups objectAtIndex:0];
    assert([storedGroup.tasks count] == 1);
    
    MTask* fetchedTask = [storedGroup.tasks anyObject];
    assert([fetchedTask.name compare:task.name] == NSOrderedSame);
    //Test refresh
    
    task.name = @"Play cool";
    [accessor store:task];
    [task.managedObjectContext refreshObject:fetchedTask mergeChanges:YES];
    assert([fetchedTask.name compare:@"Play cool"] == NSOrderedSame);
    
    group.name = @"Brand New";
    [accessor store:group];
    [storedGroup.managedObjectContext refreshObject:storedGroup mergeChanges:NO];
    assert([storedGroup.name compare:@"Brand New"] == NSOrderedSame);
    
    MImageOwner* iowner = [accessor create:[MImageOwner class]];
    iowner.name = @"Tian ge";
    iowner.thumbNail = @"Dog Picture";
    [accessor store:iowner];
    MImageOwner* storedOwner = [[accessor fetchAll:[MImageOwner class] sortField:nil] objectAtIndex:0];
    assert([storedOwner.thumbNail compare:@"Dog Picture"] == NSOrderedSame);
    
    UILocalNotification* note = [[UILocalNotification alloc] init];
    note.fireDate = [NSDate stringToDate:@"yyyyMMdd>HHmmss" dateString:@"20120531>202020"];
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:note];
    
    UILocalNotification* localNote = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    EZDEBUG(@"Recovered Notification:%@",localNote);
    
    assert([localNote.fireDate isEqualToDate:note.fireDate]);
    
    
    MScheduledTask* schTask = [accessor create:[MScheduledTask class]];
    MTask* subTask = [accessor create:[MTask class]];
    subTask.name = @"Taiji";
    subTask.duration = [[NSNumber alloc] initWithInt:20];
    schTask.task = subTask;
    schTask.startTime = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120601"];
    schTask.alarmNotification = [[UILocalNotification alloc] init];
    schTask.alarmNotification.fireDate = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120701"];
    [accessor store:schTask];
    
    NSArray* scheduleTasks = [accessor fetchAll:[MScheduledTask class] sortField:@"duration"];
    assert([scheduleTasks count] == 1);
    MScheduledTask* storedSchTask = [scheduleTasks objectAtIndex:0];
    
    assert([storedSchTask.alarmNotification.fireDate isEqualToDate:schTask.alarmNotification.fireDate]);
    
}

+ (WeakReferObject*) withBlockCall:(EZReleaseDetector*)dect
{
    WeakReferObject* res = [[WeakReferObject alloc] init];
    //res.referred = dect;
    res.strongRef = ^(id obj){
        EZDEBUG(@"Value %@",dect.name);  
    };
    return res;
}

//The purpose of this method is to check what's the root cause for this behave.
//You just have limitless time to explore the myth of iOS. Take your time and enjoy doing it.
//Digging into the core.
+ (WeakReferObject*) withDetector:(EZReleaseDetector*)dect
{
    WeakReferObject* res = [[WeakReferObject alloc] init];
    res.strongRed = dect;
    return res;
}

+ (void) testBlockMemory
{
    static int deallocCount = 0;
    EZReleaseDetector* dect = [[EZReleaseDetector alloc] initWithName:@"CoolRelease" hasStackTrace:false];
    dect.block = ^(){
        ++deallocCount;
    };
    dect = nil;
    assert(deallocCount == 1);
    
    dect = [[EZReleaseDetector alloc] initWithName:@"CoolRelease" hasStackTrace:NO];
    dect.block = ^(){
        ++deallocCount;
    };
    WeakReferObject* weakRef = [self withBlockCall:dect];
    dect = nil;
    EZReleaseDetector* red = [[EZReleaseDetector alloc] initWithName:@"StrongRelease" hasStackTrace:NO];
    red.block = ^(){
        EZDEBUG(@"Strong get dealloced");
        ++deallocCount;
    };
    weakRef.strongRed = red;
    red = nil;
    assert(deallocCount == 1);
    //weakRef.strongRef = nil;
    weakRef = nil;//Why this not work?
    EZDEBUG(@"If the weak make any difference");
    //assert(deallocCount == 2);
    
    WeakReferObject* directWeak = [[WeakReferObject alloc] init];
    EZReleaseDetector* red2 = [[EZReleaseDetector alloc] initWithName:@"Red2" hasStackTrace:YES];
    directWeak.strongRed = red2;
    red2.block = ^(){
        EZDEBUG(@"Red2 get released");
    };
    red2 = nil;
    directWeak = nil;
    EZDEBUG(@"DirectWeak should be released");  
    
    static int dcount = 0;
    EZReleaseDetector* dect3 = [[EZReleaseDetector alloc] initWithName:@"Red3" hasStackTrace:YES];
    dect3.block = ^(){
        ++dcount;
    };
    WeakReferObject* funcWeak = [self withDetector:dect3]; 
    funcWeak = nil;
    //The reason, is because when a object passed outside, it will be autorelease.
    //By autorelease mean that It will get released by the end of the call stack.
    assert(dcount == 0);
    //assert(dcount == 1);
    //WeakReferObject* 
    
}

+ (void) testMethodAsProperty
{
    TestObject1* tobj1 = [[TestObject1 alloc] init];
    assert([@"Coolguy" isEqualToString:[tobj1.generateArray objectAtIndex:0]]);
}

+ (void) testTimeIntervelSinceNow
{
    NSDate* yesterday = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120528"];
    //Make the test case work whenever and wherever you run it.
    //Mean you should carry your env with you
    NSDate* tomorrow = [[NSDate date] adjustDays:1];
    assert([yesterday timeIntervalSinceNow] < 0);
    assert([tomorrow timeIntervalSinceNow] > 0);
}
// IndexPath is a puzzle last for very long time. 
// It will not be a puzzle to me any more.
// I will figure it out 
+ (void) testIndexPath
{
    //NSIndexPath* ip1 = [[NSIndexPath alloc] initWithIndex:1];
    NSUInteger iarr[2];
    iarr[0] = 2; iarr[1] = 5;
    NSIndexPath* ip1 = [[NSIndexPath alloc] initWithIndexes:iarr length:2];
    EZDEBUG(@"Row for index 1 is:%i, section is:%i",ip1.row, ip1.section);

}

// Describe the task cases and my expectation.
// This is a complicated test cases
// This is a natural 1 week cycle.(Customize cyle don't exist this issue)
// 21 hours quotas.
// Today is Friday
// We have Wendesday and Thursday's history date.
// Wednesday have 2 and Thursday have 1
// Actual start at Wednesday.
// So the history Time should be
// 3*3+3 = 12.
// 4.5 = 5

+ (void) testQuotasWithHistory
{
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    EZTaskStore* store = [EZTaskStore getInstance];
    [store clean];
    EZTask* task = [[EZTask alloc] initWithName:@"iOS programming" duration:60 maxDur:120 envTraits:EZ_ENV_FITTING];
    
    NSDate* actualStart = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120523"];
    task.quotas = [[EZQuotas alloc] init:actualStart quotas:21 type:WeekCycle cycleStartDate:nil cycleLength:7];
    NSDate* today = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120525"];
    
    
    EZScheduledTask* ios1 = [[EZScheduledTask alloc] init];
    ios1.task = task;
    ios1.startTime = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120523"];
    ios1.duration = 2;
    [store storeScheduledTask:[NSArray arrayWithObject:ios1] date:ios1.startTime];
    
    EZScheduledTask* ios2 = [[EZScheduledTask alloc] init];
    ios2.task = task;
    ios2.startTime = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120524"];
    ios2.duration = 1;
    [store storeScheduledTask:[NSArray arrayWithObject:ios2] date:ios2.startTime];
     
    int historyTime = [scheduler calcHistoryTime:task date:today];
    assert(historyTime == 12);
}

//The simplest Quotas test cases
+ (void) testQuotasTask
{
    [EZTestSuite initializeDB];
    EZTaskStore* store = [EZTaskStore getInstance];
    //clean the data, so that we could start our test
    EZAvailableDay* avDay = [[EZAvailableDay alloc] initWithName:@"All Time" weeks:ALLDAYS];
    EZAvailableTime* time1 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"06:00"] name:@"Taiji time" duration:120 environment:EZ_ENV_FITTING];
    EZAvailableTime* time2 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"08:00"] name:@"Programming time" duration:90 environment:EZ_ENV_FLOWING];
    EZAvailableTime* time3 = [[EZAvailableTime alloc] init:[NSDate stringToDate:@"HH:mm" dateString:@"10:00"] name:@"Reading and Thinking" duration:120 environment:EZ_ENV_FLOWING|EZ_ENV_READING];
    [avDay.availableTimes addObjectsFromArray:[NSArray arrayWithObjects:time3, time2, time1, nil]];
    //[store.availableDays addObject:avDay];
    [store storeObject:avDay];
    EZTask* task1 = [[EZTask alloc] initWithName:@"programming" duration:80 maxDur:80 envTraits:EZ_ENV_FLOWING];
    EZTask* task2 = [[EZTask alloc] initWithName:@"Martin Luther King" duration:20 maxDur:40 envTraits:EZ_ENV_READING];
    EZTask* task3 = [[EZTask alloc] initWithName:@"Gandhi" duration:30 maxDur:60 envTraits:EZ_ENV_READING];
    EZQuotas* quotas = [[EZQuotas alloc] init:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120526"] quotas:1200 type:CustomizedCycle cycleStartDate:[NSDate stringToDate:@"yyyyMMdd" dateString:@"20120526"] cycleLength:10];
    task1.quotas = quotas;
   // [store.tasks addObjectsFromArray:[NSArray arrayWithObjects:task1, task2, task3, nil]];
    [store storeObjects:[NSArray arrayWithObjects:task1, task2, task3, nil]];
    EZDEBUG(@"Begin call schedule");
    EZTaskScheduler* tscheduler = [[EZTaskScheduler alloc] init];
    NSDate* date = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120526"];
    EZQuotasResult* res = [tscheduler scheduleQuotasTask:store.getAllTasks date:date avDay:[store getAvailableDay:date]];
    EZDEBUG(@"End call schedule");
    assert([res.availableDay.availableTimes count] == 3);
    
    //I can no more make the assumption.Because things query out of the store are in new sequence.
    EZDEBUG(@"Time1 objectID:%@",time1.PO.objectID);
    
    EZAvailableTime* adjustedTime1 = [EZTestSuite findTimeByObjectID:time1.PO.objectID list:res.availableDay.availableTimes];
    EZDEBUG(@"Return time1:%@", adjustedTime1.PO.objectID);
    
    EZAvailableTime* adjustedTime2 = [EZTestSuite findTimeByObjectID:time2.PO.objectID list:res.availableDay.availableTimes];
    
    EZAvailableTime* adjustedTime3 = [EZTestSuite findTimeByObjectID:time3.PO.objectID list:res.availableDay.availableTimes];
    
    assert(adjustedTime1.duration == time1.duration);
    
    NSLog(@"Time2 Duration is:%i, Time3 Duration is:%i",adjustedTime2.duration, adjustedTime3.duration);
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


//Why this task failed?
//I never touch upper level things, What's just going on?
+ (void) testExclusive
{
    //I think need to call this before each TestCase
    [EZTestSuite initializeDB];
    
    EZTaskStore* ets = [EZTaskStore getInstance];
    [ets clean];
    EZTask* task = [[EZTask alloc] initWithName:@"Taiji" duration:120 maxDur:120 envTraits:EZ_ENV_FITTING];
   
    
    [ets storeObject:task];
    EZAvailableDay* aDay = [[EZAvailableDay alloc] init];
    aDay.assignedWeeks = ALLDAYS;
    NSDate* startTime = [NSDate date];
    EZAvailableTime* avTime = [[EZAvailableTime alloc] init:startTime name:@"Taiji time" duration:150 environment:EZ_ENV_FITTING];
    [aDay.availableTimes addObject:avTime];
    //[ets.availableDays addObject:aDay];
    [ets storeObject:aDay];
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    NSArray* res = [scheduler scheduleTaskByBulk:avTime exclusiveList:nil tasks:ets.getAllTasks];
    assert([res count] == 1);
    NSArray* exclusive = [NSArray arrayWithObject:task];
    res = [scheduler scheduleTaskByBulk:avTime exclusiveList:exclusive tasks:ets.getAllTasks];
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
    
    EZAvailableTime* av1 = [[EZAvailableTime alloc] init:startTime1 name:@"Practice" duration:5 environment:EZ_ENV_FITTING];
    
    EZAvailableTime* av2 = [[EZAvailableTime alloc] init:startTime2 name:@"Reading" duration:5 environment:EZ_ENV_READING];
    EZAvailableDay* availableDay = [[EZAvailableDay alloc] init];
    availableDay.assignedWeeks = ALLDAYS;
    [availableDay.availableTimes addObjectsFromArray:[NSArray arrayWithObjects:av1, av2, nil]];
    EZTaskStore* store = [EZTaskStore getInstance];
    [store clean];
    [store storeObject:availableDay];
    
    EZTask* task1 = [[EZTask alloc] initWithName:@"Read" duration:1 maxDur:1 envTraits:EZ_ENV_READING];
    
    EZTask* task2 = [[EZTask alloc] initWithName:@"Joke" duration:1 maxDur:1 envTraits:EZ_ENV_SOCIALING ];
    
    EZTask* task3 = [[EZTask alloc] initWithName:@"Taiji" duration:1 maxDur:1 envTraits:EZ_ENV_FITTING];
    [store storeObjects:[NSArray arrayWithObjects:task1, task2, task3, nil]];
    
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    
    NSArray* scheduledTasks = [scheduler scheduleTaskByDate:[NSDate stringToDate:@"yyyyMMdd-HH:mm" dateString:@"20120525-04:30"] exclusiveList:nil];
    
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
    [store storeObjects:[NSArray arrayWithObjects:day1, day2, day3, nil]];
    
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
    EZTask* task1 = [[EZTask alloc] initWithName:@"Read" duration:10 maxDur:10 envTraits:EZ_ENV_NO_REQ];
    task1.envTraits = 2*3;
    
    EZTask* task2 = [[EZTask alloc] initWithName:@"Write" duration:10 maxDur:10 envTraits:EZ_ENV_NO_REQ];
    task2.envTraits = 2;
    
    EZTask* task3 = [[EZTask alloc] initWithName:@"Think" duration:10 maxDur:10 envTraits:EZ_ENV_NO_REQ];
    task3.envTraits = 5;
    [store storeObjects:[NSArray arrayWithObjects:task1, task2, task3, nil]];
    
    NSArray* res = [store getTasks:2];
    NSLog(@"Get task returned:%i",[res count]);
    
    NSArray* res2 = [[EZCoreAccessor getInstance] fetchAll:[MTask class] sortField:nil];
    NSLog(@"Direct fetch get:%i",[res2 count]);
    
    assert([res count] == 1);
    assert([task2 isEqual:[res objectAtIndex:0]]);
    
    res = [store getTasks:11];
    assert([res count] == 0);
    
    res = [store getTasks:2*3*5];
    assert([res count] == 3);
    assert([res containsObject:task1]);
    assert([res containsObject:task2]);
    assert([res containsObject:task3]);
            
}

/**

+ (void) testTaskStore
{
    EZTaskStore* store = [EZTaskStore getInstance];
    EZScheduledDay* yesterday = [[EZScheduledDay alloc] init];
    yesterday.scheduledDay = [[NSDate alloc] initWithTimeIntervalSinceNow:-60*60*24];
    
    EZScheduledDay* tomorrow = [[EZScheduledDay alloc] init];
    tomorrow.scheduledDay = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24];
    
    EZScheduledDay* today = [[EZScheduledDay alloc] init];
    today.scheduledDay = [NSDate date];
    
    [store storeObjects:[NSArray arrayWithObjects:yesterday,tomorrow,today, nil]];
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
  **/

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
    EZAvailableTime* avTime = [[EZAvailableTime alloc] init:startTime name:@"Test scheduler" duration:13 environment:EZ_ENV_NO_REQ];
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    // NSArray* tasks = [EZTaskStore getTasks:avTime.environmentTraits];
    
    EZTask* smallTk = [[EZTask alloc]
                       initWithName:@"small" duration:1 maxDur:1 envTraits:EZ_ENV_NO_REQ]; 
    EZTask* middleTk  = [[EZTask alloc]initWithName:@"middle" duration:2 maxDur:2 envTraits:EZ_ENV_NO_REQ];
    EZTask* largeTk = [[EZTask alloc]initWithName:@"large" duration:5 maxDur:5 envTraits:EZ_ENV_NO_REQ];
    EZTask* illFitTask = [[EZTask alloc]initWithName:@"illFitTask" duration:14 maxDur:14 envTraits:EZ_ENV_NO_REQ];
    
    EZTask* adjustTask = [[EZTask alloc]initWithName:@"adjustTask" duration:3 maxDur:3 envTraits:EZ_ENV_NO_REQ];
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
    EZAvailableTime* avTime = [[EZAvailableTime alloc] init:[NSDate date] name:@"Test scheduler" duration:10 environment:EZ_ENV_NO_REQ];
    EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    // NSArray* tasks = [EZTaskStore getTasks:avTime.environmentTraits];
    NSArray* tasks = [NSArray arrayWithObjects:[[EZTask alloc]initWithName:@"small" duration:1 maxDur:1 envTraits:EZ_ENV_NO_REQ],
                      [[EZTask alloc]initWithName:@"middle" duration:2 maxDur:2 envTraits:EZ_ENV_NO_REQ],
                      [[EZTask alloc]initWithName:@"large" duration:5 maxDur:5 envTraits:EZ_ENV_NO_REQ],nil
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
