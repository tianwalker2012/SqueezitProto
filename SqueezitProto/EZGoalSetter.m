//
//  EZGoalSetter.m
//  SqueezitProto
//
//  Created by Apple on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZGoalSetter.h"
#import "EZQuotas.h"
#import "EZGlobalLocalize.h"
#import "EZGoalTimeSetter.h"

@interface EZGoalSetter (){
    BOOL isCustomizedType;
}

- (void) cancelClicked;

- (void) doneClicked;

@end

@implementation EZGoalSetter
@synthesize quotas, doneBlock;

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
    isCustomizedType = false;
    if(quotas == nil){//If quotas not setup, then setup.
        //quotas = [[EZQuotas alloc] init:[NSDate date] quotas:0 type:WeekCycle cycleStartDate:[NSDate date] cycleLength:7];
    }
    if(quotas.cycleType == CustomizedCycle){
        isCustomizedType = true;
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked)];
    
    self.navigationItem.title = Local(@"Goal Setting");

}

- (void) doneClicked
{
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
    EZDEBUG(@"quotas.CycleType:%i",quotas.cycleType);
    if(quotas.cycleType == QuotasNone){
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){//Because I will expose 3 cycle time
        return 4;
    }
    
    if(isCustomizedType){
        return 3;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = nil;
    
    if(indexPath.section == 0){
        NSString* cellID = @"TypeCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if(indexPath.row == 0){//Weekly
            cell.textLabel.text = EZLocalizedString(@"Weekly",nil);
            if(quotas.cycleType == WeekCycle){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }else if(indexPath.row == 1){//Monthly
            cell.textLabel.text = EZLocalizedString(@"Monthly",nil);
            if(quotas.cycleType == MonthCycle){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else {//Why this is necessary, because the cell will be recycled. no assumption about default status. set it explicitly.
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }else if(indexPath.row == 2){//Customize
            cell.textLabel.text = EZLocalizedString(@"Customized",nil);
            if(quotas.cycleType == CustomizedCycle){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else {//Why this is necessary, because the cell will be recycled. no assumption about default status. set it explicitly.
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else if(indexPath.row == 3){
            cell.textLabel.text = Local(@"No Goal");
            if(quotas.cycleType == QuotasNone){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            
    }else{
        NSString* cellID = @"ValueCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        
        if(indexPath.row == 0){//Goal
            cell.textLabel.text = Local(@"Goal");
            cell.detailTextLabel.text = [NSString stringWithFormat:EZLocalizedString(@"%i hours", nil),quotas.quotasPerCycle/60];
        }else if(indexPath.row == 1){//cycle length
            cell.textLabel.text = EZLocalizedString(@"Cycle length", nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:EZLocalizedString(@"%i days", nil),quotas.cycleLength];
           
        }else{//Cycle start date
            cell.textLabel.text = EZLocalizedString(@"Cycle start", nil);
            if(quotas.cycleStartDay != nil){
                cell.detailTextLabel.text = [quotas.cycleStartDay stringWithFormat:@"yyyy-MM-dd"];
            }else{
                cell.detailTextLabel.text = EZLocalizedString(@"None",nil);
            }
           
        }
        
    }
    
    
    return cell;
}



#pragma mark - Table view delegate

//What's the purpose of this method?
- (void) turnCell:(BOOL)on
{
    
    NSIndexPath* cycleLength = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath* cycleDate = [NSIndexPath indexPathForRow:2 inSection:1];
    [self.tableView beginUpdates];
    if(on){
        //[self.tableView insertSections:[NSSet setWithObjects:cycleLength,cycleDate, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:cycleLength, cycleDate, nil] withRowAnimation:UITableViewRowAnimationBottom];
        
    }else{
       [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:cycleLength, cycleDate, nil] withRowAnimation:UITableViewRowAnimationBottom];
    }
    [self.tableView endUpdates];
    
}

//Don't touch things work ok.
//Only add to it.
//Why not delete row. Time is urgent. Let's get it done before dinner
- (void) enableGoalSetting:(BOOL)enabled
{
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:1];
    [self.tableView beginUpdates];
    if(enabled){
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewScrollPositionBottom];
    }else{
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewScrollPositionBottom];
    }
    [self.tableView endUpdates];
}

- (void) exclusiveCheckMark:(int)row
{
    for(int i = 0; i < 4; ++i){
        if(i == row){
            NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        [self exclusiveCheckMark:indexPath.row];

        //Only turn on the cell when it is customizable
        //This will need to refractor
        if(indexPath.row == 3 && quotas.cycleType != QuotasNone){
            EZDEBUG(@"set to none get called, cycleType:%i", quotas.cycleType);
            quotas.cycleType = QuotasNone;
            [self enableGoalSetting:NO];
        } else {
            //Enable the section
            BOOL extend = NO;
            if(quotas.cycleType == QuotasNone){
                //quotas.cycleType
                //[self enableGoalSetting:YES];
                extend = YES;
            }
            if(indexPath.row == 2){
                quotas.cycleType = CustomizedCycle;
                if(extend){
                    [self enableGoalSetting:YES];
                }
                if(!isCustomizedType){
                    isCustomizedType = true;
                    [self turnCell:YES];
                }
            }else{
                if(indexPath.row == 0){
                    quotas.cycleType = WeekCycle;
                }else{
                    quotas.cycleType = MonthCycle;
                }
                if(extend){
                    [self enableGoalSetting:YES];
                }
                if(isCustomizedType){
                    isCustomizedType = false;
                    [self turnCell:NO];
                }
            }
            //EZDEBUG(@"Selected Row:%i, quotas.cycleType")
        }
    } else {
        EZGoalTimeSetter* timeSetter = [[EZGoalTimeSetter alloc] initWithStyle:UITableViewStyleGrouped];
        timeSetter.timeSetterType = indexPath.row+1;
        timeSetter.quotas = quotas.cloneVO;
        timeSetter.doneBlock = ^(){
            self.quotas = timeSetter.quotas;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
            EZDEBUG(@"Done with setting");
        };
        [self.navigationController pushViewController:timeSetter animated:YES];
    }

}

@end
