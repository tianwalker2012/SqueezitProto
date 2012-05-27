//
//  EZAvailableDay.m
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvailableDay.h"
#import "EZTaskHelper.h"
#import "EZAvailableTime.h"

@implementation EZAvailableDay
@synthesize date, assignedWeeks, availableTimes, name;

- (id) init
{
    self = [super init];
    availableTimes = [[NSMutableArray alloc] init];
    return self;
}

- (id) initWithName:(NSString*)nm weeks:(int)aw
{
    self = [super init];
    availableTimes = [[NSMutableArray alloc] init];
    self.name = nm;
    self.assignedWeeks = aw;
    return self;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"EZAvailableDay,name:%@,weekAssignd:%i,Date:%@",name,assignedWeeks,(date != nil?[date stringWithFormat:@"yyyy-MM-dd"]:@"null")];
}

- (id) duplicate
{
    EZAvailableDay* res = [[EZAvailableDay alloc] init];
    res.name = self.name;
    res.date = self.date;
    res.assignedWeeks = self.assignedWeeks;
    for(EZAvailableTime* time in self.availableTimes){
        [res.availableTimes addObject:[time duplicate]];
    }
    return res;
}

@end
