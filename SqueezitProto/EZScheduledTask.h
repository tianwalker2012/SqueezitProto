//
//  EZScheduledTask.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "EZTaskHelper.h"

@class EZTask, MScheduledTask;

@interface EZScheduledTask : NSObject<EZValueObject> {
    NSDate* startTime;
    int duration;
    EZTask* task;
    //When I change the tasks I need this traits
    EZEnvironmentTraits envTraits;
//    NSString* description;
}

- (NSString*) detail;

@property(strong, nonatomic) NSDate* startTime;
@property(strong, nonatomic) EZTask* task;
@property(assign, nonatomic) int duration;
@property(assign, nonatomic) EZEnvironmentTraits envTraits;
//@property(strong, nonatomic) NSString* description;
@property(strong, nonatomic) UILocalNotification* alarmNotification;
@property(strong, nonatomic) MScheduledTask* PO;


- (id) initWithPO:(MScheduledTask*)mtk;

- (MScheduledTask*) createPO;

- (MScheduledTask*) populatePO:(MScheduledTask*)po;

@end
