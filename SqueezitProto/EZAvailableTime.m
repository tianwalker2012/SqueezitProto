//
//  EZAvailableTime.m
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvailableTime.h"

@implementation EZAvailableTime
@synthesize start, duration, envTraits, name;

- (id) init:(NSDate*)st name:(NSString*)nm duration:(int)dur environment:(int)env
{
    self = [super init];
    self.start = st;
    //self.description = ds;
    self.name = nm;
    self.duration = dur;
    self.envTraits = env;
    return self;
}

- (id) init:(EZAvailableTime*)at
{
    self = [super init];
    self.start = at.start;
    self.name = at.name;
    //self.description = at.description;
    self.duration = at.duration;
    self.envTraits = at.envTraits;
    return self;
}

- (id) duplicate
{
    return [[EZAvailableTime alloc] init:self];
}

- (void) adjustStartTime:(int)increasedMinutes
{
    self.start = [[NSDate alloc] initWithTimeInterval:increasedMinutes*60 sinceDate:self.start];
    
}

@end
