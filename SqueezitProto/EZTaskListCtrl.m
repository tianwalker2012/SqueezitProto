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
#import "EZEditCell.h"
#import "EZTaskGroupCell.h"
#import "EZEditLabelCellHolder.h"
#import "EZGlobalLocalize.h"


@interface EZTaskListCtrl ()

@end

@implementation EZTaskListCtrl
@synthesize editButton, doneButton, addCell, addCellView, inputGroupName, operation;

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
        self.addCellView.editField.placeholder = @"";
        self.addCellView.editField.userInteractionEnabled = false;
        [self.tableView setEditing:FALSE animated:YES];
    }else{
        self.navigationItem.rightBarButtonItem = doneButton;
        self.addCellView.editField.placeholder = @"Add Task Group...";
        self.addCellView.editField.userInteractionEnabled = TRUE;
        [self.tableView setEditing:TRUE animated:YES];
    }
}

- (void) setCellTextField:(UITableViewCell*)cell enabled:(BOOL)enabled
{
    //EZDEBUG(@"Cell class:%@", NSStringFromClass([cell class]));
    if([@"EZTaskGroupCell" isEqualToString:NSStringFromClass([cell class])]){
        EZTaskGroupCell* tgCell = (EZTaskGroupCell*)cell;
        //EZDEBUG(@"Before get title field");
        tgCell.titleField.userInteractionEnabled = enabled;
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
    return [taskGroups count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row >= [taskGroups count]){
        static NSString* insertIdentifier = @"EditCell";
        EZEditCell *cell = [tableView dequeueReusableCellWithIdentifier:insertIdentifier];
        if(!cell){
            
            [[NSBundle mainBundle] loadNibNamed:@"EZAddCell" owner:self options:nil];
            cell = self.addCellView;
            cell.editField.userInteractionEnabled = false;
            //self.addCellView = ;
        }
        //cell.editField.placeholder = @"Task Group Name";
        //cell.textLabel.text = @"Add group";
        return cell;
    }
    
    static NSString *CellIdentifier = @"groupCell";
    EZTaskGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [EZEditLabelCellHolder createTaskGroupCellWithDelegate:self];
        //cell.editingStyle = UITableViewCellEditingStyleDelete;
    }
    EZDEBUG(@"Before get title field");
    cell.titleField.userInteractionEnabled = false;
    EZTaskGroup* taskGroup = [taskGroups objectAtIndex:indexPath.row];
    
    cell.titleField.text = taskGroup.name;
    cell.groupInfo.text = [NSString stringWithFormat:@"Tasks:%i, displayOrder:%i",[taskGroup.tasks count], taskGroup.displayOrder];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell..
    
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
    EZDEBUG(@"TableView cell move get called, sourceIndex row:%i, destinationRow:%i", sourceIndexPath.row, proposedDestinationIndexPath.row);
    
    if(proposedDestinationIndexPath.row < [taskGroups count]){
        return proposedDestinationIndexPath;
    }
    return [NSIndexPath indexPathForRow:[taskGroups count]-1 inSection:0];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    EZDEBUG(@"moveRowAtIndexPath, fromIndex row:%i, toIndex row:%i", fromIndexPath.row, toIndexPath.row);
    EZTaskGroup* fromGroup = [taskGroups objectAtIndex:fromIndexPath.row];
    EZTaskGroup* toGroup = [taskGroups objectAtIndex:toIndexPath.row]; 
    fromGroup.displayOrder = toIndexPath.row;
    toGroup.displayOrder = fromIndexPath.row;
    
    [taskGroups exchangeObjectAtIndex:toIndexPath.row withObjectAtIndex:fromIndexPath.row];
    [[EZTaskStore getInstance] storeObject:fromGroup];
    [[EZTaskStore getInstance] storeObject:toGroup];
}

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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return TRUE;
}

// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Need to do nothing here, why override it? For fun?
}


//What need to be done in this method?
//1. If is empty, will resume the original text back.
//2. If it is collid with existing title will flash a alert, Don't resign the responder.
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    EZDEBUG(@"ShouldEndEditing Called, text:%@",textField.text);
    return TRUE;
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

- (void) addCellCalled:(UITextField*)textField
{
    NSString* groupName = textField.text;
    NSString* trimmedName = groupName.trim;
    if(trimmedName.length == 0){
        //[self fireAlarm:@"Space not valid name" delay:1];
        textField.text = @"";
        [textField becomeFirstResponder];
        return;
    }
    if([self collisionCheck:trimmedName]){
        [self fireAlarm:@"Duplicated group name" delay:1];
        [textField becomeFirstResponder];
        return;
    }
    EZTaskGroup* newGroup = [[EZTaskGroup alloc] init];
    newGroup.name = trimmedName;
    newGroup.createdTime = [NSDate date];
    newGroup.displayOrder = [taskGroups count];
    textField.text = @"";
    [[EZTaskStore getInstance] storeObject:newGroup];
    [taskGroups addObject:newGroup];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[taskGroups count] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (NSIndexPath*) getIndexByTextField:(UITextField*) field
{
    CGRect frame = [self.tableView convertRect:field.frame fromView:field.superview];
    NSArray* indexPaths = [self.tableView indexPathsForRowsInRect:frame];
    NSLog(@"The count is %i",[indexPaths count]);
    assert([indexPaths count] == 1);
    return [indexPaths objectAtIndex:0];
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
    if(textField == addCellView.editField){
        EZDEBUG(@"AddCell get called");
        [self addCellCalled:textField];
    }else{
        NSIndexPath* path = [self getIndexByTextField:textField];
        EZTaskGroup* tg = [taskGroups objectAtIndex:path.row];
        NSString* trimmed = textField.text.trim;
        if([trimmed isEqualToString:@""]){
            //If the modified place is only space, then nothing will be changed
            textField.text = tg.name;
            return;
        }
        tg.name = trimmed;
        [[EZTaskStore getInstance] storeObject:tg];
    }
    //[textField becomeFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //EZDEBUG(@"Changed:%@",string);
    return TRUE;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //EZDEBUG(@"ShouldClear");
    return TRUE;
}
// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    EZDEBUG(@"ShouldReturn get called:%@",textField.text);
    [textField resignFirstResponder];
    return TRUE;
}



#pragma mark - Table view delegate
- (void) backTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


//Do not allow user to select the edit row
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [taskGroups count]){
        return indexPath;
    }
    EZTaskGroupCell* groupCell = (EZTaskGroupCell*)[tableView cellForRowAtIndexPath:indexPath];
    //My one cents to UX
    [groupCell.titleField becomeFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZTaskGroup* tgrp = [taskGroups objectAtIndex:indexPath.row];
    EZTaskGroupDetailCtrl* tgc = [[EZTaskGroupDetailCtrl alloc] initWithStyle:UITableViewStylePlain];
    tgc.taskGroup = tgrp;
    tgc.superUpdateBlock = ^(){
        EZDEBUG(@"SuperUpdateBlock get called, before refresh count:%i",tgrp.tasks.count);
        [tgrp refresh];
        EZDEBUG(@"after refresh count:%i",tgrp.tasks.count);
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
    };
    [self.navigationController pushViewController:tgc animated:YES];
}

@end
