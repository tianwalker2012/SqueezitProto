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
@synthesize startTime, duration, task, envTraits, alarmNotification, PO;

- (NSString*) detail
{
    return [NSString stringWithFormat:@"Name:%@, start at:%@, duration:%i, envTraits:%i",task.name,[startTime stringWithFormat:@"yyyyMMdd>HH:mm:ss"],duration,envTraits];
}

- (id) initWithPO:(MScheduledTask*)mtk
{
    self = [super init];
    self.startTime = mtk.startTime;
    self.duration = mtk.duration.intValue;
    self.task = [[EZTask alloc] initWithPO:mtk.task];
    self.envTraits = mtk.envTraits.intValue;
    self.alarmNotification = mtk.alarmNotification;
    self.PO = mtk;
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
    po.envTraits = [[NSNumber alloc] initWithInt:self.envTraits];
    po.alarmNotification = self.alarmNotification;
    //Assume every ScheduledTask have Task.
    if(po.task){
        [self.task populatePO:po.task];
    }else{
        po.task = [self.task createPO];
    }
    return po;
}

@end
