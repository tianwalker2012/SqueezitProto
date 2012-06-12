//
//  EZTaskTimeSetter.m
//  SqueezitProto
//
//  Created by Apple on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTaskTimeSetter.h"
#import "EZSettingCell.h"
#import "EZEditLabelCellHolder.h"
#import "EZGlobalLocalize.h"
#import "EZTask.h"
#import "EZKeyBoardHolder.h"

@interface EZTaskTimeSetter ()

- (void) selectDefaultRow;
- (void) cancelKeyboard:(EZOperationBlock)completeBlock;
- (void) initKeyboard:(EZOperationBlock)completeBlock ;
- (void) cancelClicked;
- (void) doneClicked;
- (NSInteger) convertRow:(NSInteger)row component:(NSInteger)component origin:(NSInteger)origin;
- (void) updateCell:(EZSettingCell*)cell value:(NSInteger)value;
- (void) updatePicker:(UIPickerView*)picker value:(NSInteger)value;

@end

@implementation EZTaskTimeSetter
@synthesize task, pickerKeyboard, selected, superDone;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) cancelKeyboard:(EZOperationBlock)completeBlock
{
    if(pickerKeyboard){
        [UIView beginAnimations:@"Hide Keyboard" context:nil];
        [UIView animateWithDuration:0.3 animations:^(){
            [pickerKeyboard setFrame:CGRectMake(0, 480, pickerKeyboard.frame.size.width, pickerKeyboard.frame.size.height)];
        } completion:^(BOOL finished){
            EZDEBUG(@"cancelKeyBoard animation, completed:%@",finished?@"YES":@"NO");
            [pickerKeyboard removeFromSuperview];
            pickerKeyboard = nil;
            if(completeBlock){
                completeBlock();
            }
        }];
        [UIView commitAnimations];
    }
}

- (void) initKeyboard:(EZOperationBlock)completeBlock
{
    if(!pickerKeyboard){
        pickerKeyboard = [EZKeyBoardHolder createPickerKeyBoard];
        pickerKeyboard.selector = self;
        [pickerKeyboard setFrame:CGRectMake(0, 480, pickerKeyboard.frame.size.width, pickerKeyboard.frame.size.height)];
        [self.view.window addSubview:pickerKeyboard];
        [UIView beginAnimations:@"Raise Keyboard" context:nil];
        //How many animateWithDuration I could including inside the commitAnmation?
        //How many animatable action I could take in the animation block?
        [UIView animateWithDuration:0.3 animations: ^(void){
            [pickerKeyboard setFrame:CGRectMake(0, 228, pickerKeyboard.frame.size.width, pickerKeyboard.frame.size.height)];
        } completion:^(BOOL finished){
            if(completeBlock){
                completeBlock();
            }
        }];
        [UIView commitAnimations];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        EZDEBUG(@"End of animation call");
    }
}

- (void) cancelClicked
{
    EZDEBUG(@"Cancel get called");
    [self cancelKeyboard:^(){
        EZDEBUG(@"before pop view");
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void) doneClicked
{
    EZDEBUG(@"Done get called");
    if(superDone){
        superDone();
    }
    [self cancelKeyboard:^(){
        EZDEBUG(@"before pop view");
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//The purpose of this is to make sure the animation could be seen by user
- (void) selectDefaultRow
{
    EZDEBUG(@"selectDefaultRow get called");
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    self.selected = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:selected];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    
    [self performSelector:@selector(initKeyboard:) withObject:^(){
        [self selectDefaultRow];
    } afterDelay:0.3];
    self.navigationItem.title = EZLocalizedString(@"Duration",nil);
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (NSInteger) convertRow:(NSInteger)row component:(NSInteger)component origin:(NSInteger)origin
{
    NSInteger res = 0;
    if(component == 0){
        NSInteger minutes = [pickerKeyboard.picker selectedRowInComponent:1];
        if(minutes < 0){
            minutes = origin%60;
        }
        res = row*60 + minutes;    
    }else{
        NSInteger hours = [pickerKeyboard.picker selectedRowInComponent:0];
        if(hours < 0){
            hours = origin/60;
        }
        res = hours*60 + row;
    }
    return res;
}

//Value changed get called.
//Refactor when the code smell bad
- (void) selectedRow:(NSInteger)row component:(NSInteger)component
{
    EZSettingCell* cell =(EZSettingCell*)[self.tableView cellForRowAtIndexPath:selected];
    NSInteger value = 0;
    if(selected.section == 0){
        task.duration = [self convertRow:row component:component origin:task.duration];
        value = task.duration;
    }  else {
        EZDEBUG(@"Before convert max:%i",task.maxDuration);
        task.maxDuration = [self convertRow:row component:component origin:task.maxDuration];
        EZDEBUG(@"After converted max:%i", task.maxDuration);
        value = task.maxDuration;
    }
    [self updateCell:cell value:value];
}

- (void) updateCell:(EZSettingCell*)cell value:(NSInteger)value
{
    if((value/60) == 0){
        cell.value.text = [NSString stringWithFormat:EZLocalizedString(@"%i minutes",nil),value];
    }else {
        cell.value.text = [NSString stringWithFormat:EZLocalizedString(@"%i hours %i minutes",nil),value/60, value%60];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingCell";
    EZSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [EZEditLabelCellHolder createSettingCell];
    }
    if(indexPath.section == 0){
        cell.name.text = EZLocalizedString(@"Minimum", nil);
        [self updateCell:cell value:task.duration];
        
    }else{
        cell.name.text = EZLocalizedString(@"Maximum", nil);
        [self updateCell:cell value:task.maxDuration];

    }
    return cell;
}


- (void) updatePicker:(UIPickerView*)picker value:(NSInteger)value
{
    [picker selectRow:value/60 inComponent:0 animated:YES];
    [picker selectRow:value%60 inComponent:1 animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"Select:%@",indexPath);
    
    //[self initKeyboard];
    self.selected = indexPath;
    if(indexPath.section == 0){//Selected the duration
        [self updatePicker:self.pickerKeyboard.picker value:task.duration];
    }else{ // selected the maxDuration
        [self updatePicker:self.pickerKeyboard.picker value:task.maxDuration];
    }
}

@end
