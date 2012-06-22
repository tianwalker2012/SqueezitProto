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

@implementation EZPureEditCell
@synthesize editField, isAlwaysEditable, editColor, nonEditColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    EZDEBUG(@"PureCell initWithStyle get called, %@", [NSThread callStackSymbols]);
    return self;
}


- (BOOL) shouldIndentWhileEditing
{
    return false;
}

//Assume the initial status is not editable. 
//If it is not the case, just call setupEditField is enough to fix this.
//We are in good shape.
- (void) setIsAlwaysEditable:(BOOL)aEditable
{
    isAlwaysEditable = aEditable;
    if(aEditable){
        [self setupEditField:true];
    }else{
        [self setupEditField:false];
    }
}

//The edit field to proper status
//1. Identation add it during next iteration
//2. Text color
//3. UserInteractionEnabled
- (void) setupEditField:(BOOL)isEditStatus
{
    if(isEditStatus){
        if(editColor){
            editField.textColor = editColor;
        }else{
            editField.textColor = [UIColor createByHex:EZEditColor];
        }
        editField.userInteractionEnabled = true;
    }else{
        if(nonEditColor){
            editField.textColor = nonEditColor;
        }else{
            editField.textColor = [UIColor blackColor];
        }
        editField.userInteractionEnabled = false;
    }
}


- (id) init
{
    self = [super init];
    EZDEBUG(@"PureCell init get called,%@",[NSThread callStackSymbols]);
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
    [super setEditing:editing animated:animated];
    if(!isAlwaysEditable){//Only when is not always editable we care.
        [self setupEditField:editing];
    }
}

@end
