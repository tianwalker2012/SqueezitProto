//
//  EZScheduledDay.h
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZTaskHelper.h"

//It represent scheduled work for one particular day
// There is a hunch, I may need ot use NSMutableArray, because I may need to modify it for 
// The change. 
@class MScheduledDay;
@interface EZScheduledDay : NSObject<EZValueObject>

@property (strong, nonatomic) NSDate* scheduledDate;
@property (strong, nonatomic) MScheduledDay* PO;
//@property (strong, nonatomic) NSArray* scheduledTasks;

@end
