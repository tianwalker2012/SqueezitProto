//
//  EZEnvTagCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZEnvTagCtrl.h"
#import "EZTaskStore.h"
#import "Constants.h"
#import "EZTaskHelper.h"
#import "EZEnvFlag.h"
#import "EZPureEditCell.h"
#import "EZEditLabelCellHolder.h"
#import "EZGlobalLocalize.h"

@interface EZEnvTagCtrl ()
{
    NSMutableArray* flags;
}

- (NSIndexPath*) fieldToPath:(UITextField*)field;

- (void) addClicked;

@end

@implementation EZEnvTagCtrl

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
    EZDEBUG(@"didLoad get called:%@",[NSThread callStackSymbols]);
    flags = [NSMutableArray arrayWithArray:[EZTaskStore getInstance].envFlags];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClicked)];
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
    //The last cell will be the editable cell.
    //Actually every cell is editable.
    return flags.count+1;
}

- (NSIndexPath*) fieldToPath:(UITextField*)field
{
    CGRect rectInTable = [self.tableView convertRect:field.frame fromView:field.superview];
    NSArray* arr = [self.tableView indexPathsForRowsInRect:rectInTable];
    EZDEBUG(@"Rect In Table:%@, find:%i cells",NSStringFromCGRect(rectInTable), arr.count);
    return [arr objectAtIndex:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZPureEditCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PureEdit"];
    if(cell == nil){
        cell = [EZEditLabelCellHolder createPureEditCellWithDelegate:self];
    }
    cell.placeHolder = Local(@"Name ...");
    cell.isFieldEditable = true;
    if(indexPath.row < flags.count){
        cell.editField.text = ((EZEnvFlag*)[flags objectAtIndex:indexPath.row]).name;
    }else{
        cell.editField.text = @"";
    }
    return cell;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* modified = textField.text.trim;
    NSIndexPath* path = [self fieldToPath:textField];
    if(path.row < flags.count){
        EZEnvFlag* ef = [flags objectAtIndex:path.row];
        if([ef.name isEqualToString:modified]){
            //Not changed, do nothing
            return;
        }else{
            ef.name = modified;
            [[EZTaskStore getInstance] storeObject:ef];
        }
    }else{
        //It will be created and stored and add the envFlag
        if([@"" isEqualToString:modified]){
            EZDEBUG(@"Do nothing for empty string");
            return;
        }
        EZEnvFlag* addFlag = [[EZTaskStore getInstance]createNextFlagWithName:modified]; 
        [flags addObject:addFlag];
        //[self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:flags.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        textField.text = @"";
        [textField becomeFirstResponder];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text.trim isEqualToString:@""]){
        NSIndexPath* path = [self fieldToPath:textField];
        if(path.row < flags.count){//Recover to old value
            EZEnvFlag* ef = [flags objectAtIndex:path.row];
            textField.text = ef.name;
        }else{
            textField.text = @"";
        }
    }
    [textField resignFirstResponder];
    return true;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

//I assume the PureEditCell will recieve the selected event.
//So that it could call the becomeFirstResponder on the editField.
//Good luck and enjoy.
- (void) addClicked
{
    NSIndexPath* path = [NSIndexPath indexPathForRow:flags.count inSection:0];
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

@end
