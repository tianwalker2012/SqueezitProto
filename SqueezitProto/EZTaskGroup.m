//
//  EZTaskList.m
//  SqueezitProto
//
//  Created by Apple on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTaskGroup.h"
#import "MTaskGroup.h"
#import "MTask.h"
#import "EZCoreAccessor.h"
#import "EZTask.h"
#import "EZCoreHelper.h"

@implementation EZTaskGroup
@synthesize name, createdTime, tasks, PO, displayOrder;

- (id) init
{
    self = [super init];
    self.tasks = [[NSMutableArray alloc] init];
    return self;
}

- (id) initWithPO:(MTaskGroup*)mtk
{
    self = [super init];
    self.name = mtk.name;
    self.createdTime = mtk.createdTime;
    self.displayOrder = mtk.displayOrder.intValue;
    self.tasks = [[NSMutableArray alloc] initWithCapacity:[mtk.tasks count]];
    for(MTask* mt in mtk.tasks){
        [self.tasks addObject:[[EZTask alloc] initWithPO:mt]];
    }
    self.PO = mtk;
    return self;
}

- (MTaskGroup*) createPO
{
    if(!self.PO){
        self.PO = (MTaskGroup*)[[EZCoreAccessor getInstance] create:[MTaskGroup class]];
    }
    return [self populatePO:self.PO];
}

- (MTaskGroup*) populatePO:(MTaskGroup*)po
{
    //EZDEBUG(@"I am in TaskGroup populatePO");
    po.name = self.name;
    po.createdTime = self.createdTime;
    po.displayOrder = [[NSNumber alloc] initWithInt:self.displayOrder];
    NSMutableArray* mutArr = [NSMutableArray arrayWithArray:[po.tasks allObjects]];
    for(EZTask* et in self.tasks){
        if(!et.PO){
            //The first time a object created, so need to add it to the persitent. 
            [po addTasksObject:et.createPO];
        }else{
            //Existed, only need to populate the value
            //But need to remove the objectID
            //Because all the remaining objectID will 
            //Get removed later.
            [po addTasksObject:et.createPO];
            [EZCoreHelper removeByID:et.createPO.objectID array:mutArr];
        } 
    }
    if([mutArr count] > 0){
        EZDEBUG(@"Removed %i from TaskGroup:%@",[mutArr count],self.name);
        [po removeTasks:[NSSet setWithArray:mutArr]];
    }
    return po;
    
}

@end
