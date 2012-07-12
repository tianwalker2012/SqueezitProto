//
//  EZScheduleStats.m
//  SqueezitProto
//
//  Created by Apple on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduleStats.h"

@implementation EZScheduleStats
@synthesize totalTime, statesEnd, statsStart, name, datas;

- (id) initWithName:(NSString*)nm
{
    self = [super init];
    datas = [[NSMutableArray alloc] init];
    name = nm;
    return self;
}

@end
