//
//  EZScheduledTaskController.h
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZScheduledTaskController : UITableViewController<UIAlertViewDelegate> {
    NSDate* currentDate;
    NSArray* scheduledTasks;
    NSArray* repalceTasks;
    UIView* shakeMessage;
    UILabel* message;
}

- (void) presentShakeMessage:(NSString*)msg;

- (void) cancelShakeMessage;

- (void) rescheduleTasks;

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void) deleteRow:(NSIndexPath*)row;

- (void) replaceRow:(NSIndexPath*)row;

@property (strong, nonatomic) NSDate* currentDate;
@property (strong, nonatomic) NSArray* scheduledTasks;

@end
