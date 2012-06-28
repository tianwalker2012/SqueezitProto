//
//  EZScheduledDay.m
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledDay.h"
#import "MScheduledDay.h"
#import "EZCoreAccessor.h"
//I don't want this class to cause memory to full.
//So What I will do?
//I will try to make get the availableTask a extraEfforts.
//Why not just make it a specified flag.
//This is a good idea. Go with it

@implementation EZScheduledDay
@synthesize scheduledDate, PO;

- (id) initWithVO:(EZScheduledDay*) schDay
{
    self = [super init];
    scheduledDate = schDay.scheduledDate;
    self.PO = schDay.PO;
    return self;
}

- (id) cloneVO
{
    return [[EZScheduledDay alloc] initWithVO:self];
}

- (id) initWithPO:(MScheduledDay*)mtk
{
    self = [super init];
    self.scheduledDate = mtk.scheduledDate;
    self.PO = mtk;
    return self;
}

- (MScheduledDay*) populatePO:(MScheduledDay*)po
{
    po.scheduledDate = self.scheduledDate;
    return po;
}

- (MScheduledDay*) createPO
{
    if(self.PO == nil){
        self.PO = (MScheduledDay*)[[EZCoreAccessor getInstance] create:[MScheduledDay class]];
    }
    return [self populatePO:self.PO];
}




//Will fetch the value from the database again.
- (void) refresh{
    if(self.PO){
        [self.PO.managedObjectContext refreshObject:self.PO mergeChanges:NO];
        self.scheduledDate = self.PO.scheduledDate;
    }
}


@end
