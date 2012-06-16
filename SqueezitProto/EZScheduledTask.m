//
//  EZScheduledTask.m
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledTask.h"
#import "EZTask.h"
#import "EZTaskHelper.h"
#import "MScheduledTask.h"
#import "EZCoreAccessor.h"

@implementation EZScheduledTask
@synthesize startTime, duration, task, envTraits, alarmNotification, PO, alarmType;

- (NSString*) detail
{
    return [NSString stringWithFormat:@"Name:%@, start at:%@, duration:%i, envTraits:%i",task.name,[startTime stringWithFormat:@"yyyyMMdd>HH:mm:ss"],duration,envTraits];
}

- (id) initWithVO:(EZScheduledTask*) obj
{
    self = [super init];
    self.startTime = obj.startTime;
    self.duration = obj.duration;
    self.task = obj.task.cloneVO;
    self.envTraits = obj.envTraits;
    self.alarmNotification = obj.alarmNotification;
    self.PO = obj.PO;
    self.alarmType = obj.alarmType;
    return self;
}

- (id) cloneVO
{
    return [[EZScheduledTask alloc] initWithVO:self];
}

- (id) initWithPO:(MScheduledTask*)mtk
{
    self = [super init];
    self.startTime = mtk.startTime;
    self.duration = mtk.duration.intValue;
    self.task = [[EZTask alloc] initWithPO:mtk.task];
    self.envTraits = mtk.envTraits.unsignedIntegerValue;
    self.alarmNotification = mtk.alarmNotification;
    self.PO = mtk;
    self.alarmType = mtk.alarmType.integerValue;
    return self;
}

- (MScheduledTask*) createPO
{
    if(self.PO == nil){
        EZCoreAccessor* accessor = [EZCoreAccessor getInstance];
        self.PO = (MScheduledTask*)[accessor create:[MScheduledTask class]];
    }
    return [self populatePO:self.PO];
}

- (MScheduledTask*) populatePO:(MScheduledTask*)po
{
    po.startTime = self.startTime;
    po.duration = [[NSNumber alloc] initWithInt:self.duration];
    po.envTraits = [[NSNumber alloc] initWithUnsignedInteger:self.envTraits];
    po.alarmNotification = self.alarmNotification;
    po.alarmType = [[NSNumber alloc] initWithInteger:self.alarmType];
    //Assume every ScheduledTask have Task.
    if(po.task){
        [self.task populatePO:po.task];
    }else{
        po.task = [self.task createPO];
    }
    return po;
}

- (id) init
{
    self = [super init];
    alarmType = EZ_SOUND;
    return self;
}

@end
