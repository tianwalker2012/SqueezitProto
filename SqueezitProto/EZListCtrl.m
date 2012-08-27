//
//  EZTaskListCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZListCtrl.h"
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
#import "EZAvailableDay.h"
#import "MAvailableDay.h"
#import "EZAvailableTime.h"
#import "MAvailableTime.h"
#import "EZAvailableDayDetail.h"


@interface EZListCtrl ()
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

- (void) setCellContent:(EZTaskGroupCell*)cell path:(NSIndexPath*)path;

- (void) exchangeValue:(NSInteger)from to:(NSInteger)to;

- (void) raiseDeletionAlert:(NSIndexPath*)path;

@end

@implementation EZListCtrl
@synthesize editButton, doneButton, operation, isServeTaskList;

- (id)initWithStyle:(UITableViewStyle)style isTasklist:(BOOL)tasklist
{
    self = [super initWithStyle:style];
    isServeTaskList = tasklist;
    if (self) {
        // Custom initialization
        //TODO will change it to different icon according to the 
        //Value it is serving.
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
    if(isServeTaskList){
        values = [NSMutableArray arrayWithArray:[[EZTaskStore getInstance] fetchAllWithVO:[EZTaskGroup class] PO:[MTaskGroup class] sortField:@"displayOrder"]];
    }else{
        values = [NSMutableArray arrayWithArray:[[EZTaskStore getInstance]fetchAllWithVO:[EZAvailableDay class] PO:[MAvailableDay class] sortField:@"displayOrder"]];
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
    EZDEBUG(@"numberOfRowsInSection get called");
    return values.count + 1;
}

- (void) refreshCellForIndex:(NSIndexPath*)path
{
    EZTaskGroupCell* tgCell = (EZTaskGroupCell*)[self.tableView cellForRowAtIndexPath:path];
    [self setCellContent:tgCell path:path];
}

- (void) setCellContent:(EZTaskGroupCell*)tgCell path:(NSIndexPath*)path
{
    if(isServeTaskList){
        EZTaskGroup* taskGroup = [values objectAtIndex:path.row];
        tgCell.titleField.text = taskGroup.name;
        tgCell.groupInfo.text = [NSString stringWithFormat:@"Tasks:%i, displayOrder:%i",[taskGroup.tasks count], taskGroup.displayOrder];
        tgCell.placeholder = Local(@"Task Group Name...");
    }else{
        EZAvailableDay* avDay = [values objectAtIndex:path.row];
        tgCell.titleField.text = avDay.name;
        tgCell.placeholder = Local(@"Available Day Name...");
        if(avDay.date){
            tgCell.groupInfo.text = [avDay.date stringWithFormat:@"yyyyMMdd"];
        }else{
            tgCell.groupInfo.text = [EZTaskHelper weekFlagToWeekString:avDay.assignedWeeks];
        }
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"cellForRowAtIndexPath:%@",indexPath);
    if(indexPath.row >= [values count]){
        static NSString* insertIdentifier = @"PureEdit";
        EZPureEditCell *cell = [tableView dequeueReusableCellWithIdentifier:insertIdentifier];
        if(!cell){
            cell = [EZEditLabelCellHolder createPureEditCellWithDelegate:self];
        }
        if(isServeTaskList){
            cell.placeHolder = Local(@"Task Group Name...");
        }else{
            cell.placeHolder = Local(@"Available Day Name...");
        }
        cell.isChangeWithCellEdit = true;
        cell.identWhileEdit = true;
        
        //Found the reason, there is identWhileEdit.
        [cell adjustRightPadding:41];
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"TaskGroup";
    EZTaskGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [EZEditLabelCellHolder createTaskGroupCellWithDelegate:self];
        //cell.editingStyle = UITableViewCellEditingStyleDelete;
    }
    [self setCellContent:cell path:indexPath];
    return cell;
}


//Check if some cell is moveable or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.row < [values count]){
        return true;
    }
    return false;
}
//Move get called
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    EZDEBUG(@"TableView cell move get called, sourceIndex row:%i, destinationRow:%i, previousDestine:%i", sourceIndexPath.row, proposedDestinationIndexPath.row, previousDestine.row);
    
    if(proposedDestinationIndexPath.row >= values.count){
        proposedDestinationIndexPath = [NSIndexPath indexPathForRow:values.count - 1 inSection:0];
    }
    if(previousDestine == nil){
        previousDestine = sourceIndexPath;
    }
    
    [self exchangeValue:previousDestine.row to:proposedDestinationIndexPath.row];
    previousDestine = proposedDestinationIndexPath;
    return proposedDestinationIndexPath;
}

