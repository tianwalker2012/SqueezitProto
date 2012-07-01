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
#import "EZTaskTimeSetter.h"
#import "EZEnvFlagPicker.h"
#import "EZGoalSetter.h"
#import "EZButtonCell.h"


@interface EZTaskDetailCtrl ()

@property (assign, nonatomic) BOOL cancelled;

- (void) cancelClicked;

- (void) doneClicked;

@end

@implementation EZTaskDetailCtrl
@synthesize task, deleteBlock, superUpdateBlock, cancelled, superDeleteBlock;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.cancelled = false;
    }
    return self;
}

- (void) cancelClicked
{
    EZDEBUG(@"Cancel get clicked");
    self.cancelled = true;
    [self.navigationController popViewControllerAnimated:YES];
    
}

//I have one assumption.
//State it clearly, All the change will already be update to the object.
//Only when done get clicked, the changes happened so far will be persisted
- (void) doneClicked
{
    EZDEBUG(@"Done get clicked, name:%@", task.name);
    [[EZTaskStore getInstance] storeObject:task];
    self.superUpdateBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:EZLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];

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


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* trimmed = textField.text.trim;
    if([trimmed isEqualToString:@""]){
        textField.text = task.name;
        return;
    }
    task.name = trimmed;
}
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
    //EZDEBUG(@"Get cell for section:%i", section);
    switch (section) {
        case 0:{
            NSString* cellIdentifier = @"PureEdit";
            EZPureEditCell* pureCell = (EZPureEditCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(pureCell == nil){
                pureCell = [EZEditLabelCellHolder createPureEditCellWithDelegate:self];
            }
            pureCell.placeHolder = Local(@"Task Name ...");
            pureCell.editField.text = task.name;
            //pureCell.editField.textAlignment = UITextAlignmentCenter;
            pureCell.isFieldEditable = true;
            return pureCell;
            break;
        }
        case 1:
        case 2:
        case 3:
        {
            NSString* cellIdentifier = @"Setting";
            UITableViewCell* eLabelCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(eLabelCell == nil){
                eLabelCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            }
            
            if(section == 1){
                eLabelCell.textLabel.text = Local(@"Time");
                NSString* timeStr = nil;
                if(task.duration == task.maxDuration){
                    timeStr = [NSString stringWithFormat:Local(@"%i minutes"), task.duration];
                }else{
                    timeStr = [NSString stringWithFormat:Local(@"%i to %i minutes"),task.duration, task.maxDuration];
                }
                //Make it read only, click into another screen to modify it
                
                eLabelCell.detailTextLabel.text = timeStr;
            }else if(section == 2){
                eLabelCell.textLabel.text = Local(@"Environment");
                eLabelCell.detailTextLabel.text = [[EZTaskStore getInstance] StringForFlags:task.envTraits];
            } else { // == 3
                if(task.quotas == nil){
                    eLabelCell.textLabel.text = Local(@"Weekly Minimum");
                    eLabelCell.detailTextLabel.text = Local(@"None");
                }
                else if(task.quotas.cycleType == WeekCycle){
                    eLabelCell.textLabel.text = Local(@"Each Week's quotas");
                    eLabelCell.detailTextLabel.text = [NSString stringWithFormat:Local(@"%i hours %i minutes"),task.quotas.quotasPerCycle/60, task.quotas.quotasPerCycle%60];
                }else if(task.quotas.cycleType == MonthCycle){
                    eLabelCell.textLabel.text = Local(@"Each Month's quotas");
                    eLabelCell.detailTextLabel.text = [NSString stringWithFormat:Local(@"%i hours %i minutes"),task.quotas.quotasPerCycle/60, task.quotas.quotasPerCycle%60];
                    
                }else if(task.quotas.cycleType == CustomizedCycle){
                    eLabelCell.textLabel.text = Local(@"Each Cycle's quotas");
                    eLabelCell.detailTextLabel.text = [NSString stringWithFormat:Local(@"%i hours %i minutes per %i days"),task.quotas.quotasPerCycle/60, task.quotas.quotasPerCycle%60, task.quotas.cycleLength];
                }
            }
            eLabelCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return eLabelCell;
        }
            
        case 4:{
            NSString* cellIdentifier = @"Button";
            EZButtonCell* deleteCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(deleteCell == nil){
                deleteCell = [EZEditLabelCellHolder createButtonCell];
            }
            deleteCell.button.titleLabel.text = Local(@"Delete");
            deleteCell.clickedOps = ^(id cell){
                UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Local(@"Cancel") destructiveButtonTitle:Local(@"Delete") otherButtonTitles:nil];
                self.deleteBlock = ^(BOOL deleted){
                    if(deleted){
                        //[[EZTaskStore getInstance] removeObject:self.task];
                        self.superDeleteBlock();
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        //Turn the color into not selected;
                        UITableViewCell* deleteCell = [self.tableView cellForRowAtIndexPath:indexPath];
                        deleteCell.backgroundColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.6 alpha:1];
                    }
                };
                [action showInView:self.view.window];  
            };
            
            
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
 
    }else if(indexPath.section == 1){
        EZTaskTimeSetter* timeSetter = [[EZTaskTimeSetter alloc] initWithStyle:UITableViewStyleGrouped];
        timeSetter.task = task.cloneVO;
        timeSetter.superDone = ^(){
            //If max smaller than min, then set it equal with minimum
            if(timeSetter.task.duration > timeSetter.task.maxDuration){
                timeSetter.task.maxDuration = timeSetter.task.duration;
            }
            self.task = timeSetter.task;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        };
        [self.navigationController pushViewController:timeSetter animated:YES];
    }else if(indexPath.section == 2){
        EZEnvFlagPicker* picker = [[EZEnvFlagPicker alloc] initWithStyle:UITableViewStyleGrouped];
        picker.settedFlags = task.envTraits;
        picker.doneBlock = ^(){
            EZDEBUG(@"Done: final value:%i", picker.settedFlags);
            task.envTraits = picker.settedFlags;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        };
        //EZDEBUG(@"Before PushViewController");
        [self.navigationController pushViewController:picker animated:YES];
        //EZDEBUG(@"After PushViewController");
    }else if(indexPath.section == 3){
        EZGoalSetter* goalSetter = [[EZGoalSetter alloc] initWithStyle:UITableViewStyleGrouped];
        //Add the clone later
        goalSetter.quotas = task.quotas.cloneVO;
        goalSetter.doneBlock = ^(){
            EZDEBUG(@"Done block get called"); 
            task.quotas = goalSetter.quotas;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        };
        [self.navigationController pushViewController:goalSetter animated:YES];
    }
}


- (NSInteger) getSection:(EZTableSelector*)selector
{
    
}
- (NSInteger) getRow:(EZTableSelector*)selector
{
    
}

- (UITableViewCell*) tableSelector:(EZTableSelector*)selector getCell:(NSIndexPath*)indexPath
{
    
}

- (void) tableSelector:(EZTableSelector*)selector selected:(NSIndexPath*)indexPath
{
    
}

- (void) doneClicked:(EZTableSelector*)selector
{
    
}

- (void) cancelClicked:(EZTableSelector*)selector
{
    
}


@end
