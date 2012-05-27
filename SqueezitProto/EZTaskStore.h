//
//  EZTaskStore.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class EZScheduledDay,EZAvailableDay, EZTask;

@interface EZTaskStore : NSObject {
    NSMutableArray* scheduledDays;
    NSMutableArray* tasks;
    NSMutableArray* archivedTasks;
    NSMutableArray* availableDays;
    NSMutableDictionary* storedScheduledTasks;
}


@property (strong, nonatomic) NSMutableArray* scheduleDays;
@property (strong, nonatomic) NSMutableArray* tasks;
@property (strong, nonatomic) NSMutableArray* achievedTasks;
@property (strong, nonatomic) NSMutableArray* availableDays;

- (id) init;

+ (EZTaskStore*) getInstance;

- (int) getTaskTime:(EZTask*)task start:(NSDate*)tart end:(NSDate*)end;

- (NSArray*) getScheduledTaskByDate:(NSDate*)date;

- (void) storeScheduledTask:(NSArray*)tasks date:(NSDate*)date;

- (NSArray*) getTasks:(int)env; 

// The result are sorted by date, mean the latest are at the beginning
- (NSArray*) getSortedScheduledDays;

// Find the scheduledDay for a particular date.
- (EZScheduledDay*) getScheduledDayByDate:(NSDate*)date;

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
