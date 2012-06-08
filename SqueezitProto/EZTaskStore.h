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

@class EZScheduledDay,EZAvailableDay, EZTask, EZCoreAccessor;

@interface EZTaskStore : NSObject {
    //EZCoreAccessor* accessor;
}

//@property (strong, nonatomic) EZCoreAccessor* accessor;


- (id) init;

+ (EZTaskStore*) getInstance;

- (void) storeObject:(NSObject<EZValueObject>*)obj;

- (void) storeObjects:(NSArray*) objects;

- (void) removeObject:(NSObject<EZValueObject>*)obj;

- (void) removeObjects:(NSArray*) objects;

- (int) getTaskTime:(EZTask*)task start:(NSDate*)tart end:(NSDate*)end;

- (NSArray*) getScheduledTaskByDate:(NSDate*)date;

- (void) storeScheduledTask:(NSArray*)tasks date:(NSDate*)date;

- (NSArray*) getTasks:(int)env; 

- (NSArray*) getAllTasks;

- (NSArray*) fetchAllWithVO:(Class)voType po:(Class)poType sortField:(NSString*)field;

// Pick a allocated pattern for that day 
- (EZAvailableDay*) getAvailableDay:(NSDate*)date;

// Get all available allocated pattern for that day
- (NSArray*) getAllAvailableDay;

// Get cycle history data
// It is return the history for a particular cycle based on the date and cycle type
- (NSArray*) getCycleData:(int)cycleType date:(NSDate*)date;

// Currently only for test purpose. Clean the influence among different test cases
- (void) clean;

// Currently only for test purpose. It is hard to test your design without proper test data
- (void) fillTestData;

@end
