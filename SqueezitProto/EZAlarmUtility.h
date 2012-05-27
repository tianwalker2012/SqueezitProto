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

//Setup the alarm for task
+ (void) setupAlarm:(EZScheduledTask*)task;

//Cancel the alarm for task
+ (void) cancelAlarm:(EZScheduledTask*)task;


@end
