//
//  EZTaskDetailCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTaskDetailCtrl.h"
#import "EZTask.h"
#import "EZTaskStore.h"
#import "EZEditLabelCellHolder.h"
#import "EZEditLabelCell.h"
#import "EZGlobalLocalize.h"
#import "EZPureEditCell.h"
#import "EZQuotas.h"

@interface EZTaskDetailCtrl ()

@end

@implementation EZTaskDetailCtrl
@synthesize task, deleteBlock, superDeletBlock;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    EZDEBUG(@"textFieldShouldBeginEditing");
    return true;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField


//Really necessary to override this?
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    EZDEBUG(@"textFieldShouldEndEditing");
    return true;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField;     
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   

//- (BOOL)textFieldShouldClear:(UITextField *)textField;  

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (NSString*) envTraitsToString:(NSInteger)envTraits
{
    return [NSString stringWithFormat:@"%i", envTraits];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    EZDEBUG(@"Get cell for section:%i", section);
    switch (section) {
        case 0:{
            NSString* cellIdentifier = @"EditCell";
            EZPureEditCell* pureCell = (EZPureEditCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(pureCell == nil){
                pureCell = [EZEditLabelCellHolder createPureEditCellWithDelegate:self];
            }
            pureCell.editField.placeholder = @"Task Name ...";
            pureCell.editField.text = task.name;
            pureCell.editField.textAlignment = UITextAlignmentCenter;
            return pureCell;
            break;
        }
        case 1:
        case 2:
        case 3:
        {
            NSString* cellIdentifier = @"EditLabelCell";
            EZEditLabelCell* eLabelCell = (EZEditLabelCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(eLabelCell == nil){
                eLabelCell = [EZEditLabelCellHolder createCellWithDelegate:self];
            }
            
            if(section == 1){
                eLabelCell.label.text = EZLocalizedString(@"Time", nil);
                NSString* timeStr = nil;
                if(task.duration == task.maxDuration){
                    timeStr = [NSString stringWithFormat:EZLocalizedString(@"%i minutes",nil), task.duration];
                }else{
                    timeStr = [NSString stringWithFormat:EZLocalizedString(@"%i to %i minutes", nil),task.duration, task.maxDuration];
                }
                //Make it read only, click into another screen to modify it
                
                eLabelCell.textField.text = timeStr;
            }else if(section == 2){
                eLabelCell.label.text = EZLocalizedString(@"Environment", nil);
                eLabelCell.textField.text = [EZTaskHelper envTraitsToString:task.envTraits];
            } else { // == 3
                if(task.quotas == nil){
                    eLabelCell.label.text = EZLocalizedString(@"Weekly Minimum", nil);
                    eLabelCell.textField.text = EZLocalizedString(@"None", nil);
                }
                else if(task.quotas.cycleType == WeekCycle){
                    eLabelCell.label.text = EZLocalizedString(@"Each Week's quotas",nil);
                    eLabelCell.textField.text = [NSString stringWithFormat:EZLocalizedString(@"%i hours %i minutes",nil),task.quotas.quotasPerCycle/60, task.quotas.quotasPerCycle%60];
                }else if(task.quotas.cycleType == MonthCycle){
                    eLabelCell.label.text = EZLocalizedString(@"Each Month's quotas",nil);
                    eLabelCell.textField.text = [NSString stringWithFormat:EZLocalizedString(@"%i hours %i minutes",nil),task.quotas.quotasPerCycle/60, task.quotas.quotasPerCycle%60];
                    
                }else if(task.quotas.cycleType == CustomizedCycle){
                    eLabelCell.label.text = EZLocalizedString(@"Each Cycle's quotas",nil);
                    eLabelCell.textField.text = [NSString stringWithFormat:EZLocalizedString(@"%i hours %i minutes per %i days",nil),task.quotas.quotasPerCycle/60, task.quotas.quotasPerCycle%60, task.quotas.cycleLength];
                }
            }
            eLabelCell.textField.userInteractionEnabled = false;
            eLabelCell.textField.textAlignment = UITextAlignmentRight;
            eLabelCell.label.textAlignment = UITextAlignmentLeft;
            eLabelCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return eLabelCell;
        }
            
        case 4:{
            NSString* cellIdentifier = @"DeleteCell";
            UITableViewCell* deleteCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(deleteCell == nil){
                deleteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            deleteCell.textLabel.textAlignment = UITextAlignmentCenter;
            deleteCell.backgroundColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.6 alpha:1 ];
            deleteCell.textLabel.text = EZLocalizedString(@"Delete", nil);
            deleteCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return deleteCell;
        }
            break;
        default:
            break;
    }
    
    
    EZDEBUG(@"Why come here, section:%i",section);
    return nil;
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

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return nil;
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.section == 4){
        UITableViewCell* deleteCell = [self.tableView cellForRowAtIndexPath:indexPath];
        deleteCell.backgroundColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.6 alpha:1];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    EZDEBUG(@"Button clicked:%i",buttonIndex);
    BOOL deleted = false;
    if(buttonIndex == 0){
        deleted = true;
    }
    EZDEBUG(@"Delete %@", deleted?@"YES":@"NO");
    self.deleteBlock(deleted);
    self.deleteBlock = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 4){
        UITableViewCell* deleteCell = [self.tableView cellForRowAtIndexPath:indexPath];
        deleteCell.backgroundColor = [UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:1];
        UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        self.deleteBlock = ^(BOOL deleted){
            if(deleted){
                //[[EZTaskStore getInstance] removeObject:self.task];
                self.superDeletBlock();
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                //Turn the color into not selected;
                UITableViewCell* deleteCell = [self.tableView cellForRowAtIndexPath:indexPath];
                deleteCell.backgroundColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.6 alpha:1];
            }
        };
        [action showInView:self.view.window];
    }
}

@end
