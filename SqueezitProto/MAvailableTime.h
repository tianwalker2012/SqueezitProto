//
//  MZAvailableTime.h
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MAvailableTime : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * envTraits;
@property (nonatomic, retain) NSNumber * duration;

@end
