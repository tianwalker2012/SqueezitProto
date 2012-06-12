//
//  EZQuotas.m
//  SqueezitProto
//
//  Created by Apple on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZQuotas.h"
#import "MQuotas.h"
#import "EZCoreAccessor.h"

@implementation EZQuotas
@synthesize startDay, cycleType, cycleLength, cycleStartDay, maximumPerDay, quotasPerCycle, PO;

- (id) init:(NSDate*)sd quotas:(int)quotas type:(CycleType)type cycleStartDate:(NSDate*)cycleDate cycleLength:(int)length
{
    self = [super init];
    self.quotasPerCycle = quotas;
    self.startDay = sd;
    self.cycleType = type;
    self.cycleStartDay = cycleDate;
    self.cycleLength = length;
    return self;
}

- (id) cloneVO{
    return [[EZQuotas alloc] initWithVO:self];
}

- (id) initWithVO:(EZQuotas*) qu
{
    self = [super init];
    self.quotasPerCycle = qu.quotasPerCycle;
    self.startDay = qu.startDay;
    self.cycleType = qu.cycleType;
    self.cycleStartDay = qu.cycleStartDay;
    self.cycleLength = qu.cycleLength;
    self.PO = qu.PO;
    return self;
}

- (id) initWithPO:(MQuotas*)mtk
{
    self = [super init];
    self.quotasPerCycle = mtk.quotasPerCycle.intValue;
    self.startDay = mtk.startDate;
    self.cycleType = mtk.cycleType.intValue;
    self.cycleStartDay = mtk.cycleStartDate;
    self.cycleLength = mtk.cycleLength.intValue;
    return self;
}

- (MQuotas*) createPO
{
    if(!self.PO){
        self.PO = (MQuotas*)[[EZCoreAccessor getInstance] create:[MQuotas class]];
    }
    return [self populatePO:self.PO];
}

- (MQuotas*) populatePO:(MQuotas*)po
{
    po.quotasPerCycle = [[NSNumber alloc] initWithInt:self.quotasPerCycle];
    po.startDate = self.startDay;
    po.cycleType = [[NSNumber alloc] initWithInt:self.cycleType];
    po.cycleStartDate = self.cycleStartDay;
    po.cycleLength = [[NSNumber alloc] initWithInt:self.cycleLength];
    return po;
}

@end
