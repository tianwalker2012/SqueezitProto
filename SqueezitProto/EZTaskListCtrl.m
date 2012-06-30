//
//  EZTaskListCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTaskListCtrl.h"
#import "EZTaskGroup.h"
#import "EZCoreAccessor.h"
#import "EZTaskGroupDetailCtrl.h"
#import "EZTaskStore.h"
#import "MTaskGroup.h"
#import "EZTaskGroupCell.h"
#import "EZEditLabelCellHolder.h"
#import "EZGlobalLocalize.h"
#import "EZPureEditCell.h"
#import "EZTaskHelper.h"


@interface EZTaskListCtrl ()
{
    //EZOperationBlock smallBlock;
    NSIndexPath* previousDestine;
}


- (NSIndexPath*) textFieldToIndexPath:(UITextField*)field;

//It is more test oriented function than product oriented function
//The reason I have the function is that, TableView have issue to reload during 
//Edit status.
//One possibility I didn't explore is that if I explicitly setup the cell to editing status, will it change it's behavior?
//Let's try later.For time being let's get this refresh done.
- (void) refreshCellForIndex:(NSIndexPath*)path;

@end

@implementation EZTaskListCtrl
@synthesize editButton, doneButton, operation;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
        self.editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editClicked:)];
        self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editClicked:)];
        self.navigationItem.rightBarButtonItem = editButton;
        //[[NSBundle mainBundle] loadNibNamed:@"EZAddCell" owner:self options:nil];
        //assert(addCellView != nil);
        //EZDEBUG(@"Load the Xib successfully");
    }
    return self;
}


- (void) editClicked:(id)sender
{
    
    EZDEBUG(@"Edit get called:%@",sender);
    if(self.tableView.editing){
        self.navigationItem.rightBarButtonItem = editButton;
        [self.tableView setEditing:FALSE animated:YES];
    }else{
        self.navigationItem.rightBarButtonItem = doneButton;
        [self.tableView setEditing:TRUE animated:YES];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    taskGroups = [NSMutableArray arrayWithArray:[[EZTaskStore getInstance] fetchAllWithVO:[EZTaskGroup class] PO:[MTaskGroup class] sortField:@"displayOrder"]];

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
    EZDEBUG(@"numberOfRowsInSection get called");
    return taskGroups.count + 1;
}

- (void) refreshCellForIndex:(NSIndexPath*)path
{
    EZTaskGroupCell* tgCell = (EZTaskGroupCell*)[self.tableView cellForRowAtIndexPath:path];
    EZTaskGroup* taskGroup = [taskGroups objectAtIndex:path.row];
    
    EZDEBUG(@"Cell's orginal text:%@, replace text:%@, orginal groupInfo:%@",tgCell.titleField.text, taskGroup.name, tgCell.groupInfo.text);
    
    tgCell.titleField.text = taskGroup.name;
    tgCell.groupInfo.text = [NSString stringWithFormat:@"Tasks:%i, displayOrder:%i",[taskGroup.tasks count], taskGroup.displayOrder];
    //tgCell.titleField.placeholder = Local(@"Task Group Name...");

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"cellForRowAtIndexPath:%@",indexPath);
    if(indexPath.row >= [taskGroups count]){
        static NSString* insertIdentifier = @"PureEdit";
        EZPureEditCell *cell = [tableView dequeueReusableCellWithIdentifier:insertIdentifier];
        if(!cell){
            cell = [EZEditLabelCellHolder createPureEditCellWithDelegate:self];
        }
        cell.placeHolder = Local(@"Task Group Name...");
        cell.isChangeWithCellEdit = true;
        cell.identWhileEdit = true;
        return cell;
    }
    
    static NSString *CellIdentifier = @"TaskGroup";
    EZTaskGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [EZEditLabelCellHolder createTaskGroupCellWithDelegate:self];
        //cell.editingStyle = UITableViewCellEditingStyleDelete;
    }
    EZTaskGroup* taskGroup = [taskGroups objectAtIndex:indexPath.row];
    
    cell.titleField.text = taskGroup.name;
    cell.groupInfo.text = [NSString stringWithFormat:@"Tasks:%i, displayOrder:%i",[taskGroup.tasks count], taskGroup.displayOrder];
    cell.titleField.placeholder = Local(@"Task Group Name...");
    return cell;
}


//Check if some cell is moveable or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    EZDEBUG(@"canMoveRowAtIndexPath:%i",indexPath.row);
    if(indexPath.row < [taskGroups count]){
        return true;
    }
    return false;
}
//Move get called
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    EZDEBUG(@"TableView cell move get called, sourceIndex row:%i, destinationRow:%i, previousDestine:%i", sourceIndexPath.row, proposedDestinationIndexPath.row, previousDestine.row);
    
    if(proposedDestinationIndexPath.row >= taskGroups.count){
        proposedDestinationIndexPath = [NSIndexPath indexPathForRow:taskGroups.count - 1 inSection:0];
    }
    if(previousDestine == nil){
        previousDestine = sourceIndexPath;
    }
    
    EZTaskGroup* srcGroup = [taskGroups objectAtIndex:previousDestine.row];
    EZTaskGroup* proposedGroup = [taskGroups objectAtIndex:proposedDestinationIndexPath.row];
    NSInteger srcOrder = srcGroup.displayOrder;
    srcGroup.displayOrder = proposedGroup.displayOrder;
    proposedGroup.displayOrder = srcOrder;
    [taskGroups exchangeObjectAtIndex:previousDestine.row withObjectAtIndex:proposedDestinationIndexPath.row];
    previousDestine = proposedDestinationIndexPath;
    return proposedDestinationIndexPath;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    EZDEBUG(@"moveRowAtIndexPath, fromIndex row:%i, toIndex row:%i, previousDestine:%i", fromIndexPath.row, toIndexPath.row, previousDestine.row);
    [self performBlock:^(){
        [self refreshCellForIndex:fromIndexPath];
        [self refreshCellForIndex:toIndexPath];
    } withDelay:0.3];
    //Better store the whole thing
    [[EZTaskStore getInstance] storeObjects:taskGroups];
    //Make the next movement normal.
    previousDestine = nil;
}

