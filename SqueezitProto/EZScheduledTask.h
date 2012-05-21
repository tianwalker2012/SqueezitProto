//
//  EZScheduledTask.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZTask;

@interface EZScheduledTask : NSObject {
    NSDate* startTime;
    int duration;
    EZTask* task;
}

@property(strong, nonatomic) NSDate* startTime;
@property(strong, nonatomic) EZTask* task;
@property(assign, nonatomic) int duration;

@end
