//
//  EZTaskHelper.h
//  SqueezitProto
//
//  Created by Apple on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface NSDate(EZPrivate) 

- (NSInteger) convertDays;

- (EZWeekDayValue) weekDay;

- (int) orgWeekDay;

- (int) monthDay;

+ (NSDate*) stringToDate:(NSString*)format dateString:(NSString*)dateStr;

- (NSString*) stringWithFormat:(NSString*)format;

- (NSDate*) adjustDays:(int)days;
//True mean they are equal with the format, False mean not equal. 
- (BOOL) equalWith:(NSDate*)date format:(NSString*)format;

//Check if the date fall inbetween the specified start and end.
//It will including the stat and end date.
- (BOOL) InBetweenDays:(NSDate*)start end:(NSDate*)end;

@end

@class EZAvailableDay, EZQuotas;

@interface EZTaskHelper : NSObject

//envTraits will be EZEnvironmentTraits combiation
//This is minutes, mean how many minutes left
+ (int) calcTime:(EZAvailableDay*)aDay envTraits:(int)envTraits;

//Calculate the beginning date for current cycle,
//So that we have the information that from when we start collect history data
//We collect history data for the purpose of calculating the remaining time
+ (NSDate*) calcHistoryBegin:(EZQuotas*)quotas date:(NSDate*)date;

//Calculate how many days still left for in current cycle
+ (int) cycleRemains:(EZQuotas*)quotas date:(NSDate*)date;

+ (int) getMonthLength:(NSDate*)date;

@end