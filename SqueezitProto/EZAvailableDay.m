//
//  EZAvailableDay.m
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvailableDay.h"
#import "EZTaskHelper.h"
#import "EZAvailableTime.h"
#import "MAvailableDay.h"
#import "EZCoreAccessor.h"
#import "MAvailableTime.h"

@implementation EZAvailableDay
@synthesize date, assignedWeeks, availableTimes, name, PO, displayOrder;

- (id) init
{
    self = [super init];
    availableTimes = [[NSMutableArray alloc] init];
    return self;
}

- (id) initWithVO:(EZAvailableDay*)day
{
    self = [super init];
    self.availableTimes = [[NSMutableArray alloc] initWithCapacity:day.availableTimes.count];
    self.name = day.name;
    self.assignedWeeks = day.assignedWeeks;
    self.displayOrder = day.displayOrder;
    for(EZAvailableTime* time in day.availableTimes){
        [self.availableTimes addObject:time.cloneVO];
    }
    self.PO = day.PO;
    return self;
}

- (id) cloneVO
{
    return [[EZAvailableDay alloc] initWithVO:self];
}

- (id) initWithName:(NSString*)nm weeks:(int)aw
{
    self = [super init];
    self.availableTimes = [[NSMutableArray alloc] init];
    self.name = nm;
    self.assignedWeeks = aw;
    self.displayOrder = 0;
    return self;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"EZAvailableDay,name:%@,weekAssignd:%i,Date:%@",name,assignedWeeks,(date != nil?[date stringWithFormat:@"yyyy-MM-dd"]:@"null")];
}

- (void) refresh
{
    [PO.managedObjectContext refreshObject:PO mergeChanges:YES];
    [self populateWithPO:PO];
}

- (void) populateWithPO:(MAvailableDay*)mtk
{
    self.name = mtk.name;
    self.date = mtk.date;
    self.assignedWeeks = mtk.assignedWeeks.intValue;
    self.PO = mtk;
    self.displayOrder = mtk.displayOrder.integerValue;
    self.availableTimes = [[NSMutableArray alloc] initWithCapacity:[mtk.availableTimes count]];
    for(MAvailableTime* mat in mtk.availableTimes){
        [self.availableTimes addObject:[[EZAvailableTime alloc] initWithPO:mat]];
    }
}

- (id) initWithPO:(MAvailableDay*)mtk
{
    self = [super init];
    self.name = mtk.name;
    self.date = mtk.date;
    self.assignedWeeks = mtk.assignedWeeks.intValue;
    self.PO = mtk;
    self.displayOrder = mtk.displayOrder.integerValue;
    self.availableTimes = [[NSMutableArray alloc] initWithCapacity:[mtk.availableTimes count]];
    for(MAvailableTime* mat in mtk.availableTimes){
        [self.availableTimes addObject:[[EZAvailableTime alloc] initWithPO:mat]];
    }
    return self;
}

- (MAvailableDay*) createPO
{
    if(!self.PO){
        self.PO = (MAvailableDay*)[[EZCoreAccessor getInstance] create:[MAvailableDay class]];
    }
    return [self populatePO:self.PO];
}

- (void) removeByID:(NSManagedObjectID*)oid array:(NSMutableArray*)list
{
    for(int i = 0; i < list.count; i++){
        NSManagedObject* obj = [list objectAtIndex:i];
        if([obj.objectID isEqual:oid]){
            [list removeObjectAtIndex:i];
        }
    }
}


- (MAvailableDay*) populatePO:(MAvailableDay*)po
{
    po.name = self.name;
    po.date = self.date;
    po.assignedWeeks = [[NSNumber alloc] initWithInt:self.assignedWeeks];
    po.displayOrder = [[NSNumber alloc] initWithInt:self.displayOrder];
    NSMutableArray* mutTimes = [NSMutableArray arrayWithArray:po.availableTimes.allObjects];
    for(EZAvailableTime* avt in self.availableTimes){
        if(!avt.PO){
            //The first time a object created, so need to add it to the persitent. 
            [po addAvailableTimesObject:avt.createPO];
        }else{
            //Existed, only need to populate the value
            //But need to remove the objectID
            //Because all the remaining objectID will 
            //Get removed later.
            [self removeByID:avt.createPO.objectID array:mutTimes];
        }
    }
    if(mutTimes.count > 0){
        [po removeAvailableTimes:[NSSet setWithArray:mutTimes]];
    }
    return po;
}

@end
