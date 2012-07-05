//
//  EZEnvFlagPicker.m
//  SqueezitProto
//
//  Created by Apple on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZEnvFlagPicker.h"
#import "EZTaskStore.h"
#import "EZEnvFlag.h"
#import "EZEnvFlagPickerCell.h"
#import "EZEditLabelCellHolder.h"
#import "EZGlobalLocalize.h"
#import "EZAvTimeForEnvTrait.h"

@interface EZEnvFlagPicker ()

- (BOOL) isSelected:(int)path;
- (void) setSelected:(int)path value:(int)value;
- (void) cancelAllSelectedExcept:(NSIndexPath*)path;
- (void) cancelNoneCell;
- (void) doneClicked;
- (void) cancelClicked;
- (NSUInteger) calculateEnvValue;

@end

@implementation EZEnvFlagPicker
@synthesize settedFlags, availableFlags, doneBlock, flagSelectionStatus;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        flagSelectionStatus = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    EZDEBUG(@"viewDidLoad");
    self.availableFlags = [EZTaskStore getInstance].envFlags;
    
    //TODO, should setup the selection status here. 
    for(int i = 0; i < self.availableFlags.count; ++i){
        EZEnvFlag* flag = [availableFlags objectAtIndex:i];
        int value = 0;
        if(isContained(flag.flag, settedFlags)){
            value = 1;
        }
        [flagSelectionStatus setValue:[[NSNumber alloc] initWithInt:value] forKey:[NSString stringWithFormat:@"%i", i]];
    }
    if(settedFlags == EZ_ENV_NO_REQ){
        [flagSelectionStatus setValue:[[NSNumber alloc] initWithInt:0] forKey:[NSString stringWithFormat:@"%i", availableFlags.count+1]];

    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked)];
    
}

- (NSUInteger) calculateEnvValue
{
    NSArray* allKeys = flagSelectionStatus.allKeys;
    NSUInteger base = 1;
    for(NSString* key in allKeys){
        if([self isSelected:key.intValue]){
            if(key.intValue < availableFlags.count){
                EZEnvFlag* flag = [availableFlags objectAtIndex:key.intValue];
                EZDEBUG(@"Selected:%@",flag.name);
                base = base * flag.flag;
            }
        }
    }
    return base;
}

- (void) doneClicked
{
    settedFlags = [self calculateEnvValue];
    if(doneBlock){
        doneBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return availableFlags.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlagCell";
    EZEnvFlagPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [EZEditLabelCellHolder createFlagCell];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.row < availableFlags.count){
        EZEnvFlag* fg = [availableFlags objectAtIndex:indexPath.row];
        if([self isSelected:indexPath.row]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.name.text = EZLocalizedString(fg.name, nil);
        cell.infoClickOperation = ^(){
            EZDEBUG(@"Info Click, flag name:%@",fg.name);
            EZAvTimeForEnvTrait* avCtrl = [[EZAvTimeForEnvTrait alloc] initWithStyle:UITableViewStylePlain];
            avCtrl.envFlag = fg.flag;
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:avCtrl];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            avCtrl.backBlock = ^(){
                [self dismissModalViewControllerAnimated:YES];  
            };
            
            [self presentModalViewController:nav animated:YES];
            
        };
    }else{
        cell.name.text = EZLocalizedString(@"None Env", nil);
        cell.infoClickOperation = ^(){
            EZDEBUG(@"Info clicke, flag is NONE");
        };
        if([self isSelected:indexPath.row]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZEnvFlagPickerCell* cell = (EZEnvFlagPickerCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if([self isSelected:indexPath.row]){
        [self setSelected:indexPath.row value:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        [self setSelected:indexPath.row value:1];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if(indexPath.row >= availableFlags.count){
            [self cancelAllSelectedExcept:indexPath];
        }else{
            [self cancelNoneCell];
        }
    
    }
    
}

- (void) cancelAllSelectedExcept:(NSIndexPath*)path
{
    NSArray* keys = flagSelectionStatus.allKeys;
    for(NSString* keyStr in keys){
        int row = keyStr.intValue;
        if(row != path.row && [self isSelected:row]){
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self setSelected:row value:0];
        }
        
    }
    
}


//For any row selected other than none row, should cancel the None row.
- (void) cancelNoneCell
{
    int noneRow = availableFlags.count;
    if([self isSelected:noneRow]){
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:noneRow inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self setSelected:noneRow value:0];
    }
}

- (BOOL) isSelected:(int)path
{
    NSString* key = [NSString stringWithFormat:@"%i",path];
    return ((NSNumber*)[flagSelectionStatus objectForKey:key]).intValue == 1;
};

- (void) setSelected:(int)path value:(int)value
{
    [flagSelectionStatus setValue:[[NSNumber alloc] initWithInt:value] forKey:[NSString stringWithFormat:@"%i",path]];
}

@end
