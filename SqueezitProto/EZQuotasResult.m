//
//  EZQuotasResult.m
//  SqueezitProto
//
//  Created by Apple on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZQuotasResult.h"

@implementation EZQuotasResult
@synthesize scheduledTasks, availableDay, exclusiveTasks;

- (id) init
{
    self = [super init];
    self.scheduledTasks = [[NSMutableArray alloc] init]; 
    return self;
}


- (id) init:(NSArray*)schTasks exclusive:(NSArray*)exclusive aDay:(EZAvailableDay*)aDay
{
    self = [super init];
    self.availableDay = aDay;
    self.scheduledTasks = [NSMutableArray arrayWithArray:schTasks];
    self.exclusiveTasks = exclusive;
    return self;
}

@end
