//
//  EZScheduledDetail.m
//  SqueezitProto
//
//  Created by Apple on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledDetail.h"
#import "EZTaskHelper.h"
#import "EZGlobalLocalize.h"
#import "EZScheduledTask.h"
#import "EZTask.h"
#import "EZTaskStore.h"
#import "EZEditLabelCellHolder.h"
#import "EZButtonCell.h"
#import "EZBeginEndTimeCell.h"

@interface EZScheduledDetail ()

@end

@implementation EZScheduledDetail
@synthesize deleteBlock, rescheduleBlock, schTask;

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
    self.navigationItem.title = Local(@"Scheduled Task");
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
    if([schTask.startTime isPassed:[NSDate date]]){
        return 4;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        return 66;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    switch (indexPath.section) {
        case 0:{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Title"];
            cell.textLabel.text = schTask.task.name;
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            }
            break;
        case 1:{
            
            EZBeginEndTimeCell* timeCell = (EZBeginEndTimeCell*) [self.tableView dequeueReusableCellWithIdentifier:@"BeginEndTime"];
            if(timeCell == nil){
                timeCell = [EZEditLabelCellHolder createBeginEndTimeCell];
            }
            
            timeCell.beginTime.text =  [schTask.startTime stringWithFormat:@"HH:mm"];
            timeCell.endTime.text = [[schTask.startTime adjustMinutes:schTask.duration] stringWithFormat:@"HH:mm"];
                                    
            cell = timeCell;
        }
                    break;
        case 2:{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Env"];
            cell.textLabel.text = Local(@"Environment");
            cell.detailTextLabel.text = envTraitsToString(schTask.task.envTraits);
        }
            break;
        case 3:
        case 4:{
            EZButtonCell* buttonCell = [tableView dequeueReusableCellWithIdentifier:@"Button"];
            if(buttonCell == nil){
                buttonCell = [EZEditLabelCellHolder createButtonCell];
            }
            
            if(indexPath.section == 4){
                [buttonCell.button setTitle:Local(@"Delete") forState:UIControlStateNormal];
            }else{
                [buttonCell.button setTitle:Local(@"Re-Schedule") forState:UIControlStateNormal];
            }
            
            
            buttonCell.clickedOps = ^(id sender){
                [self.navigationController popViewControllerAnimated:YES];
                if(indexPath.section==4){
                    if(deleteBlock){
                        deleteBlock();
                    }
                }else{
                    if(rescheduleBlock){
                        rescheduleBlock();
                    }
                }
            };
            cell = buttonCell;
        }
            break;
        default:
            break;
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

//Only have the last 2 rows could be selected. 
- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < 4){
        return nil;
    }
    return indexPath;
}

//What I am suppose to do here?
//Only delete and reschedule will be selected here. 
//pop the view then call the delete or the reschedule operations.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"Selected %@", indexPath);
    if(indexPath.section == 4){
        [self.navigationController popViewControllerAnimated:YES];
        if(deleteBlock){
            deleteBlock();
        }
    }else if(indexPath.section == 5){
        [self.navigationController popViewControllerAnimated:YES];
        if(rescheduleBlock){
            rescheduleBlock();
        }
    }
}

@end
