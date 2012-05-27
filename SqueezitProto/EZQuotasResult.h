//
//  EZQuotasResult.h
//  SqueezitProto
//
//  Created by Apple on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EZAvailableDay;

//This class only serve as a tulip.
//The purpose to use it is to make my code clean and readable. 
//The purpose to have a clean code is to enjoy the programming.
@interface EZQuotasResult : NSObject {
    NSArray* exclusiveTasks;
    NSArray* schduledTasks;
    EZAvailableDay* availableDay;
}

- (id) init:(NSArray*)schTasks exclusive:(NSArray*)exclusive aDay:(EZAvailableDay*)aDay;

@property (strong, nonatomic) NSArray* exclusiveTasks;
@property (strong, nonatomic) NSArray* scheduledTasks;
@property (strong, nonatomic) EZAvailableDay* availableDay;

@end
