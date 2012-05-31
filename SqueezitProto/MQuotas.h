//
//  MZQuotas.h
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MQuotas : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * cycleType;
@property (nonatomic, retain) NSNumber * quotasPerCycle;
@property (nonatomic, retain) NSNumber * maximumPerDay;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * cycleStartDate;
@property (nonatomic, retain) NSNumber * cycleLength;

@end
