//
//  EZEditLabelCellHolder.m
//  SqueezitProto
//
//  Created by Apple on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZEditLabelCellHolder.h"
#import "EZEditLabelCell.h"
#import "EZTaskGroupCell.h"
#import "EZPureEditCell.h"

@implementation EZEditLabelCellHolder
@synthesize editCell, groupCell, pureEditCell;


//Hope this can simplify the later cell loading code
+ (EZEditLabelCell*) createCellWithDelegate:(id<UITextFieldDelegate>)deleg
{
    EZEditLabelCellHolder* cellHolder = [[EZEditLabelCellHolder alloc] init];
    
    [[NSBundle mainBundle] loadNibNamed:@"EZEditLabelCell" owner:cellHolder options:nil];
    cellHolder.editCell.textField.delegate = deleg;
    return cellHolder.editCell;
}

+ (EZTaskGroupCell*) createTaskGroupCellWithDelegate:(id<UITextFieldDelegate>)deleg
{
    EZEditLabelCellHolder* cellHolder = [[EZEditLabelCellHolder alloc] init];
    
    [[NSBundle mainBundle] loadNibNamed:@"EZTaskGroupCell" owner:cellHolder options:nil];
    cellHolder.groupCell.titleField.delegate = deleg;
    return cellHolder.groupCell;

}

//Generate the pure Edit cell from the XIB file
+ (EZPureEditCell*) createPureEditCellWithDelegate:(id<UITextFieldDelegate>)deleg
{
    EZEditLabelCellHolder* cellHolder = [[EZEditLabelCellHolder alloc] init];
    
    [[NSBundle mainBundle] loadNibNamed:@"EZPureEditCell" owner:cellHolder options:nil];
    cellHolder.pureEditCell.editField.delegate = deleg;
    return cellHolder.pureEditCell;
}

@end
