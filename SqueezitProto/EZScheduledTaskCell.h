//
//  EZScheduledTaskCell.h
//  SqueezitProto
//
//  Created by Apple on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

@interface EZScheduledTaskCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* taskName;
@property (strong, nonatomic) IBOutlet UILabel* timeSpan;
@property (strong, nonatomic) IBOutlet UILabel* alarmType;
@property (strong, nonatomic) IBOutlet UISwitch* switchButton;
@property (strong, nonatomic) EZEventOpsBlock switchChange;
//Mean if the task is going on, I will add a nowSign to this cell
//If it is not, should remove it
@property (strong, nonatomic) UIView* nowSign;

- (IBAction) switchTapped:(id)sender;

@end
