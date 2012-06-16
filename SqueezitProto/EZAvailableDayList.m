//
//  EZTimeSnippetList.m
//  SqueezitProto
//
//  Created by Apple on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvailableDayList.h"
#import "EZAvailableDay.h"
#import "MAvailableDay.h"
#import "EZTaskStore.h"
#import "EZGlobalLocalize.h"
#import "EZTaskGroupCell.h"
#import "EZEditLabelCellHolder.h"
#import "EZPureEditCell.h"
#import "EZAvailableDayDetail.h"

@interface EZAvailableDayList (){
    UIBarButtonItem* editButton;
    UIBarButtonItem* doneButton;
    EZPureEditCell* addCell;
    EZOperationBlock deleteBlock;
}

- (void) editClicked;

- (void) setAddFieldEditable:(BOOL)enabled;

@end

@implementation EZAvailableDayList
@synthesize avDays;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:3];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editClicked)];
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editClicked)];
 
    self.navigationItem.rightBarButtonItem = editButton;
    
    self.navigationItem.title = Local(@"Time Setting");
    avDays = [NSMutableArray arrayWithArray:[[EZTaskStore getInstance] fetchAllWithVO:[EZAvailableDay class] po:[MAvailableDay class] sortField:@"displayOrder"]];
    
}

- (void) editClicked
{
    if(self.tableView.isEditing){
        self.navigationItem.rightBarButtonItem = editButton;
        [self.tableView setEditing:NO animated:YES];
        [self setAddFieldEditable:NO];
    }else{
        self.navigationItem.rightBarButtonItem = doneButton;
        [self.tableView setEditing:YES animated:YES];
        [self setAddFieldEditable:YES];
    }
}

- (void) setAddFieldEditable:(BOOL)enabled
{
    addCell.editField.userInteractionEnabled = enabled;
    if(enabled){
        addCell.editField.placeholder = Local(@"Time snippet name...");
    }else{
        addCell.editField.placeholder = @"";
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return avDays.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    //Mean this is the data row. 
    if(indexPath.row < avDays.count){
        NSString *CellIdentifier = @"groupCell";
        EZTaskGroupCell* gCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(gCell == nil){
            gCell = [EZEditLabelCellHolder createTaskGroupCellWithDelegate:self];
        }
        gCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        EZAvailableDay* avd = [avDays objectAtIndex:indexPath.row];
        gCell.titleField.text = avd.name;
        if(avd.date){
            gCell.groupInfo.text = [avd.date stringWithFormat:@"yyyyMMdd"];
        }else{
            gCell.groupInfo.text = [EZTaskHelper weekFlagToWeekString:avd.assignedWeeks];
        }
        gCell.titleField.userInteractionEnabled = self.tableView.isEditing;
        cell = gCell;
    }else{
        addCell = [EZEditLabelCellHolder createPureEditCellWithDelegate:self];
        [self setAddFieldEditable:self.tableView.isEditing];
        cell = addCell;
        
    }
    // Configure the cell...
    
    return cell;
}

//Now just assume only the add get called.
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    EZDEBUG(@"The final text is:%@", textField.text);
    CGRect textFrame = [self.tableView convertRect:textField.frame fromView:textField.superview];
    NSArray* indexPaths = [self.tableView indexPathsForRowsInRect:textFrame];
    EZDEBUG(@"textFrame:%@, textFrame in tableView:%@,tableView bounds:%@",NSStringFromCGRect(textField.frame),NSStringFromCGRect(textFrame),self.tableView.bounds);
    assert(indexPaths.count == 1);
    NSIndexPath* indexPath = [indexPaths objectAtIndex:0];
    if(indexPath.row < avDays.count){
        EZAvailableDay* editedDay = [avDays objectAtIndex:indexPath.row];
        EZDEBUG(@"Try edit existing %@ to %@",editedDay.name, textField.text);
        editedDay.name = textField.text;
        [[EZTaskStore getInstance] storeObject:editedDay];
    }else{
    
        EZAvailableDay* addedDay = [[EZAvailableDay alloc] initWithName:textField.text weeks:0];
        EZDEBUG(@"Added day:%@", addedDay.name);
        EZAvailableDay* lastDay = [avDays lastObject];
        addedDay.displayOrder = lastDay.displayOrder+1;
        [avDays addObject:addedDay];
        [[EZTaskStore getInstance] storeObject:addedDay];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:avDays.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        textField.text = @"";
    }
    EZDEBUG(@"End of didEndEditing");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;  
{
    EZDEBUG(@"Return get called");
    [textField resignFirstResponder];
    return true;
}

//Delete confimation button clicked
//I assume only one type of alertView raise in this controller.
//So far is ok
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        EZDEBUG(@"Cancel get called");
    }else{
        EZDEBUG(@"Delete confirmed");
        if(deleteBlock){
            deleteBlock();
        }
    }
    deleteBlock = nil;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        EZAvailableDay* day = [avDays objectAtIndex:indexPath.row];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete \"%@\"?", day.name] message:[NSString stringWithFormat:@"Delete \"%@\" will lose will the time snippet setting with it.", day.name] delegate:self cancelButtonTitle:Local(@"Cancel") otherButtonTitles:Local(@"Delete"), nil];
        NSMutableArray* targetDays = avDays;
        
        deleteBlock = ^(){
            [targetDays removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];    
        };
        
        [alert show];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


//This method will get called everytime the cell become editable
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"canEditRowAtIndexPath if row %i",indexPath.row);
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.row < avDays.count){
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        //Do things here?
        //It is weired, you should admit, right?
        if([cell isKindOfClass:[EZTaskGroupCell class]]){
            EZTaskGroupCell* existCell = (EZTaskGroupCell*)cell;
            if(tableView.isEditing){
                existCell.titleField.userInteractionEnabled = true;
            }else{
                existCell.titleField.userInteractionEnabled = false;
            }   
        }else{
            EZDEBUG(@"AddCell index within availableDay count %i, index:%i",avDays.count, indexPath.row);
        }
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.row < avDays.count){
        return YES;
    }
    return NO;
}

//Make sure the move will not beyond the range
- (NSIndexPath*) tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if(proposedDestinationIndexPath.row < avDays.count){
        return proposedDestinationIndexPath;
    }else{
        return [NSIndexPath indexPathForRow:avDays.count-1 inSection:0];
    }
}

// Override to support rearranging the table view.
// Assume only valid Array index will reach me. 
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    EZDEBUG(@"Will exchange %i with %i",fromIndexPath.row, toIndexPath.row);
    EZAvailableDay* fromDay = [avDays objectAtIndex:fromIndexPath.row];
    EZAvailableDay* toDay = [avDays objectAtIndex:toIndexPath.row];
    EZDEBUG(@"From name:%@, move to:%@",fromDay.name, toDay.name);
    [avDays exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}




#pragma mark - Table view delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < avDays.count){
        return indexPath;
    }
    return nil;
}



//Assume all the selected row are within the range of the availableDay Array
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZAvailableDay* avDay = [avDays objectAtIndex:indexPath.row];
    EZAvailableDayDetail* detailPage = [[EZAvailableDayDetail alloc] initWithStyle:UITableViewStyleGrouped];
    detailPage.avDay = avDay;
    detailPage.updateBlock = ^(){
        [self.tableView reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationFade];
    };
   [self.navigationController pushViewController:detailPage animated:YES];
}

@end
