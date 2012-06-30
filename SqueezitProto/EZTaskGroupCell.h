//
//  EZTaskGroupCell.h
//  SqueezitProto
//
//  Created by Apple on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZTaskGroupCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField* titleField;
@property (strong, nonatomic) IBOutlet UILabel* groupInfo;
@property (strong, nonatomic) UIColor* editableColor;
@property (strong, nonatomic) UIColor* noneEditableColor;

@property (assign, nonatomic) BOOL titleEditable;

@end
