//
//  EZAvailableDay.h
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZAvailableDay : NSObject {
    NSDate* date;
    int assignedWeeks; //1 mean monday, 2 mean tuesday, 4 mean wensday etc...
    NSMutableArray* availableTimes; 
    NSString* name;
}

- (id) init;

- (id) initWithName:(NSString*)nm weeks:(int)aw;

//Return a deep copy of itself
- (id) duplicate;

- (NSString*) description;

@property (strong, nonatomic) NSDate* date;
@property (assign, nonatomic) int assignedWeeks;
@property (strong, nonatomic) NSMutableArray* availableTimes;
@property (strong, nonatomic) NSString* name;

@end