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


@interface BlockCarrier : NSObject

- (id) initWithBlock:(EZOperationBlock)bk;

@property (strong, nonatomic) EZOperationBlock block;

- (void) runBlock;

@end

@implementation BlockCarrier
@synthesize block;

- (id) initWithBlock:(EZOperationBlock)bk
{
    self = [super init];
    block = bk;
    return self;
}

- (void) runBlock
{
    if(block){
        block();
    }
}

@end

NSString* doubleString(NSString* str)
{
    return [NSString stringWithFormat:@"%@%@", str, str];
}

@implementation NSString(EZPrivate)

//Implement the traditional trim, space new line etc...
- (NSString*) trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSInteger) hexToInt
{
    return strtoul([self cStringUsingEncoding:NSASCIIStringEncoding], 0, 16);
}

@end

@implementation NSObject(EZPrivate)

- (void) performBlock:(EZOperationBlock)block withDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(executeBlock:) withObject:block afterDelay:delay];
}

- (void) executeBlock:(EZOperationBlock)block
{
    if(block){
        block();
    }
}

//If Most of the time it is ok
- (void) executeBlockInBackground:(EZOperationBlock)block inThread:(NSThread *)thread
{
    //[EZTaskHelper executeBlockInBG:block];
    BlockCarrier* bc = [[BlockCarrier alloc] initWithBlock:block];
    if(thread == nil){
        [bc performSelectorInBackground:@selector(runBlock) withObject:nil];
    }else{
        [bc performSelector:@selector(runBlock) onThread:thread withObject:nil waitUntilDone:NO];
    }
}

- (void) executeBlockInMainThread:(EZOperationBlock)block
{
    [EZTaskHelper executeBlockInMain:block];
}

@end


@implementation UIView(EZPrivate)

- (void) setLeft:(CGFloat)distance
{
    //EZDEBUG(@"Set left get called");
    CGRect changed = self.frame;
    changed.origin.x = distance;
    [self setFrame:changed];
}

- (CGFloat) left
{
    //EZDEBUG(@"Return left get called");
    return self.frame.origin.x;
}


- (void) setTop:(CGFloat)distance
{
    CGRect changed = self.frame;
    changed.origin.y = distance;
    [self setFrame:changed];
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setRight:(CGFloat)distance
{
    if(self.superview == nil){
        return;
    }
    
    CGFloat totalWidth = self.superview.bounds.size.width;
    CGRect changed = self.frame;
    CGFloat selfWidth = changed.size.width;
    changed.origin.x = totalWidth - selfWidth - distance;
    [self setFrame:changed];
}

- (CGFloat) right
{
    if(self.superview == nil){
        return 0;
    }

    CGFloat totalWidth = self.superview.bounds.size.width;
    CGRect changed = self.frame;
    CGFloat selfWidth = changed.size.width;
    return totalWidth - (selfWidth + changed.origin.x);
}

- (void) setBottom:(CGFloat)distance
{
    if(self.superview == nil){
        return;
    }
    CGFloat totalHeight = self.superview.bounds.size.height;
    CGRect changed = self.frame;
    CGFloat selfHeight = changed.size.height;
    changed.origin.y = totalHeight - selfHeight - distance;
    [self setFrame:changed];
}

- (UIView*) getCoverView:(NSInteger)tag
{
    return [self viewWithTag:tag];
}

- (UIView*) createCoverView:(NSInteger)tag
{
    UIView* coverView = [[UIView alloc] initWithFrame:self.frame];
    coverView.userInteractionEnabled = false;
    coverView.tag = tag;
    [self addSubview:coverView];
    return coverView;
}

- (CGFloat) bottom
{
    if(self.superview == nil){
        return 0;
    }
    CGFloat totalHeight = self.superview.bounds.size.height;
    CGRect changed = self.frame;
    CGFloat selfHeight = changed.size.height;
    return totalHeight - (selfHeight + changed.origin.y);
}

@end

@implementation UIColor(EZPrivate)

//We support 3Hex like CCC or ccc or 6Hex bcbcbc. etc
+ (UIColor*) createByHex:(NSString*)hexStr
{
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 1;
    if(hexStr.length == 3){
        NSString* redStr = [hexStr substringWithRange:NSMakeRange(0,1)];
        redStr = doubleString(redStr);
        red = redStr.hexToInt/255.0;
        
        NSString* greenStr = [hexStr substringWithRange:NSMakeRange(1,1)];
        greenStr = doubleString(greenStr);
        green = greenStr.hexToInt/255.0;
        
        NSString* blueStr = [hexStr substringWithRange:NSMakeRange(2,1)];
        blueStr = doubleString(blueStr);
        blue = blueStr.hexToInt/255.0;
        
    }else if(hexStr.length == 6){
        NSString* redStr = [hexStr substringWithRange:NSMakeRange(0,2)];
        red = redStr.hexToInt/255.0;
        
        NSString* greenStr = [hexStr substringWithRange:NSMakeRange(2,2)];
        green = greenStr.hexToInt/255.0;
        
        NSString* blueStr = [hexStr substringWithRange:NSMakeRange(4,2)];
        blue = blueStr.hexToInt/255.0;
        
    }else if(hexStr.length == 8){
        NSString* redStr = [hexStr substringWithRange:NSMakeRange(0,2)];
        red = redStr.hexToInt/255.0;
        
        NSString* greenStr = [hexStr substringWithRange:NSMakeRange(2,2)];
        green = greenStr.hexToInt/255.0;
        
        NSString* blueStr = [hexStr substringWithRange:NSMakeRange(4,2)];
        blue = blueStr.hexToInt/255.0;
        
        NSString* alphaStr = [hexStr substringWithRange:NSMakeRange(6,2)];
        alpha = alphaStr.hexToInt/255.0;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString*) toHexString
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    int redInt = red*255;
    int greenInt = green*255;
    int blueInt = blue*255;
    return [NSString stringWithFormat:@"%X%X%X", redInt, greenInt, blueInt]; 
}

@end

@implementation NSArray(EZPrivate)

- (NSArray*) filter:(FilterOperation)opts
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:self.count];
    [self iterate:^(id obj){
        if(opts(obj)){
            [res addObject:obj];
        }
    }];
    return res;
}

