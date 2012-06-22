//
//  EZPureEditCell.h
//  SqueezitProto
//
//  Created by Apple on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZPureEditCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField* editField;

@property (assign, nonatomic) BOOL isAlwaysEditable;

//The color will be used at editable status
@property (strong, nonatomic) UIColor* editColor;

//If color will be used at noneditable status
@property (strong, nonatomic) UIColor* nonEditColor;

//The edit field to proper status
//1. Identation
//2. Text color
//3. UserInteractionEnabled
- (void) setupEditField:(BOOL)isEditStatus;


@end