- (void) exchangeValue:(NSInteger)from to:(NSInteger)to
{
    if(isServeTaskList){
        EZTaskGroup* srcGroup = [values objectAtIndex:from];
        EZTaskGroup* proposedGroup = [values objectAtIndex:to];
        NSInteger srcOrder = srcGroup.displayOrder;
        srcGroup.displayOrder = proposedGroup.displayOrder;
        proposedGroup.displayOrder = srcOrder;
    }else{
        EZAvailableDay* srcAv = [values objectAtIndex:from];
        EZAvailableDay* destAv = [values objectAtIndex:to];
        NSInteger srcOrder = srcAv.displayOrder;
        srcAv.displayOrder = destAv.displayOrder;
        destAv.displayOrder = srcOrder;
    }
    [values exchangeObjectAtIndex:from withObjectAtIndex:to];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    EZDEBUG(@"moveRowAtIndexPath, fromIndex row:%i, toIndex row:%i, previousDestine:%i", fromIndexPath.row, toIndexPath.row, previousDestine.row);
    [self performBlock:^(){
        [self refreshCellForIndex:fromIndexPath];
        [self refreshCellForIndex:toIndexPath];
    } withDelay:0.3];
    //Better store the whole thing
    [[EZTaskStore getInstance] storeObjects:values];
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
    if(indexPath.row < [values count]){
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

- (void) raiseDeletionAlert:(NSIndexPath *)indexPath
{
    if(isServeTaskList){
        EZTaskGroup* tg = [values objectAtIndex:indexPath.row];
        UIAlertView* alamView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:EZLocalizedString(@"Delete \"%@\"?",nil),tg.name] message:[NSString stringWithFormat: EZLocalizedString(@"This will permanently delete all tasks in \"%@\".", nil),tg.name] delegate:self cancelButtonTitle:EZLocalizedString(@"Cancel",nil) otherButtonTitles:EZLocalizedString(@"Delete",nil), nil];
        NSMutableArray* groups = values;
        self.operation = ^(){
            EZDEBUG(@"Operation get called");
            [groups removeObject:tg];
            [[EZTaskStore getInstance] deleteTaskgroup:tg];
            //[[EZTaskStore getInstance] removeObject:tg];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        [alamView show];
    }else{
        EZAvailableDay* avDay = [values objectAtIndex:indexPath.row];
        UIAlertView* alamView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:EZLocalizedString(@"Delete \"%@\"?",nil), avDay.name] message:[NSString stringWithFormat: EZLocalizedString(@"This will permanently delete all time snippets in \"%@\".", nil),avDay.name] delegate:self cancelButtonTitle:EZLocalizedString(@"Cancel",nil) otherButtonTitles:EZLocalizedString(@"Delete",nil), nil];
        NSMutableArray* groups = values;
        self.operation = ^(){
            EZDEBUG(@"Operation get called");
            [groups removeObject:avDay];
            [[EZTaskStore getInstance] removeObject:avDay];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        [alamView show];
    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"commitEditingStyle get called, row:%i", indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self raiseDeletionAlert:indexPath];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
    if(path.row < values.count){
        id tg = [values objectAtIndex:path.row];
        if([trimmed isEqualToString:@""]){
            //If the modified place is only space, then nothing will be changed
            if(isServeTaskList){
                textField.text = ((EZTaskGroup*)tg).name;
            }else{
                textField.text = ((EZAvailableDay*)tg).name;
            }
            return;
        }
        if(isServeTaskList){
            ((EZTaskGroup*)tg).name = trimmed;
        }else{
            ((EZAvailableDay*)tg).name = trimmed;
        }
        [[EZTaskStore getInstance] storeObject:tg];
    }else{
        if([trimmed isEqualToString:@""]){
            textField.text = @"";
            return;
        }
        id createdObj = nil;
        if(isServeTaskList){
            EZTaskGroup* tg = [[EZTaskGroup alloc] init];
            tg.name = trimmed;
            tg.displayOrder =  ((EZTaskGroup*)values.lastObject).displayOrder + 1;
            createdObj = tg;
        }else{
            EZAvailableDay* avDay = [[EZAvailableDay alloc] initWithName:trimmed weeks:NONEDAY];
            avDay.displayOrder = ((EZAvailableDay*)values.lastObject).displayOrder + 1;
            createdObj = avDay;
        }
        [[EZTaskStore getInstance] storeObject:createdObj];
        [values addObject:createdObj];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:values.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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
    EZDEBUG(@"didSelect get calld, indexPath.row:%i, taskGroups.count:%i",indexPath.row,values.count);
    if(indexPath.row < values.count){
        if(isServeTaskList){
            EZTaskGroup* tgrp = [values objectAtIndex:indexPath.row];
            EZTaskGroupDetailCtrl* tgc = [[EZTaskGroupDetailCtrl alloc] initWithStyle:UITableViewStylePlain];
            tgc.taskGroup = tgrp;
            tgc.superUpdateBlock = ^(){
                [tgrp refresh];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
            };
            [self.navigationController pushViewController:tgc animated:YES];
        }else{
            EZAvailableDay* avDay = [values objectAtIndex:indexPath.row];
            EZAvailableDayDetail* detailPage = [[EZAvailableDayDetail alloc] initWithStyle:UITableViewStyleGrouped];
            EZDEBUG(@"After initialized");
            detailPage.avDay = avDay;
            detailPage.updateBlock = ^(){
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            [self.navigationController pushViewController:detailPage animated:YES];
        }
    }
}

@end
