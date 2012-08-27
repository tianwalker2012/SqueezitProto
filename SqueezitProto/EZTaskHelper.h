//
//  EZTaskHelper.h
//  SqueezitProto
//
//  Created by Apple on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "EZCycleResult.h"

typedef void (^ EZOperationBlock)();

typedef void (^ EZEventOpsBlock) (id sender);

typedef BOOL (^ FilterOperation)(id obj);

typedef id (^ MapCarOperation)(id obj);

typedef void  (^ IterateOperation)(id obj);

@class NSManagedObject, EZArray;

@protocol EZValueObject <NSObject>

@required
- (id) initWithVO:(id<EZValueObject>) valueObj;

- (id) cloneVO;

- (id) initWithPO:(NSManagedObject*)mtk;

- (NSManagedObject*) createPO;

- (NSManagedObject*) populatePO:(NSManagedObject*)po;

- (NSManagedObject*) PO;

- (void) setPO:(NSManagedObject*)po;

//Will fetch the value from the database again.
- (void) refresh;

@end

@interface NSString(EZPrivate)

- (NSString*) trim;

- (NSInteger) hexToInt;

@end


@interface UIView(EZPrivate)

- (void) setLeft:(CGFloat)distance;
- (CGFloat) left;


- (void) setTop:(CGFloat)distance;
- (CGFloat) top;

- (void) setRight:(CGFloat)distance;
- (CGFloat) right;

- (void) setBottom:(CGFloat)distance;
- (CGFloat) bottom;

@end

@interface UIColor(EZPrivate)

+ (UIColor*) createByHex:(NSString*)hexStr;

- (NSString*) toHexString;

@end

@interface NSArray(EZPrivate)

- (NSArray*) filter:(FilterOperation)opts;

- (NSArray*) mapcar:(MapCarOperation)opts;

- (void) iterate:(IterateOperation) opts;

@end

@interface NSObject(EZPrivate)

- (void) performBlock:(EZOperationBlock)block withDelay:(NSTimeInterval)delay;

- (void) executeBlock:(EZOperationBlock)block;

- (void) executeBlockInBackground:(EZOperationBlock)block inThread:(NSThread*)thread;

- (void) executeBlockInMainThread:(EZOperationBlock)block;

@end

@interface NSDate(EZPrivate) 

- (NSInteger) convertDays;

- (EZWeekDayValue) weekDay;

- (NSDate*) beginning;

- (NSDate*) ending;

- (int) orgWeekDay;

- (int) monthDay;

+ (NSDate*) stringToDate:(NSString*)format dateString:(NSString*)dateStr;

- (NSString*) stringWithFormat:(NSString*)format;

- (NSDate*) adjustDays:(int)days;

- (NSDate*) adjustMinutes:(int)minutes;

- (NSDate*) adjust:(NSTimeInterval)delta;

- (NSComparisonResult) compareTime:(NSDate*)date;

- (NSDate*) combineTime:(NSDate*)time;

//True mean they are equal with the format, False mean not equal. 
- (BOOL) equalWith:(NSDate*)date format:(NSString*)format;

//Check if the date fall inbetween the specified start and end.
//It will including the stat and end date.
- (BOOL) InBetweenDays:(NSDate*)start end:(NSDate*)end;

- (BOOL) InBetween:(NSDate*)start end:(NSDate*)end;

//Wether have passed the passin time or not
- (BOOL) isPassed:(NSDate*)date;

@end

@class EZAvailableDay, EZQuotas;

NSUInteger removeFrom(NSUInteger flag, NSUInteger envFlags);

BOOL isContained(NSUInteger flag, NSUInteger envFlags);

//Find in the fractors array if any number could be divided from the target
NSUInteger findFractor(NSUInteger target, EZArray* flags);

NSUInteger combineFlags(NSUInteger flag, NSUInteger envFlags);

//The flags mean all the existed prime number, make sure the all the prime number are found on sequence
NSUInteger findNextFlag(EZArray* flags);

NSUInteger findPrimeAfter(NSUInteger primed);

@interface EZTaskHelper : NSObject

//envTraits will be EZEnvironmentTraits combiation
//This is minutes, mean how many minutes left
+ (int) calcTime:(EZAvailableDay*)aDay envTraits:(int)envTraits;

//Calculate the beginning date for current cycle,
//So that we have the information that from when we start collect history data
//We collect history data for the purpose of calculating the remaining time
+ (EZCycleResult*) calcHistoryBegin:(EZQuotas*)quotas date:(NSDate*)date;

//Calculate how many days still left for in current cycle
+ (int) cycleRemains:(EZQuotas*)quotas date:(NSDate*)date;

+ (int) getMonthLength:(NSDate*)date;

+ (NSString*) weekFlagToWeekString:(NSInteger)weekFlags;

+ (NSThread*) getBackgroundThread;

//This will be executed in the natural background.
//+ (void) executeBlockInBackground:(EZOperationBlock)block;

+ (void) executeBlockInBG:(EZOperationBlock)block;

+ (void) executeBlockInMain:(EZOperationBlock)block;
//+ (NSString*) envTraitsToString:(NSInteger)envTraits;

@end
