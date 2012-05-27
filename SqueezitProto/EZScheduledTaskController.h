//
//  EZScheduledTaskController.h
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZScheduledTaskController : UITableViewController {
    NSDate* currentDate;
    NSArray* scheduledTasks;
    UIView* shakeMessage;
    UILabel* message;
}

- (void) presentShakeMessage;

- (void) cancelShakeMessage;

- (void) rescheduleTasks;

@property (strong, nonatomic) NSDate* currentDate;
@property (strong, nonatomic) NSArray* scheduledTasks;

@end
