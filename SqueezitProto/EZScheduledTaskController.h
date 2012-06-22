//
//  EZScheduledTaskController.h
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

@class EZScheduledTask;

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

//Will be called when notification recieved.
- (void) presentScheduledTask:(EZScheduledTask*)schTask;

@property (strong, nonatomic) NSDate* currentDate;
@property (strong, nonatomic) NSArray* scheduledTasks;

//This will be executed the in the viewDidAppear. and only executed once.
@property (strong, nonatomic) EZOperationBlock viewAppearBlock;

@end
