//
//  EZLimitMap.m
//  SqueezitProto
//
//  Created by Apple on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZLimitMap.h"
#import "EZQueue.h"



@interface EZLimitMap()
{
    EZQueue* keyQueue;
    NSMutableDictionary* maps;
}


@end

@implementation EZLimitMap
@synthesize limit;

- (id) initWithLimit:(NSInteger)lmt
{
    self = [super init];
    limit = lmt;
    keyQueue = [[EZQueue alloc] initWithLimit:limit];
    maps = [[NSMutableDictionary alloc] initWithCapacity:limit];
    return self;
}
- (id) setObject:(id)obj forKey:(id)aKey
{
    id res = nil;
    [maps setObject:obj forKey:aKey];
    id removedKey = [keyQueue enqueue:aKey];
    if(removedKey){
        res = [maps objectForKey:removedKey];
        [maps removeObjectForKey:removedKey];
    }
    return res;
}
- (id) getObjectForKey:(id)aKey
{
    return [maps objectForKey:aKey];
}

- (void) removeAllObjects
{
    [maps removeAllObjects];
    [keyQueue removeAllObjects];
    
}

@end
