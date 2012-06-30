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

@property (assign, nonatomic) BOOL isChangeWithCellEdit;

//The color will be used at editable status
@property (strong, nonatomic) UIColor* editColor;

//If color will be used at noneditable status
@property (strong, nonatomic) UIColor* nonEditColor;

//I will remove the placeholder when it is not editable.
//Pretend that I am a innocent and harmless cell.
@property (strong, nonatomic) NSString* placeHolder;

//If it is yes, the textField will ident when editable.
//Defaul is no. 
@property (assign, nonatomic) BOOL identWhileEdit;

//Don't relay on isEditing any more?
//Why it is not enough to use the userInteractable of the textField?
//Good question?
//In this setting method I will do what I need to change the edit status.
//Setup EditField is replaced by this method.
//1.Identation
//2.Text color
//3.User InteractionEnabled
@property (assign, nonatomic) BOOL isFieldEditable;


@property (strong, nonatomic) UIFont* normalFount;

@property (strong, nonatomic) UIFont* editableFont; 

//The edit field to proper status
//1. Identation
//2. Text color
//3. UserInteractionEnabled
//- (void) setupEditField:(BOOL)isEditStatus;


@end
