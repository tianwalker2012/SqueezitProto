//
//  EZGoalTimeSetter.m
//  SqueezitProto
//
//  Created by Apple on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZGoalTimeSetter.h"
#import "EZQuotas.h"
#import "EZGlobalLocalize.h"
#import "EZPickerKeyboardTime.h"
#import "EZKeyBoardHolder.h"
#import "EZPickerKeyboardDate.h"

@interface EZGoalTimeSetter () {
    EZPickerKeyboardTime* numberPicker;
    EZPickerKeyboardDate* datePicker;
}

- (void) doneClicked;

- (void) cancelClicked;

- (void) raiseKeyBoard;

- (void) releaseKeyBoard:(EZOperationBlock)completeBlock;

@end

@implementation EZGoalTimeSetter
@synthesize timeSetterType, doneBlock, quotas;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dateChanged:(id)sender
{
    quotas.cycleStartDay = datePicker.picker.date;
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = [quotas.cycleStartDay stringWithFormat:@"yyyy-MM-dd"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked)];
    
    EZDEBUG(@"The timeSetter time is %i", timeSetterType);
    if(timeSetterType == 1 || timeSetterType == 2){
        numberPicker = [EZKeyBoardHolder createPickerKeyboard];
        numberPicker.picker.delegate = self;
        numberPicker.picker.dataSource = self;
        //numberPicker.selector = self;
        if(timeSetterType == 1){
            self.navigationItem.title = EZLocalizedString(@"Goal", nil);
            numberPicker.title1.text = EZLocalizedString(@"Days",nil);
            numberPicker.title2.text = EZLocalizedString(@"Hours",nil);
        }else{
            self.navigationItem.title = EZLocalizedString(@"Cycle length", nil);
            numberPicker.title1.text = EZLocalizedString(@"Days",nil);
            numberPicker.title2.text = @"";
        }
    }else{
        datePicker = [EZKeyBoardHolder createDateKeyboard];
        [datePicker.picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.title = Local(@"Cycle Start Date");
    }
    
    [self performSelector:@selector(raiseKeyBoard) withObject:nil afterDelay:0.3];
    
}

- (void) setPickerValue
{
    if(timeSetterType == 1){
        NSInteger hourValue = quotas.quotasPerCycle/60;
        NSInteger days = hourValue/24;
        NSInteger hours = hourValue%24;
        EZDEBUG(@"hours:%i, hours:%i",days, hours);
        [numberPicker.picker selectRow:days inComponent:0 animated:YES];
        [numberPicker.picker selectRow:hours inComponent:1 animated:YES];
        
    }else if(timeSetterType == 2){
        [numberPicker.picker selectRow:quotas.cycleLength inComponent:0 animated:YES];
    }else{
        [datePicker.picker setDate:(quotas.cycleStartDay==nil?[NSDate date]:quotas.cycleStartDay)];
    }
}

- (void) raiseKeyBoard
{
    EZOperationBlock animBlock = nil;
    EZOperationBlock animCompleteBlock = ^(){
        [self selectDefaultRow];
        [self setPickerValue];
    };

    if(timeSetterType == 1 || timeSetterType == 2){
        [numberPicker setFrame:CGRectMake(0, self.view.window.bounds.size.height, numberPicker.frame.size.width, numberPicker.frame.size.height)];
        [self.view.window addSubview:numberPicker];
        animBlock = ^(){
            [numberPicker setFrame:CGRectMake(0, self.view.window.bounds.size.height - numberPicker.frame.size.height, numberPicker.frame.size.width, numberPicker.frame.size.height)];
        };
    }else{
        [datePicker setFrame:CGRectMake(0, self.view.window.bounds.size.height, datePicker.frame.size.width, datePicker.frame.size.height)];
        [self.view.window addSubview:datePicker];
        animBlock = ^(){
            [datePicker setFrame:CGRectMake(0, self.view.window.bounds.size.height - datePicker.frame.size.height, datePicker.frame.size.width, datePicker.frame.size.height)];
        };

    }
    
    [UIView beginAnimations:@"RaiseKeyBoard" context:nil];
    [UIView animateWithDuration:0.3 animations:animBlock completion:^(BOOL finished){
        animCompleteBlock();
    }];
    [UIView commitAnimations];
}

