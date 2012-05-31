//
//  MTaskGroup.h
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTask;

@interface MTaskGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface MTaskGroup (CoreDataGeneratedAccessors)

- (void)addTasksObject:(MTask *)value;
- (void)removeTasksObject:(MTask *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
