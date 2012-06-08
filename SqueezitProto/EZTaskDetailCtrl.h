//
//  EZTaskDetailCtrl.h
//  SqueezitProto
//
//  Created by Apple on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZTask;

@interface EZTaskDetailCtrl : UITableViewController<UITextFieldDelegate>

@property (strong, nonatomic) EZTask* task;

@end
