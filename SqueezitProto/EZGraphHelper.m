//
//  EZGraphHelper.m
//  SqueezitProto
//
//  Created by Apple on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZGraphHelper.h"
#import "Constants.h"

@implementation EZGraphHelper

@end

@implementation EZLabelFormatter

- (NSString *)stringFromNumber:(NSNumber *)number
{
    EZDEBUG(@"passing number:%@", number);
    return [NSString stringWithFormat:@"Label:%i", number.integerValue];
}
- (NSNumber *)numberFromString:(NSString *)string
{
    EZDEBUG(@"Who called me?");
    return [[NSNumber alloc] initWithInt:-1];
}

@end