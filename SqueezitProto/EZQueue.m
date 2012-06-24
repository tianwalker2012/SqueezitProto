//
//  EZQueue.m
//  SqueezitProto
//
//  Created by Apple on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZQueue.h"

@interface EZQueue()
{
    NSMutableArray* queue;
}


@end

@implementation EZQueue
@synthesize limit;

- (id) initWithLimit:(NSInteger)lmt
{
    self = [super init];
    queue = [[NSMutableArray alloc] initWithCapacity:limit];
    limit = lmt;
    return self;
}
- (id) enqueue:(id)obj
{
    id res = nil;
    if(![queue containsObject:obj]){
        [queue addObject:obj];
    }
    if(queue.count > limit){
        res = [queue objectAtIndex:0];
        [queue removeObjectAtIndex:0];
    }
    return res;
}
- (BOOL) isContain:(id)obj
{
    return [queue containsObject:obj];
}

- (void) removeAllObjects
{
    [queue removeAllObjects];
}

@end
