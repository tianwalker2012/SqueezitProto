//
//  EZScheduledTaskController.m
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledTaskController.h"
#import "EZScheduledTaskDetailCtrl.h"
#import "EZScheduledTask.h"
#import "EZTaskScheduler.h"
#import "EZTask.h"
#import "EZTaskStore.h"
#import "EZTaskHelper.h"
#import "EZAlarmUtility.h"
#import "EZScheduledCell.h"
#import "EZEditLabelCellHolder.h"
#import "EZGlobalLocalize.h"
#import "EZScheduledDetail.h"

@interface EZScheduledTaskController ()

@end

@implementation EZScheduledTaskController
@synthesize currentDate, scheduledTasks;

- (BOOL)canBecomeFirstResponder
{
    //EZDEBUG(@"canBecomeFirstResponder get called,stack trace %@",[NSThread callStackSymbols]);
    return TRUE;
}

- (void)viewDidAppear:(BOOL)animated {
    //EZDEBUG(@"viewDidAppear get called");
    [self becomeFirstResponder];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Yes is 1, what about cancel, cancel is 0?
    
    EZDEBUG(@"The clicked button:%i",buttonIndex);
    if(buttonIndex == 1){
        [self rescheduleTasks];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //EZDEBUG(@"Get motion event:%i",motion);
    if(motion == UIEventSubtypeMotionShake){
        EZDEBUG(@"I encounter shake event");
        if(scheduledTasks.count > 0){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Reschedule?" message:@"Are you sure you want reschedule? current schedule will be deleted" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
            [alert show];
        }else{
        //message.text = @"Shaked";
            [self rescheduleTasks];
        }
    }
    
}


//What's logic will be included in this method?
//If the currentDate is today,
//We can just get the date right. 
//The rescheduleAll will handle all the logic right.
- (void) rescheduleTasks
{
  
    EZTaskScheduler* scheduler = [EZTaskScheduler getInstance];
    if([currentDate equalWith:[NSDate date] format:@"yyyyMMdd"]){
        currentDate = [currentDate combineTime:[NSDate date]];
    }
    
    scheduledTasks = [scheduler rescheduleAll:scheduledTasks date:currentDate];
    [EZAlarmUtility setupAlarmBulk:scheduledTasks];
    [[EZTaskStore getInstance] storeObjects:scheduledTasks];
    [self.tableView reloadData];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        currentDate = [NSDate date];
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
    }
    return self;
}




- (void) deleteRow:(NSIndexPath*)indexPath
{
    [self.tableView beginUpdates];

    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView endUpdates];
}

//Add rows to replace the old rows
- (void) replaceRow:(NSIndexPath*)indexPath
{
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    NSMutableArray* insertedPaths = [[NSMutableArray alloc] init];
    for(int i = 0; i < [repalceTasks count]; i++){
        NSUInteger iarr[2];
        iarr[0] = indexPath.section;
        iarr[1] = indexPath.row + i;
        NSIndexPath* path = [[NSIndexPath alloc] initWithIndexes:iarr length:2];
        [insertedPaths addObject:path];
    }
    //[insertedPaths addObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:insertedPaths withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    EZTaskStore* store = [EZTaskStore getInstance];
    scheduledTasks = [store getScheduledTaskByDate:currentDate];
    //if([scheduledTasks count] == 0){
    //    [self presentShakeMessage:@"Shake shake"];
    //}
    self.navigationItem.title = Local(@"Scheduled Task");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rescheduleTasks)];
    
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

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [scheduledTasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduleCell";
    EZScheduledCell *cell = (EZScheduledCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [EZEditLabelCellHolder createScheduledCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    EZScheduledTask* task = [scheduledTasks objectAtIndex:indexPath.row];
    
    cell.title.text = [NSString stringWithFormat:@"%@(%@)",task.task.name,(task.alarmNotification?@"setup alarm":@"no alarm")];
    
    NSDate* endTime = [NSDate dateWithTimeInterval:task.duration*60 sinceDate:task.startTime];
    NSDate* now = [NSDate date];
    if([now InBetween:task.startTime end:endTime] ){
        cell.title.textColor = [UIColor redColor];
    }else if([task.startTime isPassed:now]) { //Passed task
        cell.title.textColor = [UIColor lightGrayColor];
    } else {
        //cell.textLabel.textColor = FutureTaskColor;
        cell.title.textColor = [UIColor blackColor];
    }
    cell.timeSpanTitle.text = [NSString stringWithFormat:@"%@ - %@",[task.startTime stringWithFormat:@"HH:mm"],[endTime stringWithFormat:@"HH:mm"]];
    cell.clickBlock = ^(){
        ++task.alarmType;
        if(task.alarmType > EZ_MUTE){
            task.alarmType = EZ_SOUND;
        }
        //Found way later. weave thing together ASAP
        
        [cell performSelector:@selector(setButtonStatus:) withObject:[[NSNumber alloc] initWithInteger:task.alarmType] afterDelay:0.3];
        [EZAlarmUtility changeAlarmMode:task];
        
    };
    
    // Configure the cell..
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
        
    //EZScheduledTaskDetailCtrl* detailViewController = [[EZScheduledTaskDetailCtrl alloc] initWithNibName:@"EZScheduledTaskDetailCtrl" bundle:nil];
    
    EZScheduledDetail* scheduleDetail = [[EZScheduledDetail alloc] initWithStyle:UITableViewStyleGrouped];
    EZScheduledTask* task = [scheduledTasks objectAtIndex:indexPath.row];
    scheduleDetail.schTask = task; 
   
    scheduleDetail.deleteBlock = ^(){
        EZDEBUG(@"DeleteOp get called");
        [EZAlarmUtility cancelAlarm:task];
        NSMutableArray* mutArr = [NSMutableArray arrayWithArray:self.scheduledTasks];
        [mutArr removeObjectAtIndex:indexPath.row];
        self.scheduledTasks = mutArr;
        [[EZTaskStore getInstance] removeObject:task];
        [self performSelector:@selector(deleteRow:) withObject:indexPath afterDelay:0.3];
        //[self deleteRow:path];
    };
    
    scheduleDetail.rescheduleBlock = ^(){
        EZDEBUG(@"RescheduleOp get called");
        NSMutableArray* mutArr = [NSMutableArray arrayWithArray:self.scheduledTasks];
        NSArray* schTasks = [[EZTaskScheduler getInstance] rescheduleTask:task existTasks:scheduledTasks];
        if([schTasks count] > 0){
            [EZAlarmUtility cancelAlarm:task];
            [EZAlarmUtility setupAlarmBulk:schTasks];
            [[EZTaskStore getInstance] removeObject:task];
            [[EZTaskStore getInstance] storeObjects:schTasks];
            [mutArr removeObjectAtIndex:indexPath.row];
            [mutArr addObjectsFromArray:schTasks];
            [mutArr sortUsingComparator:^(id obj1, id obj2) {
                EZScheduledTask* task1 = obj1;
                EZScheduledTask* task2 = obj2;
                return [task1.startTime compare:task2.startTime];
                
            }];
            self.scheduledTasks = mutArr;
            //[self.tableView reloadData];
            repalceTasks = schTasks;
            [self performSelector:@selector(replaceRow:) withObject:indexPath afterDelay:0.3];
        }else{
            EZDEBUG(@"Could not find replacement for:%@",[task detail]);
        }
        
    };
    
    [self.navigationController pushViewController:scheduleDetail animated:YES];

}

@end
