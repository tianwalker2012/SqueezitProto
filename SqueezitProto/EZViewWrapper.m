//
//  EZViewWrapper.m
//  SqueezitProto
//
//  Created by Apple on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZViewWrapper.h"

@implementation EZViewWrapper
@synthesize view, identifier, isInCache, controller;

- (id) initWithView:(UIView *)vw identifier:(NSString *)idt
{
    self = [super init];
    self.view = vw;
    self.identifier = idt;
    isInCache = false;
    return self;
}


@end
