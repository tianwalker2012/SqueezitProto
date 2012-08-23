//
//  EZTaskStore.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "EZTaskHelper.h"

@class EZScheduledDay,EZAvailableDay, EZTask, EZCoreAccessor, EZArray, EZScheduledTask, EZEnvFlag;

NSString* envTraitsToString(NSUInteger envTraits);

@interface EZTaskStore : NSObject {
    //EZCoreAccessor* accessor;
}

//@property (strong, nonatomic) EZCoreAccessor* accessor;

@property (strong, nonatomic) NSMutableDictionary* flagToEnvFlag;
@property (strong, nonatomic) NSMutableArray* envFlags;

- (id) init;

+ (EZTaskStore*) getInstance;

- (void) fillEnvFlag;

//Read flags into a NSDictionary
- (void) populateEnvFlags;

- (EZArray*) flagsToArray;

- (void) storeObject:(NSObject<EZValueObject>*)obj;

- (void) storeObjects:(NSArray*) objects;

- (void) removeObject:(NSObject<EZValueObject>*)obj;

- (void) removeObjects:(NSArray*) objects;

- (int) getTaskTime:(EZTask*)task start:(NSDate*)tart end:(NSDate*)end;

- (NSArray*) getScheduledTaskByDate:(NSDate*)date;

- (void) removeScheduledTaskByDate:(NSDate*)date;

- (void) storeScheduledTask:(NSArray*)tasks date:(NSDate*)date;

- (NSArray*) getTasks:(NSUInteger)env; 

- (NSArray*) getAllTasks;

- (NSArray*) fetchAllWithVO:(Class)voType PO:(Class)poType sortField:(NSString*)field;

- (NSArray*) fetchWithPredication:(NSPredicate*)predicate VO:(Class)voType PO:(Class)poType sortField:(NSString*)field;

// Pick a allocated pattern for that day 
- (EZAvailableDay*) getAvailableDay:(NSDate*)date;

// Get all available allocated pattern for that day
- (NSArray*) getAllAvailableDay;

// Get cycle history data
// It is return the history for a particular cycle based on the date and cycle type
- (NSArray*) getCycleData:(int)cycleType date:(NSDate*)date;

- (NSString*) StringForFlags:(NSUInteger)flags;

- (NSArray*) StringArrayForFlags:(NSUInteger)flags;

- (EZScheduledTask*) fetchScheduledTaskByURL:(NSString*)urlStr;

//This will get all the schedule task from to to.
//A EZScheduleStats object was created. 
//A total hours will be recorded in this object.
- (NSArray*) statsFetchScheduledTaskFrom:(NSDate*)from to:(NSDate*)to;


//I may need to add the inverse field of the TaskGroup in the EZTask to help 
//Make the group by Task group easy
//I am afraid the memory will blow up for the stats related functionality. 
//I may need raw sql query to accomplish this.
//Current iteration let's implement the most inefficient one for fun. 
//Enjoy
- (NSArray*) statsTaskClusterByGroupFrom:(NSDate*)from to:(NSDate*)to;


//The stats for all the tasks during a period of times
- (NSArray*) statsTaskFrom:(NSDate*)from to:(NSDate*)to;

// Currently only for test purpose. Clean the influence among different test cases
- (void) clean;

// Currently only for test purpose. It is hard to test your design without proper test data
- (void) fillTestData;


//Get current used daily notification
- (UILocalNotification*) getDailyNotification;

//Will cancel the old notification and store and setup the new notification
- (void) setDailyNotification:(UILocalNotification*)notification;

//Will be called to check if it is the first time application start
- (BOOL) isFirstTime;

//Setup the firstTime flag.
- (void) setFirstTime:(BOOL)firstTime;

//What's the purpose of this method?
//Because the envFlags flag will need to be the next prime number so can not be 
//Initialize at will. 
//This Method will generate the next prime number and instantiate EZEnvFlag 
//It will be created and stored and added the envFlags
- (EZEnvFlag*) createNextFlagWithName:(NSString*)name;

@end