- (void) iterate:(IterateOperation) opts
{
    for(int i = 0; i < self.count; i++){
        opts([self objectAtIndex:i]);
    }
}

- (NSArray*) mapcar:(MapCarOperation)opts
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:self.count];
    for(id obj in self){
        id resObj = opts(obj);
        if(resObj){
            [res addObject:resObj];
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

//Get the beginning of this date
- (NSDate*) beginning
{
    return [NSDate stringToDate:@"yyyyMMdd" dateString:[self stringWithFormat:@"yyyyMMdd"]];
}

- (NSDate*) ending
{
    return [self.beginning adjust:SecondsPerDay-1];
}

- (BOOL) InBetweenDays:(NSDate*)start end:(NSDate*)end
{
    NSTimeInterval curDay = self.timeIntervalSince1970/SecondsPerDay;
    NSTimeInterval startDay = start.timeIntervalSince1970/SecondsPerDay;
    NSTimeInterval endDay = end.timeIntervalSince1970/SecondsPerDay;
    return (curDay >= startDay && curDay <= endDay); 
}

- (NSDate*) adjustDays:(int)days
{
    return [self adjust:days * SecondsPerDay]; 
}

//Combine the date with the time. 
//I love this, relentlessly refractor.
//Since I only need minutes precision,
//So I will only combine minutes
- (NSDate*) combineTime:(NSDate*)time
{
    NSString* dateStr = [self stringWithFormat:@"yyyy-MM-dd"];
    NSString* timeStr = [time stringWithFormat:@"HH:mm"];
    NSString* combineStr = [NSString stringWithFormat:@"%@ %@",dateStr,timeStr];
    return [NSDate stringToDate:@"yyyy-MM-dd HH:mm" dateString:combineStr];
}

- (NSDate*) adjustMinutes:(int)minutes
{
    return [self adjust:minutes*60];
}

- (NSComparisonResult) compareTime:(NSDate*)date
{
    NSDate* combinedTime = [self combineTime:date];
    return [self compare:combinedTime];
}

- (NSDate*) adjust:(NSTimeInterval)delta
{
    NSTimeInterval seconds = [self timeIntervalSince1970];
    return [[NSDate alloc] initWithTimeIntervalSince1970:(seconds+delta)];
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
+ (EZCycleResult*) calcHistoryBegin:(EZQuotas*)quotas date:(NSDate*)date
{
    
    NSDate* beginDate;
    switch (quotas.cycleType) {
        case CustomizedCycle: {
            int beginDay = [quotas.cycleStartDay convertDays];
            int endDay = [date convertDays];
            int gapDays = (endDay - beginDay) % quotas.cycleLength;
            beginDate = [date adjustDays:-gapDays];
            //EZDEBUG(@"Cycle start days:%i,endDay:%i,gapDays:%i,beginDate:%@, date:%@",beginDay, endDay, gapDays, [beginDate stringWithFormat:@"yyyyMMdd"], [date stringWithFormat:@"yyyyMMdd"]);
            break;  
        }
        case WeekCycle: {
            int currentWeekDay = [date orgWeekDay] - 1;
            beginDate = [date adjustDays:-currentWeekDay];
            break;
        }
        case MonthCycle: {
            int monthDay = [date monthDay] - 1;
            beginDate = [date adjustDays:-monthDay];
        }
        default:
            EZDEBUG(@"%i not implemented yet",quotas.cycleType);
            break;
    }
    
    //If actual start day later than cycle days, then the 
    //History data will collect from the actual start day.
    int paddingDay = 0;
    if([beginDate convertDays] < [quotas.startDay convertDays]){
        paddingDay = [quotas.startDay convertDays] - [beginDate convertDays];
        beginDate = quotas.startDay;
        EZDEBUG(@"Padding day:%i",paddingDay);
    }

    EZCycleResult* res = [[EZCycleResult alloc] init];
    res.beginDate = beginDate;
    res.paddingDays = paddingDay;
    //EZDEBUG(@"quotas:CyleType:%i, current cycle beginDate:%@, currentDate:%@, paddingDay:%i", quotas.cycleType, [beginDate stringWithFormat:@"yyyyMMdd"],[date stringWithFormat:@"yyyyMMdd"], paddingDay);
    return res;
}

+ (void) innerTaskLoop:(id)__unused object
{
    do{
        @autoreleasepool{
            [[NSRunLoop currentRunLoop] run];
        }
    }while(YES);
}

+ (NSThread*) getBackgroundThread
{
    static NSThread* res;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        res = [[NSThread alloc] initWithTarget:self selector:@selector(innerTaskLoop:) object:nil];
        [res start];
    });
    return res;
}

//This will be executed in the natural background.
//I am afraid, if long time task executed in this will block many things
//Relay on this background.
//Don't necessary.
//Change directly NSObject.
//+ (void) executeBlockInBackground:(EZOperationBlock)block
//{
//    BlockCarrier* bc = [[BlockCarrier alloc] initWithBlock:block];
//    [bc performSelectorInBackground:@selector(runBlock) withObject:nil];
//}

+ (void) executeBlockInBG:(EZOperationBlock)block
{
    BlockCarrier* bc = [[BlockCarrier alloc] initWithBlock:block];
    [bc performSelector:@selector(runBlock) onThread:[EZTaskHelper getBackgroundThread] withObject:nil waitUntilDone:NO];
}

+ (void) executeBlockInMain:(EZOperationBlock)block
{
    BlockCarrier* bc = [[BlockCarrier alloc] initWithBlock:block];
    [bc performSelectorOnMainThread:@selector(runBlock) withObject:nil waitUntilDone:NO];
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

NSUInteger removeFrom(NSUInteger flag, NSUInteger envFlags)
{
    return envFlags/flag;
}

//If flag can be divide cleanly from envFlags
BOOL isContained(NSUInteger flag, NSUInteger envFlags)
{
    if(envFlags % flag){
        return false;
    }
    return true;
}

NSUInteger combineFlags(NSUInteger flag, NSUInteger envFlags)
{
    return envFlags*flag;
}
        
BOOL isPrime(NSUInteger divider)
{
    if(divider == 2){
        return YES;
    }
    NSUInteger half = divider/2;
    for(int i = 2; i <= half; i++){
        if(divider % i){
            continue;
        }else{
            return NO;
        }
    }
    return YES;
}

NSUInteger findPrimeAfter(NSUInteger prime){
    if(prime == 0 || prime == 1){
        return 2;
    }
    NSUInteger odd = prime % 2;
    if(odd){
        prime += 2;
    }else{
        ++prime;
    }
    EZDEBUG(@"Will start at:%i", prime);
    for(NSUInteger i = prime; i < NSUIntegerMax; i += 2){
        if(isPrime(i)){
            return i;
        }
    }
    return 0;
}

//Assume it also sorted.
NSUInteger findNextFlag(EZArray* flags)
{
    NSUInteger begin = flags.uarray[flags.length-1] + 1;
    EZDEBUG(@"Start from %i", begin);
    //NSUInteger half = begin/2;
    for(NSUInteger i = begin; i < NSUIntegerMax ; i++){
        if(isPrime(i)){
            return i;
        }
    }
    //assert([@"" isEqualToString:@"How could I not find prime"]);
    return 0;
}

+ (NSString*) weekFlagToWeekString:(NSInteger)weekFlags
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:7];
    if((weekFlags & ALLDAYS) == 0){
        return Local(@"No Assigned Week Day");
    }
    if(weekFlags == ALLDAYS){
        return Local(@"All Week Days");
    }
    if((weekFlags & SUNDAY) == SUNDAY){
        [res addObject:Local(@"Sunday")];
    }
    if((weekFlags & MONDAY) == MONDAY){
        [res addObject:Local(@"Monday")];
    }
    if((weekFlags & TUESDAY) == TUESDAY){
        [res addObject:Local(@"Tuesday")];
    }
    if((weekFlags & WEDNESDAY) == WEDNESDAY){
        [res addObject:Local(@"Wednesday")];
    }
    if((weekFlags & THURSDAY) == THURSDAY){
        [res addObject:Local(@"Thursday")];
    }
    if((weekFlags & FRIDAY) == FRIDAY){
        [res addObject:Local(@"Friday")];
    }
    if((weekFlags & SATURDAY) == SATURDAY){
        [res addObject:Local(@"Saturday")];
    }
    return [res componentsJoinedByString:@" "];
}

@end
