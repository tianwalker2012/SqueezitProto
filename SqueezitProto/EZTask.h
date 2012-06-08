//
//  EZTask.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "EZTaskHelper.h"

@class EZQuotas, MTask;

@interface EZTask : NSObject<EZValueObject> {
    NSString* name;

    //In minutes, which mean minimum duration.
    //If it is zero mean, I only need a notification for this thing. Doesn't require available time span.
    int duration;
    
    //Purpos of the max duration is for some task will try to grab more time then minimum time.
    int maxDuration;
    
    //The purpose of this field is that, I want this task to start at my specified time.
    BOOL fixedTime;
    
    //The purpose of this field is that, I want this task to start at my specified date.
    //Make the normal functionality possible
    BOOL fixedDate;
    
    //The requirement for the environment
    EZEnvironmentTraits envTraits;
    
    NSDate* time;
    NSDate* date;
    
    //For important task, I have minimum time quota on some period of time
    EZQuotas* quotas;

}

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int duration;
@property (assign, nonatomic) int maxDuration;
@property (assign, nonatomic) BOOL fixedTime;
@property (assign, nonatomic) BOOL fixedDate;
@property (strong, nonatomic) NSDate* time;
@property (strong, nonatomic) NSDate* date;
@property (assign, nonatomic) EZEnvironmentTraits envTraits;
@property (strong, nonatomic) EZQuotas* quotas;
@property (strong, nonatomic) NSString* soundName;
@property (strong, nonatomic) MTask* PO;
@property (strong, nonatomic) NSDate* createdTime;


- (id) initWithName:(NSString*) nm duration:(int)dur maxDur:(int)mdur envTraits:(EZEnvironmentTraits)traits;

- (BOOL) isEqual:(EZTask*)task;

- (id) initWithPO:(MTask*)mtk;

- (MTask*) createPO;

- (MTask*) populatePO:(MTask*)po;

@end
