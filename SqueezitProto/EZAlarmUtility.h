//
//  EZAlarmUtility.h
//  SqueezitProto
//
//  Created by Apple on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EZScheduledTask;

@interface EZAlarmUtility : NSObject

+ (void) setupAlarmBulk:(NSArray*)tasks;

+ (void) cancelAlarmBulk:(NSArray*)tasks;

//Setup the alarm for task
+ (void) setupAlarm:(EZScheduledTask*)task;

//Cancel the alarm for task
+ (void) cancelAlarm:(EZScheduledTask*)task;


@end
