//
//  EZGoalTimeSetter.h
//  SqueezitProto
//
//  Created by Apple on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"
#import "EZPickerKeyboardTime.h"

@class EZQuotas;

@interface EZGoalTimeSetter : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate> 


//1 mean planned goal
//2 mean cycle length
//3 mean cycle start time
@property (assign, nonatomic) int timeSetterType;
@property (strong, nonatomic) EZOperationBlock doneBlock;
@property (strong, nonatomic) EZQuotas* quotas;

@end