- (void) releaseKeyBoard:(EZOperationBlock)completeBlock
{
    EZOperationBlock animBlock = ^(){
        [numberPicker setFrame:CGRectMake(0, 480, numberPicker.frame.size.width, numberPicker.frame.size.height)];
    };
    
    
    EZOperationBlock competeBlock = ^(){
        [numberPicker removeFromSuperview];
        numberPicker = nil;
        if(completeBlock){
            completeBlock();
        }

    };
    
    if(timeSetterType == 3){
        animBlock = ^(){
            [datePicker setFrame:CGRectMake(0, 480, datePicker.frame.size.width, datePicker.frame.size.height)];
        };
        
        competeBlock = ^(){
            [datePicker removeFromSuperview];
            datePicker = nil;
            if(completeBlock){
                completeBlock();
            }
            
        };

    }
    
    [UIView beginAnimations:@"Hide Keyboard" context:nil];
    [UIView animateWithDuration:0.3 animations:animBlock completion:^(BOOL finished){
        competeBlock();
    }];
    [UIView commitAnimations];
}

//The purpose of this is to make sure the animation could be seen by user
- (void) selectDefaultRow
{
    EZDEBUG(@"selectDefaultRow get called");
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    //self.selected = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    EZDEBUG(@"pickerView didSelectRow:row:%i, component:%i", row, component);
    UITableViewCell* cell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if(timeSetterType == 1){
        NSInteger hours = 0;
        if(component == 0){
            NSInteger setHours = [numberPicker.picker selectedRowInComponent:1];
            hours = row*24 + setHours;
        }else{
            NSInteger setDays = [numberPicker.picker selectedRowInComponent:0];
            hours = setDays*24 + row;
            
        }
        quotas.quotasPerCycle = hours*60;
        cell.detailTextLabel.text = [NSString stringWithFormat:EZLocalizedString(@"%i hours", nil), hours];
        
    }else{
        quotas.cycleLength = row;
        cell.detailTextLabel.text = [NSString stringWithFormat:EZLocalizedString(@"%i days", nil), row];
    }
}


- (void) doneClicked
{
    [self releaseKeyBoard:^(){
        if(doneBlock){
            doneBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void) cancelClicked
{
    [self releaseKeyBoard:^(){
        [self.navigationController popViewControllerAnimated:YES];
    }];
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


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(timeSetterType == 1){
        return 2;
    }else{
        return 1;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%i",row];
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(timeSetterType == 1){
        if(component == 0){
            if(quotas.cycleType == WeekCycle){
                return 7;
            }else if(quotas.cycleType == MonthCycle){
                return 30;
            }else{
                return quotas.cycleLength;
            }
        }else{
            return 24;
        }
        
    }else{
        return 365;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if(timeSetterType == 1){
        cell.textLabel.text = EZLocalizedString(@"Goal", nil);
        cell.detailTextLabel.text = [NSString stringWithFormat: EZLocalizedString(@"%i hours",nil),quotas.quotasPerCycle/60];
    }else if(timeSetterType == 2){
        cell.textLabel.text = EZLocalizedString(@"Cycle Length", nil);
        cell.detailTextLabel.text = [NSString stringWithFormat:EZLocalizedString(@"%i days", nil),quotas.cycleLength];
    }else if(timeSetterType == 3){
        cell.textLabel.text = EZLocalizedString(@"Cycle start", nil);
        cell.detailTextLabel.text = [quotas.cycleStartDay stringWithFormat:@"yyyy-MM-dd"];
    }
    EZDEBUG(@"The numberPicker is %@", numberPicker);
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"didSelectRowAtIndexPath:%@",indexPath);
    if(timeSetterType == 1){
        [numberPicker.picker selectRow:quotas.quotasPerCycle/24 inComponent:0 animated:YES];
        [numberPicker.picker selectRow:quotas.quotasPerCycle%24 inComponent:1 animated:YES];
    }else if(timeSetterType == 2){
        [numberPicker.picker selectRow:quotas.cycleLength inComponent:0 animated:YES];
    }
}
@end
