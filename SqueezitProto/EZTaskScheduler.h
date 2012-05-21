//
//  EZTaskScheduler.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
///Users/apple/work_foot/ios/SqueezitProto/SqueezitProto/EZTask.h

#import <Foundation/Foundation.h>

@class ScheduledTask, EZAvailableTime;

@interface EZTaskScheduler : NSObject

// The exlusive list mean, do NOT choose from those already choosed
- (ScheduledTask*) scheduleTask:(NSDate*)startTime duration:(int)duration exclusiveList:(NSArray*)exclusive;

// Will select multiple task to assign, actually, I think, I actually need this method a lot.
- (NSArray*) scheduleTaskByBulk:(EZAvailableTime*)timeSlot exclusiveList:(NSArray*)exclusive;
@end
