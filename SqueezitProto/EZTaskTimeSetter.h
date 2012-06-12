//
//  EZTaskTimeSetter.h
//  SqueezitProto
//
//  Created by Apple on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZPickerKeyboardTime.h"
#import "EZTaskHelper.h"

@class EZTask;

@interface EZTaskTimeSetter : UITableViewController<EZValueSelector>

@property (strong, nonatomic) EZTask* task;
@property (strong, nonatomic) EZPickerKeyboardTime* pickerKeyboard;
@property (strong, nonatomic) NSIndexPath* selected;

//I prefer the let's the super determined what's the meaning of the done?
//Then super will become a logic hub. Not a scalable solution.
//Each one focus on what he is specialized.
@property (strong, nonatomic) EZOperationBlock superDone;

@end
