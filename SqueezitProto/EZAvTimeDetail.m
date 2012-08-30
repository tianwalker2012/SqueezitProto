//
//  EZAvTimeDetail.m
//  SqueezitProto
//
//  Created by Apple on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvTimeDetail.h"
#import "EZAvailableTime.h"
#import "EZEditLabelCellHolder.h"
#import "EZBeginEndTimeCell.h"
#import "EZPureEditCell.h"
#import "EZGlobalLocalize.h"
#import "EZTaskStore.h"
#import "EZKeyBoardHolder.h"
#import "EZPickerWrapper.h"
#import "EZPickerKeyboardDate.h"
#import "EZEnvFlag.h"
#import "EZTaskHelper.h"

@interface EZAvTimeDetail () {
    EZPickerKeyboardDate* dateKeyboard;
    EZPickerWrapper* pickerWrapper;
    NSDate* curStartTime;
    NSDate* curEndTime;
    UIColor* originalTextColor;
    
    EZTableSelector* tableSelector;
    NSUInteger currEnvFlags;
    
}

- (void) pickerChanged:(UIDatePicker*)picker;

- (void) clearWarningColor;

- (void) done;

- (void) cancel;

@end

@implementation EZAvTimeDetail
@synthesize avTime, doneBlock, cancelBlock;

