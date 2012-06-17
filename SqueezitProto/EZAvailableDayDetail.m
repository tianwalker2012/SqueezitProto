//
//  EZAvailableDayDetail.m
//  SqueezitProto
//
//  Created by Apple on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvailableDayDetail.h"
#import "EZAvailableDay.h"
#import "EZAvailableTime.h"
#import "EZAvTimeCell.h"
#import "EZAvTimeHeader.h"
#import "EZEditLabelCellHolder.h"
#import "EZPureEditCell.h"
#import "EZGlobalLocalize.h"
#import "EZTaskHelper.h"
#import "EZTaskStore.h"
#import "EZKeyBoardHolder.h"
#import "EZPickerKeyboardDate.h"


@interface EZAvailableDayDetail () {
    UIBarButtonItem* editButton;
    UIBarButtonItem* doneButton;
    EZAvTimeHeader* header;
    EZPickerWrapper* assignDatePicker;
    EZPickerKeyboardDate* dateKeyboard;
    UITableViewCell* dateCell;
    NSDate* assignDate;
}

- (void) addAvTime;

- (void) setBackButton;

- (void) editClicked;

- (void) enableAddButton:(BOOL)enable;

- (void) sortAvTime:(NSMutableArray*)times;

- (void) pickerChanged:(UIDatePicker*)picker;

@end

@implementation EZAvailableDayDetail
@synthesize updateBlock, avDay;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Sort the time according to time sequence
- (void) sortAvTime:(NSMutableArray*)times
{
    [times sortUsingComparator:
     ^(EZAvailableTime* t1, EZAvailableTime* t2){
         return [t1.start compare:t2.start];
     }
     ];
     
}

- (void) editClicked
{
    if(self.tableView.isEditing){
        self.navigationItem.rightBarButtonItem = editButton;
    }else{
        self.navigationItem.rightBarButtonItem = doneButton;
    }
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    [self enableAddButton:self.tableView.isEditing];
}

//Animate the process of enable the addButton
- (void) enableAddButton:(BOOL)enable
{
    [header showButton:enable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editClicked)];
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editClicked)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    self.navigationItem.title = avDay.name;
    
    header = [EZEditLabelCellHolder createAvTimeHeader];
    header.title.text = Local(@"Available Times");
    [header.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [header setupCellWithButton:NO];
    [self sortAvTime:avDay.availableTimes];
    if(avDay.date){
        assignDate = avDay.date;
    }else{
        assignDate = [[NSDate date] adjustDays:2];
    }
}


//The add button on the header get clicked
- (IBAction) addButtonClicked:(id)sender
{
    EZDEBUG(@"Add Button get clicked");
}

- (void) addAvTime
{
    
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

//The section 0 was for the propeties of the AvailableDay.
//The section 1 was for the AvailableTimes
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 3;
    }
    return avDay.availableTimes.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //EZDEBUG(@"heightForHeaderInSection get called");
    if(section == 1){
        return 44;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            NSString* cellID = @"PureEdit";
            EZPureEditCell* editCell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
            if(editCell == nil){
                editCell = [EZEditLabelCellHolder createPureEditCellWithDelegate:self];
            }
            editCell.editField.text = avDay.name;
            editCell.editField.userInteractionEnabled = self.tableView.isEditing;
            return editCell;
        }else{
            NSString* cellID = @"propertyCell";
            UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
            if(cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            }
            if(indexPath.row == 1){
                cell.textLabel.text = Local(@"Assigned Week Day");
                cell.detailTextLabel.text = [EZTaskHelper weekFlagToWeekString:avDay.assignedWeeks];
            }else{
                cell.textLabel.text = Local(@"Assigned Date");
                cell.detailTextLabel.text = [avDay.date stringWithFormat:@"yyyy-MMM-dd"];
            }
            cell.textLabel.textColor = [UIColor grayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }else{
        NSString* cellID = @"AvTime";
        EZAvTimeCell* timeCell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
        if(timeCell == nil){
            timeCell = [EZEditLabelCellHolder createAvTimeCell];
        }
        EZAvailableTime* avTime = [avDay.availableTimes objectAtIndex:indexPath.row];
        timeCell.name.text = avTime.name;
        timeCell.envLabel.text = envTraitsToString(avTime.envTraits);
        timeCell.startTime.text = [avTime.start stringWithFormat:@"HH:mm"];
        timeCell.endTime.text = [[avTime.start adjustMinutes:avTime.duration] stringWithFormat:@"HH:mm"];
        timeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return timeCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 44;
    }
    return 66;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        return true;
    }
    return false;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"Selected:%i", indexPath.row);
    if(indexPath.section == 0 && indexPath.row == 2){
        if(assignDatePicker == nil){
            assignDatePicker = [[EZPickerWrapper alloc] initWithStyle:UITableViewStyleGrouped];
        }
        assignDatePicker.wrapperDelegate = self;
        [self.navigationController pushViewController:assignDatePicker animated:YES];
    }
    //[self setBackButton];
}

#pragma mark - Picker change event
- (void) pickerChanged:(UIDatePicker*)picker
{
    assignDate = picker.date;
    dateCell.detailTextLabel.text = [assignDate stringWithFormat:@"yyyy-MMM-dd"];
}


#pragma mark - PickerWrapper delegate
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
    //For a single picker, no need to do anything
    //I suspect I will not get called
    [dateKeyboard.picker setDate:assignDate animated:YES];
    EZDEBUG(@"cellSelected get called");
    
}

- (UITableViewCell*) pickerWrapper:(EZPickerWrapper*)pickerWrapper getCell:(NSIndexPath*)path
{
    if(dateCell == nil){
        dateCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Date"];
    }
    dateCell.textLabel.text = Local(@"Assigned Date");
    dateCell.detailTextLabel.text = [assignDate stringWithFormat:@"yyyy-MMM-dd"];
    return dateCell;
}

//Will be used later when when have differnt keyboard for different indexPath
- (UIView*) pickerWrapper:(EZPickerWrapper*)pickerWrapper getKeyBoard:(NSIndexPath*)path
{
    EZDEBUG(@"getKeyboard get called");
    if(dateKeyboard == nil){
        dateKeyboard = [EZKeyBoardHolder createDateKeyboard];
        [dateKeyboard.picker setDatePickerMode:UIDatePickerModeDate];
        [dateKeyboard.picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return dateKeyboard;
}



- (void) doneClicked:(EZPickerWrapper*)pickerWrapper
{
    avDay.date = assignDate;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:YES];
}

- (void) cancelClicked:(EZPickerWrapper*)pickerWrapper
{
    EZDEBUG(@"Don't know what to do");
}

@end
