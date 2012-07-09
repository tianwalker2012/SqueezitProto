//
//  EZAvailableTime.m
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvailableTime.h"
#import "MAvailableTime.h"
#import "EZCoreAccessor.h"

@implementation EZAvailableTime
@synthesize start, duration, envTraits, name, PO, collide;

- (id) init:(NSDate*)st name:(NSString*)nm duration:(int)dur environment:(NSUInteger)env
{
    self = [super init];
    self.start = st;
    //self.description = ds;
    self.name = nm;
    self.duration = dur;
    self.envTraits = env;
    return self;
}



- (id) initWithVO:(EZAvailableTime*)at
{
    self = [super init];
    self.start = at.start;
    self.name = at.name;
    //self.description = at.description;
    self.duration = at.duration;
    self.envTraits = at.envTraits;
    self.PO = at.PO;
    return self;
}

- (id) cloneVO
{
    return [[EZAvailableTime alloc] initWithVO:self];
}

- (void) adjustStartTime:(int)increasedMinutes
{
    self.start = [[NSDate alloc] initWithTimeInterval:increasedMinutes*60 sinceDate:self.start];
    
}

- (id) initWithPO:(MAvailableTime*)mtk
{
    self = [super init];
    self.start = mtk.startTime;
    self.name = mtk.name;
    self.envTraits = mtk.envTraits.unsignedIntegerValue;
    self.duration = mtk.duration.intValue;
    self.PO = mtk;
    return self;
}

- (MAvailableTime*) createPO
{
    if(!self.PO){
        self.PO = (MAvailableTime*)[[EZCoreAccessor getInstance] create:[MAvailableTime class]];
    }    
    return [self populatePO:self.PO];
    
}

- (MAvailableTime*) populatePO:(MAvailableTime*)po
{
    po.startTime = self.start;
    po.name = self.name;
    po.envTraits = [[NSNumber alloc] initWithUnsignedInteger:self.envTraits];
    po.duration = [[NSNumber alloc] initWithInt:self.duration];
    return po;
}

@end
