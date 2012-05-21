//
//  EZTask.m
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTask.h"

@implementation EZTask
@synthesize name, description, duration, maxDuration, fixedTime, fixedDate, time, date;

- (id) initWithName:(NSString*) nm description:(NSString*) ds duration:(int)dur
{
    self = [super init];
    self.name = nm;
    self.description = ds;
    self.duration = dur;
    self.maxDuration = dur;
    return self;
}


@end
