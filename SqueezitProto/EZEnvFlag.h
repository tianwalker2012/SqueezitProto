//
//  EZEnvFlag.h
//  SqueezitProto
//
//  Created by Apple on 12-6-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZTaskHelper.h"

//What the purpose of this class?
//Initially, I setup to use the enumeration as the environment flag.
//As time goes by, I feel it servely limit the usage of the system. 
//Or just a bad feeling.
//Today I decided to do something about it.
//I will use prime number to do my job. 
@class MEnvFlag;
@interface EZEnvFlag : NSObject<EZValueObject>

@property (assign, nonatomic) NSUInteger flag;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) BOOL deleted;
@property (strong, nonatomic) MEnvFlag* PO;

- (EZEnvFlag*) initWithName:(NSString*)nm flag:(NSUInteger)fg;

@end
