//
//  EZViewWrapper.h
//  SqueezitProto
//
//  Created by Apple on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZViewWrapper : NSObject

- (id) initWithView:(UIView*)view identifier:(NSString*)idt;

@property (strong, nonatomic) UIView* view;
@property (assign, nonatomic) BOOL isInCache;
@property (strong, nonatomic) NSString* identifier;

//Just act as a value carrier.
@property (strong, nonatomic) UIViewController* controller;

@end
