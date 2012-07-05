//
//  EZTestSuite.h
//  SqueezitProto
//
//  Created by Apple on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZTestSuite : NSObject

+ (void) testSchedule;

//The purpose of this task is to clean all the orphaned tasks
//What's the definition of orphan task?
//The task which do not belong to any taskgroup are orphaned task.
+ (void) cleanOrphanTask;

@end
