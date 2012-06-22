//
//  EZTableSelector.m
//  SqueezitProto
//
//  Created by Apple on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTableSelector.h"

@interface EZTableSelector ()

- (void) doneClicked;
- (void) cancelClicked;

@end

@implementation EZTableSelector
@synthesize selectorDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void) doneClicked
{
    [selectorDelegate doneClicked:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelClicked
{
    [selectorDelegate cancelClicked:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked)];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
    return [selectorDelegate getSection:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [selectorDelegate getRow:self];
}

//Keep it simple and stupid as possible.
//Will consider the complicated optimization later.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* res = [selectorDelegate tableSelector:self getCell:indexPath];
    res.selectionStyle = UITableViewCellSelectionStyleNone;
    return res;
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
    //The delegate will take the responsibility of choose the selected cell
    [selectorDelegate tableSelector:self selected:indexPath];
}

//Return the index of the current selected cell
- (NSIndexPath*) getSelectedRow
{
    return [self.tableView indexPathForSelectedRow];
}

- (UITableViewCell*) getCellByIndexPath:(NSIndexPath*)indexPath
{
    return [self.tableView cellForRowAtIndexPath:indexPath];
}


//Will deselect the rest of the cell.
//The issue with this is that for all visible cell,
//I will turn the check off, only keep this one.
//Why visible?
//Because the nonvisible will go throught the get cell process. 
//This will make sure the checkMark show correctly.
- (void) selectOnly:(NSIndexPath*)indexPath
{
    UITableViewCell* selected = [self.tableView cellForRowAtIndexPath:indexPath];
    selected.accessoryType = UITableViewCellAccessoryCheckmark;
    NSArray* visibleCells = self.tableView.visibleCells;
    for(UITableViewCell* cell in visibleCells){
        if(cell != selected){
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

//Just add a check mark to the correct cell.
- (void) selectAdd:(NSIndexPath*)indexPath
{
    UITableViewCell* selected = [self.tableView cellForRowAtIndexPath:indexPath];
    selected.accessoryType = UITableViewCellAccessoryCheckmark;
}

//Set the checkMark to none
- (void) selectNot:(NSIndexPath*)indexPath
{
    UITableViewCell* selected = [self.tableView cellForRowAtIndexPath:indexPath];
    selected.accessoryType = UITableViewCellAccessoryNone;
}


@end
