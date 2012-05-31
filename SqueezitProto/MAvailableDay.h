//
//  MAvailableDay.h
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAvailableTime;

@interface MAvailableDay : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * assignedWeeks;
@property (nonatomic, retain) NSSet *availableTimes;
@end

@interface MAvailableDay (CoreDataGeneratedAccessors)

- (void)addAvailableTimesObject:(MAvailableTime *)value;
- (void)removeAvailableTimesObject:(MAvailableTime *)value;
- (void)addAvailableTimes:(NSSet *)values;
- (void)removeAvailableTimes:(NSSet *)values;

@end
