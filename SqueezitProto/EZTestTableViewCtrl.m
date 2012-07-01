//
//  EZTestTableViewCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTestTableViewCtrl.h"
#import "Constants.h"

@interface EZTestTableViewCtrl ()
{
    NSArray* names;
}

@end

@implementation EZTestTableViewCtrl
@synthesize isFamily, familyName, selfNavCtrl;

- (id)initWithStyle:(UITableViewStyle)style isFamily:(BOOL)family
{
    isFamily = family;
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(isFamily){
        names = [UIFont familyNames];
    }else{
        names = [UIFont fontNamesForFamilyName:familyName];
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
    return names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //UIFont* font = [[UIFont alloc] init];
    //cell.textLabel.font = 
    //cell.textLabel.text = [NSString stringWithFormat:@"Row:%i", indexPath.row];
    if(isFamily){
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [names objectAtIndex:indexPath.row]];
    }else{
        NSString* fontName = [NSString stringWithFormat:@"%@:曾因酒醉鞭名马", [names objectAtIndex:indexPath.row]];
        cell.textLabel.text = fontName;
        cell.detailTextLabel.text = familyName;
        cell.textLabel.font = [UIFont fontWithName:fontName size:17];
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
    EZDEBUG(@"selected:%i",indexPath.row);
    if(isFamily){
        EZDEBUG(@"About to show new view");
        EZTestTableViewCtrl* ctrl = [[EZTestTableViewCtrl alloc]initWithStyle:UITableViewStylePlain isFamily:false];
        ctrl.familyName = [names objectAtIndex:indexPath.row];
        [selfNavCtrl pushViewController:ctrl animated:YES];
    }
}

@end
