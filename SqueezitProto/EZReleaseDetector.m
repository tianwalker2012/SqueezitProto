//
//  EZReleaseDetector.m
//  SqueezitProto
//
//  Created by Apple on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZReleaseDetector.h"
#import "Constants.h"
#import "EZTaskHelper.h"

@implementation EZReleaseDetector
@synthesize name, block;

- (id) initWithName:(NSString*)nm hasStackTrace:(BOOL)stackTrace
{
    self = [super init];
    self.name = [NSString stringWithFormat:@"%@",nm];
    allocatedTime = [NSDate date];
    hasStackTrace = stackTrace;
    return self;
}

- (void) dealloc
{
    //NSDate* now = [NSDate date];
    if(block){
        block();
    }
    EZDEBUG(@"%@ get dealloc, after %f seconds",name, [allocatedTime timeIntervalSinceNow]);
    EZCONDITIONLOG(hasStackTrace,@"stackTrace:%@",[NSThread callStackSymbols]);
}

@end
