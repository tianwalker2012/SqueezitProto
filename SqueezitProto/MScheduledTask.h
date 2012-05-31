//
//  MZScheduledTask.h
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTask;
@interface NotificationConverter : NSValueTransformer {
}
@end

@interface MScheduledTask : NSManagedObject

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * envTraits;
@property (nonatomic, retain) MTask *task;
@property (nonatomic, retain) UILocalNotification* alarmNotification;



@end
