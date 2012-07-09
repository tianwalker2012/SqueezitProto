//
//  EZScheduledV2Cell.h
//  SqueezitProto
//
//  Created by Apple on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface EZScheduledV2Cell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* taskName;
@property (strong, nonatomic) IBOutlet UILabel* startTime;
@property (strong, nonatomic) IBOutlet UILabel* endTime;
@property (strong, nonatomic) IBOutlet UILabel* alarmTitle;
@property (strong, nonatomic) IBOutlet UILabel* alarmStatus;

//@property (strong, nonatomic) UIView* nowSign;

//The status will have now, passed, future
//The cell will change it's appearance accordingly.
//For example
//IF passed: I will turn the task name into gray
//IF now: I will hide the start time and end time.
- (void) setStatus:(EZScheduledStatus)status  nowSign:(UIView*)cv;

@end
