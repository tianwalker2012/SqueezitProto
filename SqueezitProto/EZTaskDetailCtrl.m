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

@interface EZTaskDetailCtrl ()

@end

@implementation EZTaskDetailCtrl
@synthesize task;

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (NSString*) envTraitsToString:(NSInteger)envTraits
{
    return [NSString stringWithFormat:@"%i", envTraits];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditLabelCell";
    EZEditLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [EZEditLabelCellHolder createCellWithDelegate:self];
    }
    switch (indexPath.row) {
        case 0:
            cell.textField.text = task.name;
            cell.label.text = EZLocalizedString(@"Name:",nil);
            break;
        case 1:
            cell.textField.text = [NSString stringWithFormat:EZLocalizedString(@"%i minutes", nil), task.duration];
            cell.label.text = EZLocalizedString(@"Shortest Time:", nil);
            break;
        case 2:
            cell.textField.text = [NSString stringWithFormat:EZLocalizedString(@"%i minutes", nil), task.maxDuration];
            cell.label.text = EZLocalizedString(@"Longest Time:",nil); 
            break;
        case 3:
            cell.textField.text = [self envTraitsToString:task.envTraits];
            cell.label.text = EZLocalizedString(@"Environment Traits", nil);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
