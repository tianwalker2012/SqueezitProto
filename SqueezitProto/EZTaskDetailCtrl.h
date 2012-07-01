//
//  EZTaskDetailCtrl.h
//  SqueezitProto
//
//  Created by Apple on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"
#import "EZTableSelector.h"

@class EZTask;

typedef void(^DeleteBlock) (BOOL deleted);

@interface EZTaskDetailCtrl : UITableViewController<UITextFieldDelegate, UIActionSheetDelegate, EZTableSelectorDelegate>

@property (strong, nonatomic) EZTask* task;
@property (strong, nonatomic) DeleteBlock deleteBlock;
@property (strong, nonatomic) EZOperationBlock superUpdateBlock;
@property (strong, nonatomic) EZOperationBlock superDeleteBlock;

@end
