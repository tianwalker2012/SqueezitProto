//
//  EZTaskGroupDetailCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTaskGroupDetailCtrl.h"
#import "EZTaskGroup.h"
#import "EZTask.h"
#import "EZTaskDetailCtrl.h"
#import "EZGlobalLocalize.h"
#import "EZPureEditCell.h"
#import "EZEditLabelCellHolder.h"
#import "EZTaskStore.h"
#import "EZTaskHelper.h"

@interface EZTaskGroupDetailCtrl ()

- (UITableViewCell*) generateEditCell:(NSIndexPath*)indexPath;

- (void) addClicked;

- (void) backClicked;

@end

@implementation EZTaskGroupDetailCtrl
@synthesize editField, taskGroup, barType, superUpdateBlock, tasks;

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClicked)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleBordered target:self action:@selector(backClicked)];
    //self.navigationItem.leftBarButtonItem
    //self.barType = UIBarButtonSystemItemDone;
    //[self performSelector:@selector(changeLeftBarButton) withObject:nil afterDelay:1];
}

- (void) backClicked
{
    EZDEBUG(@"Back get clicked");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addClicked 
{
    EZDEBUG(@"Add clicked");
    [self.editField becomeFirstResponder]; 
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
    return [taskGroup.tasks count]+1;
}


- (UITableViewCell*) generateEditCell:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"PureEdit";
    EZPureEditCell *pureCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(pureCell == nil){
        pureCell = [EZEditLabelCellHolder createPureEditCellWithDelegate:self];
        pureCell.placeHolder = EZLocalizedString(@"Task name ...", nil);
        self.editField = pureCell.editField;
    }
    //pureCell.isChangeWithCellEdit = true;
    pureCell.isFieldEditable = true;
    self.editField.text = @"";
    return pureCell;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    EZDEBUG(@"textFieldShouldBeginEditing, backBarItem:%@, navController backBarItem:%@",self.navigationItem.backBarButtonItem, self.navigationController.navigationItem.backBarButtonItem);
    self.navigationItem.leftBarButtonItem.enabled = false;
    return true;
}
//Baically what should be done in this method
//1.If the input only space, then remove the space and hold the focus
//2.If it is a valid name, I will create a task and insert the task into 
//The task group and store the taskGroup.
//3. Call the tableView to insert a cell.
//Done. Simple and stupid and happy. 
//4. Then let's the cell get the focus back of course. 
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.navigationItem.leftBarButtonItem.enabled = true;
    NSString* trimmed = textField.text.trim;
    EZDEBUG(@"didEndEditing, trimmed:%@", trimmed);
    if([trimmed isEqualToString:@""]){
        textField.text = @"";
        //[textField becomeFirstResponder];
        return;
    }
    EZDEBUG(@"Not empty, go ahead store it");
    EZTask* newTask = [[EZTask alloc] initWithName:trimmed];
    [self.tasks addObject:newTask];
    self.taskGroup.tasks = [NSMutableArray arrayWithArray:self.tasks];
    [[EZTaskStore getInstance] storeObject:taskGroup];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject: [NSIndexPath indexPathForRow:taskGroup.tasks.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
    
    [self.tableView endUpdates];
    
    //Inform the up layer that we added new object
    self.superUpdateBlock();
    textField.text = @"";
    [textField becomeFirstResponder];
    
}

//I assume a member variable get created too.
//ARC should have done this automatically.
- (void) setTaskGroup:(EZTaskGroup *)tg
{
    taskGroup = tg;
    self.tasks = [NSMutableArray arrayWithArray:taskGroup.tasks];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    EZDEBUG(@"textFieldShouldReturn get called");
    [textField resignFirstResponder];
    return TRUE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row >= tasks.count){
        return [self generateEditCell:indexPath];
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    EZTask* task = [self.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = task.name;
    
    if(task.duration == task.maxDuration){
        cell.detailTextLabel.text = [NSString stringWithFormat:EZLocalizedString(@"Consume %i minutes each time", nil),task.duration];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:EZLocalizedString(@"Consume %i to %i minutes each time", nil),task.duration, task.maxDuration];
        
    }
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
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
*/

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

//I assume by return nil, it will not get selected.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"willSelectRowAtIndexPath get called");
    if(indexPath.row < self.taskGroup.tasks.count){
        return indexPath;
    }
    
    return nil;
}

- (void) removeCellAtIndex:(NSIndexPath*)path
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:YES];
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZTask* task = [self.tasks objectAtIndex:indexPath.row];
    
    EZDEBUG(@"Task Name:%@, row:%i", task.name, indexPath.row);
    EZTaskDetailCtrl* td = [[EZTaskDetailCtrl alloc] initWithStyle:UITableViewStyleGrouped];
    td.task = task;
    td.superDeleteBlock = ^(){
        [self.tasks removeObjectAtIndex:indexPath.row];
        self.taskGroup.tasks = [NSMutableArray arrayWithArray:self.tasks];
        //The reason I do this because the store have side effect
        [[EZTaskStore getInstance] storeObject:self.taskGroup];
        [[EZTaskStore getInstance] removeObject:task];
        [self performSelector:@selector(removeCellAtIndex:) withObject:indexPath afterDelay:0.3];
        self.superUpdateBlock();
    };
    
    td.superUpdateBlock = ^(){
        [task refresh];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
    };
    [self.navigationController pushViewController:td animated:YES];
    
}

@end
