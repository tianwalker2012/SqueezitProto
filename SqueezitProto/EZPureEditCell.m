//
//  EZPureEditCell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZPureEditCell.h"
#import "Constants.h"
#import "EZTaskHelper.h"

@interface EZPureEditCell()

- (void) indentTextField;

- (void) unIndentTextField;

@end


@implementation EZPureEditCell
@synthesize editField, isChangeWithCellEdit, editColor, nonEditColor, isFieldEditable, placeHolder, identWhileEdit, mustShowClearButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    EZDEBUG(@"PureCell initWithStyle get called, %@", [NSThread callStackSymbols]);
    return self;
}

- (void) indentTextField
{
    editField.left = 44;
}

- (void) unIndentTextField
{
    editField.left = 10;
}

- (void)awakeFromNib
{
    editColor = [UIColor createByHex:EZEditColor];
    nonEditColor = [UIColor blackColor];
    identWhileEdit = false;
    isChangeWithCellEdit = false;
    self.isFieldEditable = false;
    editField.clearButtonMode = UITextFieldViewModeNever;
    mustShowClearButton = false;
    
}

- (BOOL) shouldIndentWhileEditing
{
    return false;
}

//Assume the initial status is not editable. 
//If it is not the case, just call setupEditField is enough to fix this.
//We are in good shape.
//Better do nothing special here. 
//Mean this function better not have side effect.
//Or it will make things complicated.
- (void) setIsChangeWithCellEdit:(BOOL)ice
{
    isChangeWithCellEdit = ice;
}

  

//The edit field to proper status
//1. Identation add it during next iteration
//2. Text color
//3. UserInteractionEnabled
- (void) setIsFieldEditable:(BOOL)isEditStatus
{
    EZDEBUG(@"Why only show the clearbutton while edit?");
    isFieldEditable = isEditStatus;
    if(isEditStatus){
        editField.textColor = [UIColor createByHex:EZEditColor];
        editField.userInteractionEnabled = true;
        editField.placeholder = self.placeHolder;
        editField.clearButtonMode = UITextFieldViewModeAlways;
        
        //Add a empty space so that the field will get showed
        //So that trim is very important before store anything.
        if([editField.text isEqualToString:@""] && mustShowClearButton){
            editField.text = @" ";
        }
        if(identWhileEdit){
            [self indentTextField];
        }
    }else{
        editField.textColor = nonEditColor;
        editField.userInteractionEnabled = false;
        editField.placeholder = @"";
        editField.clearButtonMode = UITextFieldViewModeNever;
        [self unIndentTextField];
    }
}


- (id) init
{
    self = [super init];
    return self;
}

//Will be called when this cell get selected, right?
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    //EZDEBUG(@"PureCell get selected:%@, animated:%@",selected?@"true":@"false", animated?@"YES":@"NO");
    // Configure the view for the selected state
    if(selected){
        if(editField.isUserInteractionEnabled){
            [editField becomeFirstResponder];
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    EZDEBUG(@"setEditting called:%@", (editing?@"YES":@"NO"));
    [super setEditing:editing animated:animated];
    if(isChangeWithCellEdit){//Only when is not always editable we care.
        self.isFieldEditable = editing;
    }
}

//Fit the bound with specified rightPadding.
- (void) adjustRightPadding:(CGFloat)padding
{
    CGRect editFrame = editField.frame;
    CGFloat gap = self.frame.size.width - editFrame.origin.x - editFrame.size.width;
    gap -= padding;
    editField.frame = CGRectMake(editFrame.origin.x, editFrame.origin.y, editFrame.size.width + gap, editFrame.size.height);
    
}

@end