- (void) done
{
    if(doneBlock){
        doneBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancel
{
    if(cancelBlock){
        cancelBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    curStartTime = avTime.start;
    curEndTime = [avTime.start adjustMinutes:avTime.duration];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* res = nil;
    if(indexPath.section == 0){
        EZPureEditCell* titleCell = [EZEditLabelCellHolder createPureEditCellWithDelegate:self];
        titleCell.editField.text = avTime.name;
        titleCell.isFieldEditable = true;
        [titleCell adjustRightPadding:EditPadding];
        res = titleCell;
    }else if(indexPath.section == 1){
        EZBeginEndTimeCell* timeCell = [EZEditLabelCellHolder createBeginEndTimeCell];
        timeCell.beginTime.text = [avTime.start stringWithFormat:@"HH:mm"];
        timeCell.endTime.text = [[avTime.start adjustMinutes:avTime.duration] stringWithFormat:@"HH:mm"];
        timeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        res = timeCell;
    }else{
        res = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"EnvCell"];
        res.textLabel.text = Local(@"Environment");
        res.detailTextLabel.text = envTraitsToString(avTime.envTraits);
        res.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return res;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        return 66;
    }
    return 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Show the time screen
    if(indexPath.section == 1){
        if(pickerWrapper == nil){
            pickerWrapper = [[EZPickerWrapper alloc] initWithStyle:UITableViewStyleGrouped];
            pickerWrapper.wrapperDelegate = self;
        }
        curStartTime = avTime.start;
        curEndTime = [avTime.start adjustMinutes:avTime.duration];
        [self.navigationController pushViewController:pickerWrapper animated:YES];
    }else if(indexPath.section == 2){
        if(tableSelector == nil){
            tableSelector = [[EZTableSelector alloc] initWithStyle:UITableViewStyleGrouped];
            tableSelector.selectorDelegate = self;
        }
        currEnvFlags = avTime.envTraits;
        [self.navigationController pushViewController:tableSelector animated:YES];
    }

}


//How many rows in this picker controller;
- (int) getRow:(id)picker
{
    if([picker isKindOfClass:[EZPickerWrapper class]]){
        return 1;
    }
    //Why, because I Added a SelectAll flag.
    return [EZTaskStore getInstance].envFlags.count + 1;
}

//It is shared by both delegate, so, I have to check for class to differentiate it.
- (int) getSection:(EZPickerWrapper*)picker
{
    if([picker isKindOfClass:[EZPickerWrapper class]]){
        return 2;
    }
    return 1;
}

- (NSIndexPath*) getDefaultSelected:(EZPickerWrapper*)pickerWrapper
{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

//Will be called, when user selected a cell. 
//In this method, delegate need to setup the picker to the value of the 
//Current cell. 
//The keyboard raise will be handled by EZPickerWrapper
- (void) pickerWrapper:(EZPickerWrapper*)pickerWrapper cellSelected:(UITableViewCell*)cell indexPath:(NSIndexPath*)path keyboard:(UIView*)keyboard
{
    if(path.section == 0){
        [dateKeyboard.picker setDate:curStartTime animated:YES];
    }else{
        [dateKeyboard.picker setDate:curEndTime animated:YES];
    }
}

- (UITableViewCell*) pickerWrapper:(EZPickerWrapper*)pickerWrapper getCell:(NSIndexPath*)path
{
    UITableViewCell* res = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    originalTextColor = res.detailTextLabel.textColor;
    if(path.section == 0){
        res.textLabel.text = Local(@"Begin");
        res.detailTextLabel.text = [curStartTime stringWithFormat:@"HH:mm"];
    }else{
        res.textLabel.text = Local(@"End");
        res.detailTextLabel.text = [curEndTime stringWithFormat:@"HH:mm"];
    }
    return res;
}

//Will be used later when when have differnt keyboard for different indexPath
- (UIView*) pickerWrapper:(EZPickerWrapper*)pickerWrapper getKeyBoard:(NSIndexPath*)path
{
    if(dateKeyboard == nil){
        dateKeyboard = [EZKeyBoardHolder createDateKeyboard];
        dateKeyboard.picker.datePickerMode = UIDatePickerModeTime;
        [dateKeyboard.picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return dateKeyboard;
}

//Will add validation check the next iteration
- (void) pickerChanged:(UIDatePicker*)picker
{
    NSIndexPath* selected = pickerWrapper.getSelectedRow;
    NSIndexPath* other = nil;
    if(selected.section == 0){
        curStartTime = picker.date;
        other = [NSIndexPath indexPathForRow:0 inSection:1];
    }else{
        curEndTime = picker.date;
        other = [NSIndexPath indexPathForRow:0 inSection:0];
    }
   
    UITableViewCell* cell = [pickerWrapper getCellByIndexPath:selected];
    cell.detailTextLabel.text = [picker.date stringWithFormat:@"HH:mm"];
    [self clearWarningColor];
    if([curStartTime compare:curEndTime] == NSOrderedDescending){
        EZDEBUG(@"Illegal time:%@-%@",[curStartTime stringWithFormat:@"HH:mm"], [curEndTime stringWithFormat:@"HH:mm"]);
        UITableViewCell* otherCell = [pickerWrapper getCellByIndexPath:other];
        otherCell.detailTextLabel.textColor = [UIColor redColor];
    }
}

//Clean the warning text color
- (void) clearWarningColor
{
    for(UITableViewCell* cell in pickerWrapper.tableView.visibleCells){
        cell.detailTextLabel.textColor = originalTextColor;
    }
}

- (void) doneClicked:(id)pickerWrapper
{
    if([pickerWrapper isKindOfClass:[EZPickerWrapper class]]){
        if([curStartTime compare:curEndTime] == NSOrderedDescending){
            NSDate* tmp = curStartTime;
            curStartTime = curEndTime;
            curEndTime = tmp;
        }
        NSInteger duration = (curEndTime.timeIntervalSince1970 - curStartTime.timeIntervalSince1970)/60;
        EZDEBUG(@"Duration:%i", duration);
        avTime.start = curStartTime;
        avTime.duration = duration;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        avTime.envTraits = currEnvFlags;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) cancelClicked:(id)picker
{
    EZDEBUG(@"Cancel clicked");
}



//What we need to do in this class?
//Return the Cells 
- (UITableViewCell*) tableSelector:(EZTableSelector*)selector getCell:(NSIndexPath*)indexPath
{
    EZTaskStore* store = [EZTaskStore getInstance];
    EZEnvFlag* flag = nil;
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if(indexPath.row == 0){
        cell.textLabel.text = Local(@"Select All");
        cell.textLabel.textColor = [UIColor createByHex:EZSpecialSelection];
        if(currEnvFlags == 0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        flag = [store.envFlags objectAtIndex:indexPath.row-1];
        cell.textLabel.text = Local(flag.name);
        if(currEnvFlags && isContained(flag.flag, currEnvFlags)){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    //if(indexPath.row % 2){
    //    cell.backgroundColor = [UIColor createByHex:EZGapDarkColor];
    //}else{
    //    cell.backgroundColor = [UIColor createByHex:EZGapWhiteColor];
    //}
    return cell;
}

- (void) tableSelector:(EZTableSelector*)selector selected:(NSIndexPath*)indexPath
{
    EZTaskStore* store = [EZTaskStore getInstance];
    
    if(indexPath.row == 0){
        if(currEnvFlags == 0){//already selected
            //What do we need to do?
            return;
        }else{
            currEnvFlags = 0;
            [selector selectOnly:indexPath];
        }
    }else{
        EZEnvFlag* flag = [store.envFlags objectAtIndex:(indexPath.row-1)];
        //If already included, exclude it. vice versa.
        //Exposed the inner mechanism.
        if(currEnvFlags == 0){
            currEnvFlags = 1;
        }
        if(isContained(flag.flag, currEnvFlags)){
            currEnvFlags = currEnvFlags/flag.flag;
            [selector selectNot:indexPath];
        }else{
            currEnvFlags = currEnvFlags * flag.flag;
            [selector selectAdd:indexPath];
        }
        if(currEnvFlags == 1){
            currEnvFlags = 0;
            [selector selectOnly:[NSIndexPath indexPathForRow:0 inSection:0]];
        }else{
            [selector selectNot:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }
}

//I made an assumption
//That is only the name of the availabDay are used this delegate.
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //The default behavior is empty string mean back to old value.
    //This behavior is good
    if([textField.text.trim isEqualToString:@""]){
        textField.text = avTime.name;
    }else{
        avTime.name = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}


@end
