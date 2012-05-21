//
//  EZAvailableTime.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

//The purpose of this class, it to define the allocatable time period 
//So that the system could allocate proper task according to the time setting.

@interface EZAvailableTime : NSObject {
    NSDate* start;
    
    //Used to attach some text to this available time
    //Like on the train, etc..., make use more easily to memorize this
    NSString* description;
    //Minutes, I made this assumption. 
    //Why not make it to seconds, based on my common sense. unless my common sense is not that common.(Funny)
    int duration;
    
    //Is it noisy? is it private? is it stable?(On bus, unstable and noisy and no privacy either)
    int environmentTraits;
    
}

- (id) init:(NSDate*)start description:(NSString*)ds duration:(int)dur environment:(int)env;

- (id) init:(EZAvailableTime*)at;

- (void) adjustStartTime:(int)increasedMinutes;

@property (strong, nonatomic) NSDate* start;
@property (assign, nonatomic) int duration;
@property (assign, nonatomic) int environmentTraits;
@property (strong, nonatomic) NSString* description;

@end
