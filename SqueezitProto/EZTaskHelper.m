//
//  EZTaskHelper.m
//  SqueezitProto
//
//  Created by Apple on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTaskHelper.h"
#import "EZAvailableTime.h"
#import "EZAvailableDay.h"
#import "EZQuotas.h"
#import "EZGlobalLocalize.h"
#import "EZArray.h"

@implementation NSString(EZPrivate)

//Implement the traditional trim, space new line etc...
- (NSString*) trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end


@implementation NSArray(EZPrivate)

- (NSArray*) filter:(FilterOperation)opts
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:self.count];
    for(id obj in self){
        if(opts(obj)){
            [res addObject:obj];
        }
    }
    return res;
}

@end

@implementation NSDate(EZPrivate)

- (NSInteger) convertDays
{
    return [self timeIntervalSince1970]/SecondsPerDay;
}

- (BOOL) isPassed:(NSDate*)date
{
    return [self timeIntervalSinceDate:date] <= 0;
}

- (BOOL) InBetween:(NSDate*)start end:(NSDate*)end
{
    NSTimeInterval selfInt = [self timeIntervalSince1970];
    return selfInt > [start timeIntervalSince1970] && selfInt < [end timeIntervalSince1970];
}

- (BOOL) InBetweenDays:(NSDate*)start end:(NSDate*)end
{
    BOOL res = false;
    int curDay = [self convertDays];
    int startDay = [start convertDays];
    int endDay = [end convertDays];
    res = (curDay >= startDay && curDay <= endDay); 
    return res;
}

- (NSDate*) adjustDays:(int)days
{
    int curDays = [self convertDays];
    curDays = curDays + days;
    return [[NSDate alloc] initWithTimeIntervalSince1970:curDays*SecondsPerDay];
}

- (NSDate*) adjustMinutes:(int)minutes
{
    NSTimeInterval seconds = [self timeIntervalSince1970];
    seconds += minutes*60;
    return [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
}

- (EZWeekDayValue) weekDay
{
    return 1 << ([self orgWeekDay] - 1);
}

- (int) monthDay
{
    return [[self stringWithFormat:@"dd"] intValue];
}

- (int) orgWeekDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    uint unitFlags = NSWeekdayCalendarUnit;
    NSDateComponents* dcomponent = [calendar components:unitFlags fromDate:self];
    return [dcomponent weekday];
}


- (BOOL) equalWith:(NSDate*)date format:(NSString*)format
{
    return [[self stringWithFormat:format] compare:[date stringWithFormat:format]] == NSOrderedSame;
}

+ (NSDate*) stringToDate:(NSString*)format dateString:(NSString*)dateStr
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df dateFromString:dateStr];
}

- (NSString*) stringWithFormat:(NSString*)format
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df stringFromDate:self];
}

@end

@implementation EZTaskHelper

+ (int) getMonthLength:(NSDate*)date
{
    int month = [[date stringWithFormat:@"MM"] intValue];
    if(month == 2){
        NSString* year = [date stringWithFormat:@"yyyy"];
        NSDate* endFeb = [NSDate stringToDate:@"yyyyMMdd" dateString:[NSString stringWithFormat:@"%@0228",year]];
        NSDate* addedDay = [endFeb adjustDays:1];
        if([addedDay monthDay] == 29){
            return 29;
        }
        return 28;
        
    } else {
        if(month > 7){
            return (month % 2) == 1 ? 30:31; 
        }else{
            return (month % 2) == 1 ? 31:30;
        }
    }
}

+ (int) calcTime:(EZAvailableDay*)aDay envTraits:(int)envTraits
{
    int res = 0;
    for(EZAvailableTime* avTime in aDay.availableTimes){
       if((avTime.envTraits & envTraits) == envTraits){
            res += avTime.duration;
        }
    }
    return res;
}

