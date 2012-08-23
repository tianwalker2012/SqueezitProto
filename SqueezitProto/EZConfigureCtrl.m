//
//  EZConfigureCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZConfigureCtrl.h"
#import "EZGlobalLocalize.h"
#import "EZTaskStore.h"
#import "Constants.h"
#import "EZEnvTagCtrl.h"
#import "EZPickerKeyboardDate.h"
#import "EZKeyBoardHolder.h"
#import "EZAlarmUtility.h"

@interface EZConfigureCtrl ()
{
    EZPickerKeyboardDate* keyboard;
    EZPickerWrapper* pickerWrapper;
}

@end

@implementation EZConfigureCtrl

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:4];
        self.tabBarItem.title = Local(@"Setting"); 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    EZDEBUG(@"CallStack:%@", [NSThread callStackSymbols]);
    self.navigationItem.title = Local(@"Configuration");
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    if(indexPath.section == 0){
        NSString* cellID = @"Normal";
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = Local(@"Environment Tags");
    } else {
        NSString* cellID = @"ValueSetting";
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        UILocalNotification* notification = [[EZTaskStore getInstance] getDailyNotification];
        cell.textLabel.text = Local(@"Daily schedule reminder");
        cell.detailTextLabel.text = [notification.fireDate stringWithFormat:@"HH:mm"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"selected section:%i", indexPath.section);
    if(indexPath.section == 0){
        EZEnvTagCtrl* etc = [[EZEnvTagCtrl alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:etc animated:YES];
    }else if(indexPath.section == 1){
        pickerWrapper = [[EZPickerWrapper alloc] initWithStyle:UITableViewStyleGrouped];
        pickerWrapper.wrapperDelegate = self;
        pickerWrapper.speedupWin = self.view.window;
        [self.navigationController pushViewController:pickerWrapper animated:YES];
    }
}

//How many rows in this picker controller;
- (int) getRow:(EZPickerWrapper*)pickerWrapper
{
    return 1;
}

- (int) getSection:(EZPickerWrapper*)pickerWrapper
{
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
    EZPickerKeyboardDate* pickerDate = (EZPickerKeyboardDate*)keyboard;
    UILocalNotification* notification = [[EZTaskStore getInstance] getDailyNotification];
    pickerDate.picker.date = notification.fireDate;
}

- (UITableViewCell*) pickerWrapper:(EZPickerWrapper*)pickerWrapper getCell:(NSIndexPath*)path
{
    UITableViewCell* res = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AnyCell"];
    UILocalNotification* notification = [[EZTaskStore getInstance] getDailyNotification];
    res.textLabel.text = Local(@"Notification Time");
    res.detailTextLabel.text = [notification.fireDate stringWithFormat:@"HH:mm"];
    return res;
}

- (void) pickerChanged
{
    UITableViewCell* cell = [pickerWrapper.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = [keyboard.picker.date stringWithFormat:@"HH:mm"];
}
//Will be used later when when have differnt keyboard for different indexPath
- (UIView*) pickerWrapper:(EZPickerWrapper*)pickerWrapper getKeyBoard:(NSIndexPath*)path
{
    keyboard = [EZKeyBoardHolder createDateKeyboard];
    keyboard.picker.datePickerMode = UIDatePickerModeTime;
    //Should I setup the value? No need let's the animation do the job
    [keyboard.picker addTarget:self action:@selector(pickerChanged) forControlEvents:UIControlEventValueChanged];
    return keyboard;
}


//When the user changed the value in the picker, this delegate method will
//Get called
//The reason I comment it out is because it will hurt the generality.
//- (void) pickerValueChanged:(EZPickerWrapper *)pickerWrapper; 

- (void) doneClicked:(EZPickerWrapper*)pickerWrapper
{
    EZDEBUG(@"Done clicked:%@", [keyboard.picker.date stringWithFormat:@"yyyyMMdd HH:mm:ss"]);
    UILocalNotification* notification = [[EZTaskStore getInstance] getDailyNotification];
    notification.fireDate = keyboard.picker.date;
    [EZAlarmUtility setupDailyNotification:notification];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                 
}

- (void) cancelClicked:(EZPickerWrapper*)pickerWrapper
{
        
}

@end
