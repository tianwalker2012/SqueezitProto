//
//  EZGoalSetter.h
//  SqueezitProto
//
//  Created by Apple on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

@class EZQuotas;

//The name for this class is very misleading. 
//How to fix them?
@interface EZGoalSetter : UITableViewController

@property (strong, nonatomic) EZQuotas* quotas;
@property (strong, nonatomic) EZOperationBlock doneBlock;
//@property (assign, nonatomic) int sectionCount;

@end