//It could have many cases, so I only have a natural week and a customized cases figure out so far
+ (NSDictionary*) calcHistoryBegin:(EZQuotas*)quotas date:(NSDate*)date
{
    NSDate* res;
    switch (quotas.cycleType) {
        case CustomizedCycle: {
            int beginDay = [quotas.cycleStartDay convertDays];
            int endDay = [date convertDays];
            int gapDays = (endDay - beginDay) % quotas.cycleLength;
            res = [date adjustDays:-gapDays];
            break;
        }
        case WeekCycle: {
            int currentWeekDay = [date orgWeekDay] - 1;
            res = [date adjustDays:-currentWeekDay];
            break;
        }
        case MonthCycle: {
            int monthDay = [date monthDay] - 1;
            res = [date adjustDays:-monthDay];
        }
        default:
            EZDEBUG(@"%i not implemented yet",quotas.cycleType);
            break;
    }
    
    //If actual start day later than cycle days, then the 
    //History data will collect from the actual start day.
    int paddingDay = 0;
    if([res convertDays] < [quotas.startDay convertDays]){
        paddingDay = [quotas.startDay convertDays] - [res convertDays];
        res = quotas.startDay;
        EZDEBUG(@"Padding day:%i",paddingDay);
    }

    return [NSDictionary dictionaryWithObjectsAndKeys:res, @"beginDate", [NSNumber numberWithInt:paddingDay], @"padDays", nil];
}


//Calculate how many days still left for in current cycle
+ (int) cycleRemains:(EZQuotas*)quotas date:(NSDate*)date
{
    int res = 0;
    switch (quotas.cycleType) {
        case CustomizedCycle: {
            int beginDay = [quotas.cycleStartDay convertDays];
            int endDay = [date convertDays];
            int gapDays = (endDay - beginDay) % quotas.cycleLength;
            res = quotas.cycleLength - gapDays;
            break;
        }
        case WeekCycle: {
            int currentWeekDay = [date orgWeekDay];
            res = 8 - currentWeekDay;
            break;
        }
        case MonthCycle: {
            int monthDay = [date monthDay] - 1;
            res = [self getMonthLength:date] - monthDay;
        }
        default:
            EZDEBUG(@"%i not implemented yet",quotas.cycleType);
            break;
    }
    
    return res;

}

//If flag can be divide cleanly from envFlags
BOOL isContained(NSUInteger flag, NSUInteger envFlags)
{
    if((envFlags/flag)*flag == envFlags){
        return true;
    }
    return false;
}

NSUInteger combineFlags(NSUInteger flag, NSUInteger envFlags)
{
    return envFlags*flag;
}
        
NSUInteger findFractor(NSUInteger target, EZArray* fractors)
{
    for(int pos = 0; pos < fractors.length; ++pos){
        if(isContained(fractors.uarray[pos], target)){
            return fractors.uarray[pos];
        }
    }
    return 0;
}


//Assume it also sorted.
NSUInteger findNextFlag(EZArray* flags)
{
    NSUInteger begin = flags.uarray[flags.length-1] + 2;
    for(NSUInteger i = begin; i < NSUIntegerMax ; i += 2){
        if(findFractor(i, flags) == 0){
            return i;
        }
    }
    //Reach the maximum
    return 0;
}


+ (NSString*) envTraitsToString:(NSInteger)envTraits
{
    if(envTraits == EZ_ENV_NONE){
        return EZLocalizedString(@"None", nil);
    }
    NSMutableString* res = [[NSMutableString alloc] init];
    
    //EZ_ENV_NONE = 0,
    //EZ_ENV_FITTING = 1,
    //EZ_ENV_READING = 2,
    //EZ_ENV_LISTENING = 4,
    //EZ_ENV_SOCIALING = 8, 
    //EZ_ENV_FLOWING = 16,
    
    if((EZ_ENV_FITTING & envTraits) == EZ_ENV_FITTING){
        [res appendString:EZLocalizedString(@" FITTING", nil)];
    }
    
    if((EZ_ENV_READING & envTraits) == EZ_ENV_READING){
        [res appendString:EZLocalizedString(@" READING", nil)];
    }

    if((EZ_ENV_LISTENING & envTraits) == EZ_ENV_LISTENING){
        [res appendString:EZLocalizedString(@" LISTENING", nil)];
    }

    if((EZ_ENV_FLOWING & envTraits) == EZ_ENV_FLOWING){
        [res appendString:EZLocalizedString(@" FLOWING", nil)];
    }

    if((EZ_ENV_SOCIALING & envTraits) == EZ_ENV_SOCIALING){
        [res appendString:EZLocalizedString(@" SOCIALING", nil)];
    }

    return res;
}

@end