/**
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"Some called if row %i is editable",indexPath.row);
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.row < [taskGroups count]){
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if(tableView.isEditing){
            [self setCellTextField:cell enabled:true];
        }else{
            [self setCellTextField:cell enabled:false];
        }
        return YES;
    }
    return NO;
}
**/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [taskGroups count]){
        return UITableViewCellEditingStyleDelete;
    } 
    return UITableViewCellEditingStyleNone;
}


//What's the effect.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    EZDEBUG(@"AlertView get called, button id:%i",buttonIndex);
    if(buttonIndex > 0){
        self.operation();
        self.operation = nil;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"commitEditingStyle get called, row:%i", indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        EZTaskGroup* tg = [taskGroups objectAtIndex:indexPath.row];
            UIAlertView* alamView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:EZLocalizedString(@"Delete \"%@\"?",nil),tg.name] message:[NSString stringWithFormat: EZLocalizedString(@"This will permanently delete all tasks in \"%@\".", nil),tg.name] delegate:self cancelButtonTitle:EZLocalizedString(@"Cancel",nil) otherButtonTitles:EZLocalizedString(@"Delete",nil), nil];
            NSMutableArray* groups = taskGroups;
            self.operation = ^(){
                EZDEBUG(@"Operation get called");
                [groups removeObject:tg];
                [[EZTaskStore getInstance] removeObject:tg];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            [alamView show];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



//Collision check
- (BOOL) collisionCheck:(NSString*)groupName
{
    for(EZTaskGroup* taskGp in taskGroups){
        if([taskGp.name isEqualToString:groupName]){
            return true;
        }
    }
    return false;
}

//Will inform user something going on
- (void) fireAlarm:(NSString*)info delay:(NSTimeInterval)delay
{
    EZDEBUG(@"fireAlarm get called, with info:%@", info);
    alertView = [[UIAlertView alloc] initWithTitle:@"Input Errors" message:info delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alertView show];
    
    [self performSelector:@selector(cancelAlert) withObject:nil afterDelay:delay];
    
}

- (void) cancelAlert
{
    EZDEBUG(@"cancelAlert get called");
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    alertView = nil;
}

//1. Will resign the respond.[False, only resigned textField will call this method]
//2. Verify if it is a empty space, if it is do nothing.
//3. Do duplication check.
//4. Add the inserted TaskGroup to the Array,
//5. Store the added TaskGroup
//6. Ask the tableView to insert a line
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    EZDEBUG(@"didEndEditing, Text:%@", textField.text);
    NSIndexPath* path = [self textFieldToIndexPath:textField];
    NSString* trimmed = textField.text.trim;
    if(path.row < taskGroups.count){
        EZTaskGroup* tg = [taskGroups objectAtIndex:path.row];
        if([trimmed isEqualToString:@""]){
            //If the modified place is only space, then nothing will be changed
            textField.text = tg.name;
            return;
        }
        tg.name = trimmed;
        [[EZTaskStore getInstance] storeObject:tg];
    }else{
        if([trimmed isEqualToString:@""]){
            textField.text = @"";
            return;
        }
        EZTaskGroup* tg = [[EZTaskGroup alloc] init];
        tg.name = trimmed;
        tg.displayOrder =  ((EZTaskGroup*)taskGroups.lastObject).displayOrder + 1;
        [[EZTaskStore getInstance] storeObject:tg];
        [taskGroups addObject:tg];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:taskGroups.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        textField.text = @"";
    }
    //[textField becomeFirstResponder];
}

- (NSIndexPath*) textFieldToIndexPath:(UITextField*)field
{
    CGRect rect = [self.tableView convertRect:field.frame fromView:field.superview];
    return  [[self.tableView indexPathsForRowsInRect:rect] objectAtIndex:0];
}

// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //EZDEBUG(@"ShouldReturn get called:%@",textField.text);
    [textField resignFirstResponder];
    return TRUE;
}



#pragma mark - Table view delegate
- (void) backTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"didSelect get calld, indexPath.row:%i, taskGroups.count:%i",indexPath.row,taskGroups.count);
    if(indexPath.row < taskGroups.count){
        EZTaskGroup* tgrp = [taskGroups objectAtIndex:indexPath.row];
        EZTaskGroupDetailCtrl* tgc = [[EZTaskGroupDetailCtrl alloc] initWithStyle:UITableViewStylePlain];
        tgc.taskGroup = tgrp;
        tgc.superUpdateBlock = ^(){
            [tgrp refresh];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
        };
        [self.navigationController pushViewController:tgc animated:YES];
    }
}

@end
