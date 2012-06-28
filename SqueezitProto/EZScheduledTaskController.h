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

//Will called to load the date into the scheduledTasks array.
//And call the reload on the tableView.
//The currentDate will be set too.
- (void) reloadScheduledTask:(NSDate*)date;

//Will be called by Container.
- (void) loadWithTask:(NSArray*)tasks date:(NSDate*)date;

@property (strong, nonatomic) NSDate* currentDate;
@property (strong, nonatomic) NSArray* scheduledTasks;

//This will be executed the in the viewDidAppear. and only executed once.
@property (strong, nonatomic) EZOperationBlock viewAppearBlock;
@property (strong, nonatomic) UIViewController* superController;


@end
