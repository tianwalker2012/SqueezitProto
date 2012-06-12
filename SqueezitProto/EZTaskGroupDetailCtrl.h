//
//  EZTaskGroupDetailCtrl.h
//  SqueezitProto
//
//  Created by Apple on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

@class EZTaskGroup;

@interface EZTaskGroupDetailCtrl : UITableViewController<UITextFieldDelegate> 

@property (strong, nonatomic) EZTaskGroup* taskGroup;
@property (strong, nonatomic) NSMutableArray* tasks;
@property (strong, nonatomic) UITextField* editField;
@property (assign, nonatomic) NSInteger barType;
@property (strong, nonatomic) EZOperationBlock superUpdateBlock;

@end
