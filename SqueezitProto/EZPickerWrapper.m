//
//  EZPickerWrapper.m
//  SqueezitProto
//
//  Created by Apple on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZPickerWrapper.h"
#import "Constants.h"
#import "EZTaskHelper.h"

@interface EZPickerWrapper () {
    UIView* currentKeyBoard;
}

- (void) cancelClicked;

- (void) doneClicked;

- (void) animateSelect:(NSIndexPath*)path;

- (void) raiseKeyboard:(UIView*)keyboard animated:(BOOL)animated complete:(EZOperationBlock)complete;

- (void) dropKeyboard:(UIView*)keyboard animated:(BOOL)animated complete:(EZOperationBlock)complete;

@end

@implementation EZPickerWrapper
@synthesize wrapperDelegate, speedupWin;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) cancelClicked
{
    [wrapperDelegate cancelClicked:self];
    [self dropKeyboard:currentKeyBoard animated:YES complete:^(){
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void) doneClicked
{
    [wrapperDelegate doneClicked:self];
    [self dropKeyboard:currentKeyBoard animated:YES complete:^(){
        [self.navigationController popViewControllerAnimated:YES]; 
    }];
}

- (void)viewDidLoad
{
    EZDEBUG(@"viewDidLoad begin");
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked)];
    //Animation to select the first row, call the cell selected after the animation is completed. 
    EZDEBUG(@"viewDidLoad end");
}

- (void) viewWillAppear:(BOOL)animated
{
    EZDEBUG(@"in viewDidApprear");
    [self.tableView reloadData];
    EZDEBUG(@"after reloadData");
    NSIndexPath* selectedPath = [wrapperDelegate getDefaultSelected:self];
    if(selectedPath == nil){
        selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    //[self animateSelect:selectedPath];
    [self performSelector:@selector(animateSelect:) withObject:selectedPath afterDelay:0.05];
}


- (void) raiseKeyboard:(UIView*)keyboard animated:(BOOL)animated complete:(EZOperationBlock)complete
{
    UIWindow* win = self.view.window;
    EZDEBUG(@"raiseKeyBoard get called, win frame:%@, keyboard frame:%@",NSStringFromCGRect(win.frame), NSStringFromCGRect(keyboard.frame));
    [keyboard setFrame:CGRectMake(keyboard.frame.origin.x, win.bounds.size.height, keyboard.frame.size.width, keyboard.frame.size.height)];
    [win addSubview:keyboard];
    if(!animated){
        [keyboard setFrame:CGRectMake(keyboard.frame.origin.x, win.bounds.size.height - keyboard.frame.size.height, keyboard.frame.size.width, keyboard.frame.size.height)];
        if(complete){
            complete();
        }
        return;
    }
    
    [UIView beginAnimations:@"Raise Keyboard" context:nil];
    [UIView animateWithDuration:0.15 animations:^(){
        [keyboard setFrame:CGRectMake(keyboard.frame.origin.x, win.bounds.size.height - keyboard.frame.size.height, keyboard.frame.size.width, keyboard.frame.size.height)];
    } completion:^(BOOL finished){
        if(complete){
            complete();
        }
    }];
    [UIView commitAnimations];
    //[self.view.window 
}

//Drop down the keyboard the remove the keyboard from the super view
- (void) dropKeyboard:(UIView*)keyboard animated:(BOOL)animated complete:(EZOperationBlock)complete
{
    EZDEBUG(@"Drop keyboard get called");
    UIWindow* win = self.view.window;
    currentKeyBoard = nil;
    if(!animated){
        [keyboard removeFromSuperview];
        if(complete){
            complete();
        }
        return;
    }
    
    [UIView beginAnimations:@"Drop Keyboard" context:nil];
    [UIView animateWithDuration:0.3 animations:^(){
        [keyboard setFrame:CGRectMake(keyboard.frame.origin.x, win.bounds.size.height, keyboard.frame.size.width, keyboard.frame.size.height)];
    } completion:^(BOOL finished){
        [keyboard removeFromSuperview];
        if(complete){
            complete();
        }
    }];
    [UIView commitAnimations];
}

//Will only be called during the first time this controller get activiated
//Should I also call this for the row which require keyboard inputs?
//I guess i could. 
- (void) animateSelect:(NSIndexPath*)path
{
    EZDEBUG(@"animated select row begin");
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    EZDEBUG(@"animated select row end");
    
    //The purpose of calling this is to raise the keyboard if necessary
    //Setup the correct value for the keyboard
    [self tableView:self.tableView didSelectRowAtIndexPath:path];
    
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
    return [wrapperDelegate getSection:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [wrapperDelegate getRow:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [wrapperDelegate pickerWrapper:self getCell:indexPath];
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

//What need to be done in this method?
//Raise the keyboard in necessary
//Call cellSelected in wrapperDelegate.
//It is his responsibility of the set the picker to the right value
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"didSelectRowAtIndexPath get called");
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    //[wrapperDelegate cellSelected:cell indexPath:indexPath];
    UIView* keyboard = [wrapperDelegate pickerWrapper:self getKeyBoard:indexPath];
    if(keyboard == currentKeyBoard){
        EZDEBUG(@"Keyboard already raised for:%@",indexPath);
        [wrapperDelegate pickerWrapper:self cellSelected:cell indexPath:indexPath keyboard:currentKeyBoard];
        return;
    }
    UIView* previous = currentKeyBoard;
    currentKeyBoard = keyboard;
    assert(keyboard != nil);
    [self raiseKeyboard:keyboard animated:YES complete:^(){
        [wrapperDelegate pickerWrapper:self cellSelected:cell indexPath:indexPath keyboard:currentKeyBoard];
        if(previous){
            [self dropKeyboard:previous animated:NO complete:nil];
        }
    }];
    
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

@end
