//
//  EZScheduleStats.h
//  SqueezitProto
//
//  Created by Apple on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZScheduleStats : NSObject

//In minutes
@property (assign, nonatomic) NSInteger totalTime;

@property (strong, nonatomic) NSDate* statsStart;
@property (strong, nonatomic) NSDate* statesEnd;

@property (strong, nonatomic) NSString* name;

@property (strong, nonatomic) NSMutableArray* datas;

- (id) initWithName:(NSString*)nm;

@end
