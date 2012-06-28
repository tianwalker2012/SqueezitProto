//
//  EZLimitMap.m
//  SqueezitProto
//
//  Created by Apple on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZLRUMap.h"
#import "EZQueue.h"
#import "Constants.h"


@interface EZLRUMap()
{
    EZQueue* keyQueue;
    NSMutableDictionary* maps;
}


@end

@implementation EZLRUMap
@synthesize limit;

- (id) initWithLimit:(NSInteger)lmt
{
    self = [super init];
    limit = lmt;
    keyQueue = [[EZQueue alloc] initWithLimit:limit];
    maps = [[NSMutableDictionary alloc] initWithCapacity:limit];
    return self;
}

- (id) removeObjectForKey:(id)aKey
{
    id res = [maps objectForKey:aKey];
    [maps removeObjectForKey:aKey];
    return res;
}


//Now I can handle the cases even the key already exist.
- (id) setObject:(id)obj forKey:(id)aKey
{
    id res = nil;
    if([self getObjectForKey:aKey]){
        [keyQueue removeObject:aKey];
    }
    [maps setObject:obj forKey:aKey];
    id removedKey = [keyQueue enqueue:aKey];
    if(removedKey){
        EZDEBUG(@"Find removed key:%@",removedKey);
        res = [maps objectForKey:removedKey];
        [maps removeObjectForKey:removedKey];
    }
    return res;
}
- (id) getObjectForKey:(id)aKey
{
    if([keyQueue isContain:aKey]){
        [keyQueue removeObject:aKey];
        [keyQueue enqueue:aKey];
    }
    return [maps objectForKey:aKey];
}

- (void) removeAllObjects
{
    [maps removeAllObjects];
    [keyQueue removeAllObjects];
    
}

@end
