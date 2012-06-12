//
//  EZAvTimeForEnvTrait.m
//  SqueezitProto
//
//  Created by Apple on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvTimeForEnvTrait.h"
#import "EZTaskStore.h"
#import "EZTaskHelper.h"
#import "EZAvailableTime.h"
#import "MAvailableTime.h"
#import "EZAvailableTimeCell.h"
#import "EZEditLabelCellHolder.h"
#import "EZGlobalLocalize.h"

@interface EZAvTimeForEnvTrait ()

- (void) backClicked;

@end

@implementation EZAvTimeForEnvTrait
@synthesize envFlag, avTimes, backBlock;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) backClicked
{
    if(backBlock){
        backBlock();
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:EZLocalizedString(@"Back", nil) style:UIBarButtonItemStyleDone target:self action:@selector(backClicked)];
    NSArray* availableTime = [[EZTaskStore getInstance] fetchAllWithVO:[EZAvailableTime class] po:[MAvailableTime class] sortField:@"startTime"];
    self.avTimes = [availableTime filter:^BOOL(id obj) {
        EZAvailableTime* av = (EZAvailableTime*)obj;
        return isContained(envFlag, av.envTraits);
    }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return avTimes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TimeCell";
    EZAvailableTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [EZEditLabelCellHolder createTimeCell];
    }
    EZAvailableTime* avtime = [avTimes objectAtIndex:indexPath.row];
    cell.name.text = avtime.name;
    cell.time.text = [NSString stringWithFormat:@"%@ to %@",[avtime.start stringWithFormat:@"HH:mm"], [[avtime.start adjustMinutes:avtime.duration]stringWithFormat:@"HH:mm"]];
    cell.envTraits.text = [[EZTaskStore getInstance] StringForFlags:avtime.envTraits];
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
