//
//  EZQuotas.h
//  SqueezitProto
//
//  Created by Apple on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//The one week, two week, could safely represented by customized cyle.
typedef enum CycleType {
    MonthCycle = 1,
    BiMonthCyle = 2,
    TriMonthCycle = 3,
    HalfYearCycle = 4,
    OneYearCycle = 5,
    WeekCycle = 6,
    CustomizedCycle = 7
} CycleType;

@interface EZQuotas : NSObject {
    //How much have to complete by one cycle 
    int quotasPerCycle;
    
    //What's the cycle week, month, or other artifacial cycle 
    CycleType cycleType;
    
    //Pervent you from over work, if not set, they is no limit
    //Will occpy all your available time.
    int maximumPerDay;
    
    //When it was started, from the day it was created.
    NSDate* startDay;
    
    //For the customer quotas cycle, like 40 days cycle, there will be a date for the cycle beginning
    //Based on this date and current date and cycleLength will get how many days we need to trace back for history date. 
    NSDate* cycleStartDay;
    
    //For customized cycle will use this value.
    //It seems cycle type not necessary.
    //There are necessary. For example my activity prefer natural month.
    int cycleLength;
}

@property (assign, nonatomic) int quotasPerCycle;
@property (assign, nonatomic) CycleType cycleType;
@property (assign, nonatomic) int maximumPerDay;
@property (strong, nonatomic) NSDate* startDay;
@property (strong, nonatomic) NSDate* cycleStartDay;
@property (assign, nonatomic) int cycleLength;

- (id) init:(NSDate*)sd quotas:(int)quotas type:(CycleType)type cycleStartDate:(NSDate*)cycleDate cycleLength:(int)length;

@end
