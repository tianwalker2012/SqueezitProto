//
//  EZTimeCounter.h
//  SqueezitProto
//
//  Created by Apple on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

//What's my expectation to this class?
//I expect it as a independent timeCounter.
//I can insert it to the place.
//Setup remaining second, it will start tick,
//Will callback once the time is up.
//And turn himself off after the time is up.
//Basic mechanism will be like this:
//Every time I wake up by the timer will check the different 
//Between last weak up and this weak up and minus the difference from the remain time. 
//If the remain become zero or minus will stop the NSTimer and call teh timeUpOps.

@class EZTimeCounterView;

@interface EZTimeCounter : NSObject

@property (strong, nonatomic) EZTimeCounterView* counterView;
@property (strong, nonatomic) EZEventOpsBlock timeupOps;
@property (assign, nonatomic) NSTimeInterval remainTime;
@property (assign, nonatomic) BOOL isCounting;

//This will be called each time tick.
@property (strong, nonatomic) EZEventOpsBlock tickBlock;

- (void) start:(NSTimeInterval)interval;

- (void) stop;

- (NSString*) updateTitle;

//Solve the flash issue.
- (void) update;

@end











