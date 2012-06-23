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
#import "EZAvailableTimeCell.h"
#import "EZScheduledCell.h"
#import "EZAvTimeCell.h"
#import "EZAvTimeHeader.h"
#import "EZButtonCell.h"
#import "EZScheduledV2Cell.h"

@implementation EZEditLabelCellHolder
@synthesize editCell, groupCell, pureEditCell, settingCell, flagCell, timeCell, scheduledCell, avTimeCell, avTimeHeader, beginEndTimeCell, scheduledTaskCell, timeCounterView, buttonCell, scheduleV2Cell;


//Singleton, save memory?
+ (EZEditLabelCellHolder*) getInstance
{
    static EZEditLabelCellHolder* holder = nil;
    if(holder == nil){
        holder = [[EZEditLabelCellHolder alloc] init];
    }
    return holder;
}

//Write a test to make sure this refactor will not cause problem.
+ (EZScheduledCell*) createScheduledCell
{
    EZEditLabelCellHolder* holder = [EZEditLabelCellHolder getInstance];
    [[NSBundle mainBundle] loadNibNamed:@"EZScheduledCell" owner:holder options:nil];
    return holder.scheduledCell;
}

+ (EZAvailableTimeCell*) createTimeCell
{
    EZEditLabelCellHolder* cellHolder = [[EZEditLabelCellHolder alloc] init];
    
    [[NSBundle mainBundle] loadNibNamed:@"EZAvailableTimeCell" owner:cellHolder options:nil];
    
    return cellHolder.timeCell;
}

+ (EZEnvFlagPickerCell*) createFlagCell
{
    EZEditLabelCellHolder* cellHolder = [[EZEditLabelCellHolder alloc] init];
    
    [[NSBundle mainBundle] loadNibNamed:@"EZFlagPickerCell" owner:cellHolder options:nil];
    
    return cellHolder.flagCell;
}

+ (EZSettingCell*) createSettingCell
{
    EZEditLabelCellHolder* cellHolder = [[EZEditLabelCellHolder alloc] init];
    
    [[NSBundle mainBundle] loadNibNamed:@"EZSettingCell" owner:cellHolder options:nil];
    
    return cellHolder.settingCell;
}

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

//Why I set the space to empty here?
//Because I need the original text in the Xib file to demostrate the effect.
+ (EZAvTimeCell*) createAvTimeCell
{
    EZEditLabelCellHolder* cellHolder = [EZEditLabelCellHolder getInstance];
    [[NSBundle mainBundle] loadNibNamed:@"EZAvTimeCell" owner:cellHolder options:nil];
    cellHolder.avTimeCell.name.text = @"";
    cellHolder.avTimeCell.endTime.text = @"";
    cellHolder.avTimeCell.startTime.text = @"";
    cellHolder.avTimeCell.envLabel.text = @"";
    return cellHolder.avTimeCell;
}

+ (EZAvTimeHeader*) createAvTimeHeader
{
    EZEditLabelCellHolder* cellHolder = [EZEditLabelCellHolder getInstance];
    [[NSBundle mainBundle] loadNibNamed:@"EZAvTimeHeader" owner:cellHolder options:nil];
    cellHolder.avTimeHeader.title.text = @"";
    //Hide the button
    cellHolder.avTimeHeader.addButton.alpha = 0;
    return cellHolder.avTimeHeader;
}

+ (EZBeginEndTimeCell*) createBeginEndTimeCell
{
    EZEditLabelCellHolder* cellHolder = [EZEditLabelCellHolder getInstance];
    [[NSBundle mainBundle] loadNibNamed:@"EZBeginEndTimeCell" owner:cellHolder options:nil];
    return cellHolder.beginEndTimeCell;
}

+ (EZScheduledTaskCell*) createScheduledTaskCell
{
    EZEditLabelCellHolder* cellHolder = [EZEditLabelCellHolder getInstance];
    [[NSBundle mainBundle] loadNibNamed:@"EZScheduledTaskCell" owner:cellHolder options:nil];
    return cellHolder.scheduledTaskCell;
}

+ (EZTimeCounterView*) createTimeCounterView
{
    EZEditLabelCellHolder* cellHolder = [EZEditLabelCellHolder getInstance];
    [[NSBundle mainBundle] loadNibNamed:@"EZTimeCounterView" owner:cellHolder options:nil];
    return cellHolder.timeCounterView;
}

+ (EZButtonCell*) createButtonCell
{
    EZEditLabelCellHolder* cellHolder = [EZEditLabelCellHolder getInstance];
    [[NSBundle mainBundle] loadNibNamed:@"EZButtonCell" owner:cellHolder options:nil];
    return cellHolder.buttonCell;   
}

+ (EZScheduledV2Cell*) createScheduledV2Cell
{
    EZEditLabelCellHolder* cellHolder = [EZEditLabelCellHolder getInstance];
    [[NSBundle mainBundle] loadNibNamed:@"EZScheduledV2Cell" owner:cellHolder options:nil];
    return cellHolder.scheduleV2Cell;  
}

@end
