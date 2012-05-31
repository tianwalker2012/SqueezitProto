//
//  EZScheduledTaskDetailCtrl.h
//  SqueezitProto
//
//  Created by Apple on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZScheduledTask;

typedef void(^ScheduleTaskOperation)(NSIndexPath* indexPath);

@interface EZScheduledTaskDetailCtrl : UIViewController {
    EZScheduledTask* schTask;
    int row;
    ScheduleTaskOperation deleteOp;
    ScheduleTaskOperation rescheduleOp;
}

- (IBAction) deleteClicked:(id)sender;

- (IBAction) rescheduleCalled:(id)sender;

@property (strong, nonatomic) NSIndexPath* indexPath;
@property (strong, nonatomic) EZScheduledTask* schTask;
@property (strong, nonatomic) ScheduleTaskOperation deleteOp;
@property (strong, nonatomic) ScheduleTaskOperation reschuduleOp;
@property (assign, nonatomic) int row;
@property (strong, nonatomic) IBOutlet UIButton* rescheduleBtn;
@property (strong, nonatomic) IBOutlet UIButton* deleteBtn;
@property (strong, nonatomic) IBOutlet UITextField* startTime;
@property (strong, nonatomic) IBOutlet UITextField* endTime;
@property (strong, nonatomic) IBOutlet UITextField* duration;

@end
