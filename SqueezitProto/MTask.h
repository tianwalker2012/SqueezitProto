//
//  MZTask.h
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MQuotas, EZTask;

@interface MTask : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * envTraits;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * maxDuration;
@property (nonatomic, retain) NSDate* createdTime;
@property (nonatomic, retain) MQuotas*quotas;


@end
