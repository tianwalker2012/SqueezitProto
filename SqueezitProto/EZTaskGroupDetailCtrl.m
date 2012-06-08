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

@interface EZTaskGroupDetailCtrl ()

@end

@implementation EZTaskGroupDetailCtrl
@synthesize taskGroup, barType;

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
    //self.navigationItem.leftBarButtonItem
    //self.barType = UIBarButtonSystemItemDone;
    //[self performSelector:@selector(changeLeftBarButton) withObject:nil afterDelay:1];
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
    return [taskGroup.tasks count];
}

- (void) dummyHandler:(id)sender
{
    
}

- (void) changeLeftBarButton
{
    //self.navigationItem.b
    EZDEBUG(@"Begin to execute the ChangeLeftBarButton: type:%i",self.barType);
    if(self.barType > UIBarButtonSystemItemPageCurl){
        EZDEBUG(@"Quit for reach the maximum");
        return;
    }
    
    @try {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:self.barType target:nil action:@selector(dummyHandler:)];
        
    }
    @catch (NSException *exception) {
        EZDEBUG(@"Encounter exception for type:%i",self.barType);
    }
    @finally {
        self.barType = 1+self.barType;
        [self performSelector:@selector(changeLeftBarButton) withObject:nil afterDelay:1];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    EZTask* task = [taskGroup.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = task.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Mini:%i minutes, Max:%i minutes, Type:%i",task.duration, task.maxDuration, task.envTraits];
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
    EZTask* task = [self.taskGroup.tasks objectAtIndex:indexPath.row];
    EZTaskDetailCtrl* td = [[EZTaskDetailCtrl alloc] initWithStyle:UITableViewStylePlain];
    td.task = task;
    [self.navigationController pushViewController:td animated:YES];
    
}

@end
