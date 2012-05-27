//
//  EZScheduledDay.h
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//It represent scheduled work for one particular day
// There is a hunch, I may need ot use NSMutableArray, because I may need to modify it for 
// The change. 
@interface EZScheduledDay : NSObject {
    NSDate* scheduledDay;
    NSArray* scheduledTasks;
}

@property (strong, nonatomic) NSDate* scheduledDay;
@property (strong, nonatomic) NSArray* scheduledTasks;

@end
