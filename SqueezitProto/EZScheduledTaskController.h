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
@class EZScheduledTaskSlider;

@interface EZScheduledTaskController : UITableViewController<UIAlertViewDelegate> {
    NSDate* currentDate;
    NSArray* scheduledTasks;
    NSArray* repalceTasks;
    //UIView* shakeMessage;
    UILabel* message;
    //UIView* frameView;
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

//This method is created for the purpose of testing today bug fixing
//Once this called I will start the time counter.
//Once the time counter started it will start and found out today is passed,
//Then it will call updateToday on the Slider, The slider will change the setting accordingly.
//My key observation is that the page will get refreshed.
- (void) startTimeCounter;

@property (strong, nonatomic) NSDate* currentDate;
@property (strong, nonatomic) NSArray* scheduledTasks;

//This will be executed the in the viewDidAppear. and only executed once.
@property (strong, nonatomic) EZOperationBlock viewAppearBlock;
@property (strong, nonatomic) UIViewController* superController;

//Why do we need to refer to this one.
//It is to address the issue, when it is no more today, How could we switch to other page.
//We need to get the page show off and get the time counter started.
//Normally the time counter will not get started.
//@property (weak, nonatomic) EZScheduledTaskSlider* taskSlider;

//Why do I add this view?
//To solve the problem, some time the tableView will cover the no Task View. 
//Even it is a minor visual bug. But it is unbearable to me. 
//So I decided to fix it. 
@property (strong, nonatomic) UIView* frameView;


@end
