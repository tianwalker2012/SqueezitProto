//
//  EZTask.m
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTask.h"

@implementation EZTask
@synthesize name, duration, maxDuration, fixedTime, fixedDate, time, date, envTraits, quotas;

- (id) initWithName:(NSString*) nm duration:(int)dur maxDur:(int)mdur envTraits:(EZEnvironmentTraits)traits
{
    self = [super init];
    self.name = nm;
    self.duration = dur;
    self.maxDuration = mdur;
    self.envTraits = traits;
    return self;

}

// Will use utID later.
// Now will only use name to compare.
// I love it. 
- (BOOL) isEqual:(EZTask*)task
{
    return [self.name compare:task.name] == NSOrderedSame;
}

@end
