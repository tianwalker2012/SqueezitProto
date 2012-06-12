//
//  EZArray.m
//  SqueezitProto
//
//  Created by Apple on 12-6-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZArray.h"
#import "Constants.h"

@implementation EZArray
@synthesize uarray, length;

- (id) initWithCapacity:(int)len
{
    self = [super init];
    uarray = malloc(len*sizeof(NSUInteger));
    length = len;
    memset((void*)uarray, 0, length*sizeof(NSUInteger));
    return self;
}

- (id) initWithArray:(NSUInteger*)array length:(int)len
{
    self = [super init];
    uarray = malloc(len*sizeof(NSUInteger));
    length = len;
    memcpy(uarray, array, length*sizeof(NSUInteger));
    return self;
}

- (void) dealloc 
{
    EZDEBUG(@"free array:%i", (int)uarray);
    free(uarray);
}

@end
