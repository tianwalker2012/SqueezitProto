//
//  EZQuotas.m
//  SqueezitProto
//
//  Created by Apple on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZQuotas.h"

@implementation EZQuotas
@synthesize startDay, cycleType, cycleLength, cycleStartDay, maximumPerDay, quotasPerCycle;

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

@end
