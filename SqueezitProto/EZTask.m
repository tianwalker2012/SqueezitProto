//
//  EZTask.m
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTask.h"
#import "MTask.h"
#import "EZQuotas.h"
#import "EZCoreAccessor.h"


@implementation EZTask
@synthesize name, duration, maxDuration, fixedTime, fixedDate, time, date, envTraits, quotas, soundName, PO, createdTime;

//Cool implementation. Keep the redundency code to minimum. 
- (id) initWithName:(NSString*) nm
{
    return [self initWithName:nm duration:20 maxDur:20 envTraits:0];
}

- (id) cloneVO
{
    EZTask* res = [[EZTask alloc] initWithVO:self];
    return res;
}

- (id) initWithVO:(EZTask*)valueObj
{
    self = [super init];
    self.name = valueObj.name;
    self.duration = valueObj.duration;
    self.maxDuration = valueObj.maxDuration;
    self.envTraits = valueObj.envTraits;
    self.soundName = valueObj.soundName;
    self.createdTime = valueObj.createdTime;
    self.quotas = valueObj.quotas.cloneVO;
    self.PO = valueObj.PO;
    return self;
}

- (id) initWithName:(NSString*) nm duration:(int)dur maxDur:(int)mdur envTraits:(NSUInteger)traits
{
    self = [super init];
    self.name = nm;
    self.duration = dur;
    self.maxDuration = mdur;
    self.envTraits = traits;
    //Task can choose it's own name, I love it.
    self.soundName = UILocalNotificationDefaultSoundName;
    self.createdTime = [NSDate date];
    return self;

}

// Will use utID later.
// Now will only use name to compare.
// I love it. 
- (BOOL) isEqual:(EZTask*)task
{
    return [self.PO.objectID isEqual:task.PO.objectID];
}


- (void) refresh
{
    //EZDEBUG(@"Task refresh get called");
    if(self.PO){
        [self.PO.managedObjectContext refreshObject:self.PO mergeChanges:NO];
        self.name = self.PO.name;
        self.createdTime = self.PO.createdTime;
        self.duration = self.PO.duration.intValue;
        self.maxDuration = self.PO.maxDuration.intValue;
        self.envTraits = self.PO.envTraits.unsignedIntegerValue;
        if(PO.quotas){
            self.quotas = [[EZQuotas alloc] initWithPO:PO.quotas];
        }
    }
}

- (id) initWithPO:(MTask*)mtk
{
    self = [super init];
    self.PO = mtk;
    self.name = mtk.name;
    self.duration = mtk.duration.intValue;
    self.maxDuration = mtk.maxDuration.intValue;
    self.envTraits = mtk.envTraits.unsignedIntegerValue;
    if(mtk.quotas){
        self.quotas = [[EZQuotas alloc] initWithPO:mtk.quotas];
    }
    self.createdTime = mtk.createdTime;
    return self;
}

//Should I refresh the Value everyTime I get called?
//Of course.
- (MTask*) createPO
{
    //EZDEBUG(@"EZTask Create PO get called");
    if(self.PO == nil){
        EZCoreAccessor* accessor = [EZCoreAccessor getInstance];
        self.PO = (MTask*)[accessor create:[MTask class]];
        //EZDEBUG(@"created by accessor is:%@",self.PO);
    }
    return [self populatePO:self.PO];
}

- (MTask*) populatePO:(MTask*)po
{
    po.name = self.name;
    po.duration = [[NSNumber alloc] initWithInt:self.duration];
    po.maxDuration = [[NSNumber alloc] initWithInt:self.maxDuration];
    po.envTraits = [[NSNumber alloc] initWithUnsignedInteger:self.envTraits];
    if(self.quotas){
        if(!po.quotas){
            po.quotas = self.quotas.createPO; //CreatePO invoke populate.
        }else{
            [self.quotas populatePO:po.quotas];
        }
    }else{
        po.quotas = nil;
    }
    po.createdTime = self.createdTime;
    return po;
}

@end
