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

- (id) initWithName:(NSString*) nm duration:(int)dur maxDur:(int)mdur envTraits:(EZEnvironmentTraits)traits
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


- (id) initWithPO:(MTask*)mtk
{
    self = [super init];
    self.PO = mtk;
    self.name = mtk.name;
    self.duration = mtk.duration.intValue;
    self.maxDuration = mtk.maxDuration.intValue;
    self.envTraits = mtk.envTraits.intValue;
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
    po.envTraits = [[NSNumber alloc] initWithInt:self.envTraits];
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
