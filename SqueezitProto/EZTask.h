//
//  EZTask.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZTask : NSObject {
    NSString* name;

    NSString* description;

    //In minutes, which mean minimum duration.
    //If it is zero mean, I only need a notification for this thing. Doesn't require available time span.
    int duration;
    
    //Purpos of the max duration is for some task will try to grab more time then minimum time.
    int maxDuration;
    
    //The purpose of this field is that, I want this task to start at my specified time.
    BOOL fixedTime;
    
    //The purpose of this field is that, I want this task to start at my specified date.
    BOOL fixedDate;
    
    NSDate* time;
    NSDate* date;

}

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* description;
@property (assign, nonatomic) int duration;
@property (assign, nonatomic) int maxDuration;
@property (assign, nonatomic) BOOL fixedTime;
@property (assign, nonatomic) BOOL fixedDate;
@property (strong, nonatomic) NSDate* time;
@property (strong, nonatomic) NSDate* date;


- (id) initWithName:(NSString*) name description:(NSString*) description duration:(int)duration;


@end
