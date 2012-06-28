//
//  MScheduledDay.h
//  SqueezitProto
//
//  Created by Apple on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MScheduledTask;

@interface MScheduledDay : NSManagedObject

@property (retain, nonatomic) NSDate* scheduledDate;
//@property (retain, nonatomic) NSSet* scheduledTasks;

@end

/**
@interface MScheduledDay (CoreDataGeneratedAccessors)

- (void)addScheduledTasksObject:(MScheduledTask *)value;
- (void)removeScheduledTasksObject:(MScheduledTask *)value;
- (void)addScheduledTasks:(NSSet *)values;
- (void)removeScheduledTasks:(NSSet *)values;

@end
**/