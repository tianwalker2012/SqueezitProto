//
//  EZTaskGroupCell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTaskGroupCell.h"
#import "Constants.h"
#import "EZTaskHelper.h"

@implementation EZTaskGroupCell
@synthesize groupInfo, titleField, editableColor, noneEditableColor, titleEditable, placeholder;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    EZDEBUG(@"InitWithStyle get called");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setPlaceholder:(NSString *)ph
{
    placeholder = ph;
    titleField.placeholder = ph;
}

- (void) setTitleEditable:(BOOL)editable
{
    if(titleEditable == editable){
        return;
    }
    titleEditable = editable;
    titleField.userInteractionEnabled = titleEditable;
    if(titleEditable){
        titleField.textColor = editableColor;
        //self.accessoryType = UITableViewCellAccessoryNone;
    }else{
        titleField.textColor = noneEditableColor;
        //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
}


//Doing some initialization related jobs
- (void)awakeFromNib
{
    EZDEBUG(@"Init with nib get called");
    editableColor = [UIColor createByHex:EZEditColor];
    noneEditableColor = [UIColor blackColor];
    titleField.textColor = noneEditableColor;
    titleField.userInteractionEnabled = false;
    titleField.placeholder = @"Task group name ...";
    titleEditable = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(titleField.userInteractionEnabled){
        //[titleField becomeFirstResponder];
    }
    // Configure the view for the selected state
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:true];
    [self setTitleEditable:editing];
}

@end
