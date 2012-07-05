//
//  EZScheduledTaskController.m
//  SqueezitProto
//
//  Created by Apple on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledTaskController.h"
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
#import "EZScheduledTaskCell.h"
#import "EZTimeCounterView.h"
#import "EZTimeCounter.h"
#import "MScheduledTask.h"
#import "EZScheduledV2Cell.h"

@interface EZNumberWrapper : NSObject 

@property (assign, nonatomic) NSInteger number;

@end

@implementation EZNumberWrapper
@synthesize number;
@end


@interface EZScheduledTaskController () {
    EZTimeCounterView* counterView;
    EZTimeCounter* counter;
}

- (EZTimeCounter*) createTimeCounter; 

//To find out any task will start to run now
//If found out return the index of the task
//The reason to add parameter is to make it more testable
//The influence from Lisp
- (NSInteger) findOngoingTask:(NSArray*)tks;

@end

@implementation EZScheduledTaskController
@synthesize currentDate, scheduledTasks, viewAppearBlock, superController;



//Just create the counter and the counter view.
//Set the proper frame for the counterView.
//The caller will take responsibility to restart it.
- (EZTimeCounter*) createTimeCounter
{
    EZTimeCounter* tc = [[EZTimeCounter alloc] init];
    EZTimeCounterView* cView = [EZEditLabelCellHolder createTimeCounterView];
    cView.frame = CGRectMake(200, 2, cView.frame.size.width, counterView.frame.size.height);
    tc.counterView = cView;
    return tc;
}

- (BOOL)canBecomeFirstResponder
{
    //EZDEBUG(@"canBecomeFirstResponder get called,stack trace %@",[NSThread callStackSymbols]);
    return TRUE;
}

- (void)viewDidAppear:(BOOL)animated {
    EZDEBUG(@"viewDidAppear get called");
    [self becomeFirstResponder];
    //currentDate = [NSDate date];
    //currentDate = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120629"];
    if(viewAppearBlock){
        viewAppearBlock();
        self.viewAppearBlock = nil;
    }
}

- (void) reloadScheduledTask:(NSDate *)date
{
    [self loadWithTask:[[EZTaskStore getInstance]getScheduledTaskByDate:date] date:date];
}

- (void) loadWithTask:(NSArray *)tasks date:(NSDate *)date
{
    currentDate = date;
    scheduledTasks = [NSMutableArray arrayWithArray:tasks];
    EZDEBUG(@"Before reload");
    [self.tableView reloadData];
    EZDEBUG(@"task count:%i for date:%@",scheduledTasks.count,[currentDate stringWithFormat:@"yyyyMMdd"]);
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
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Local(@"Reschedule?") message:Local(@"Are you sure you want reschedule? current schedule will be deleted") delegate:self cancelButtonTitle:Local(@"Cancel") otherButtonTitles:Local(@"Yes"), nil];
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
    [[EZTaskStore getInstance] storeObjects:scheduledTasks];
    [EZAlarmUtility setupAlarmBulk:scheduledTasks];
    [self.tableView reloadData];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
       
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
        [insertedPaths addObject:[NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section]];
    }
    [self.tableView insertRowsAtIndexPaths:insertedPaths withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
}

//Return -1 mean not found, is this a norm, I can make it a norm
- (NSInteger) findOngoingTask:(NSArray*)tks
{
    for(int i = 0; i < tks.count; i++){
        EZScheduledTask* st = [tks objectAtIndex:i];
        NSDate* endDate = [st.startTime adjustMinutes:st.duration];
        if([[NSDate date] InBetween:st.startTime end:endDate]){
            return i;
        }
    }
    return -1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //EZTaskStore* store = [EZTaskStore getInstance];
    //scheduledTasks = [store getScheduledTaskByDate:currentDate];
    //if([scheduledTasks count] == 0){
    //    [self presentShakeMessage:@"Shake shake"];
    //}
    //self.navigationItem.title = Local(@"Scheduled");
    counter = [self createTimeCounter];
    counter.isCounting = false;
    __weak EZScheduledTaskController* weakSelf = self;
    counter.tickBlock = ^(EZTimeCounter* ct){
        if(!ct.isCounting){
            counter.ongoingTaskPos = [weakSelf findOngoingTask:weakSelf.scheduledTasks];
            //EZDEBUG(@"Any task going on:%i",nowPos);
            if(counter.ongoingTaskPos < 0){//Quit if no task is showing
                return;
            }
            
            EZScheduledTask* st = [weakSelf.scheduledTasks objectAtIndex:counter.ongoingTaskPos];
            NSDate* endTime = [st.startTime adjustMinutes:st.duration];
            ct.remainTime = endTime.timeIntervalSinceNow;
            ct.isCounting = true;
            [ct update];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:counter.ongoingTaskPos inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            //Why do I need this. because the controller will
            //Be shared by different days.
            //When we switch back and forth some issue will show off
            if(ct.counterView.superview == nil){
                EZDEBUG(@"ct.counterView is removed from super");
                if(counter.ongoingTaskPos > -1){
                    NSMutableArray* arr = [NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:counter.ongoingTaskPos inSection:0]];
                    if((counter.ongoingTaskPos-1) > -1){
                        [arr addObject:[NSIndexPath indexPathForRow:counter.ongoingTaskPos - 1 inSection:0]];
                    }
                    [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
                }
            }
        }
    };
    counter.timeupOps = ^(EZTimeCounter* ct){
        EZDEBUG(@"TimeCounter timeout");
        ct.isCounting = false;
        [ct.counterView removeFromSuperview];
        //The the time message again
        if(counter.ongoingTaskPos > -1){
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:counter.ongoingTaskPos inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    [counter start:1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [counter stop];
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

//Return minus if the task not exist.
- (NSInteger) findTask:(EZScheduledTask*)task inArray:(NSArray*)tasks
{
    EZNumberWrapper* res = [EZNumberWrapper new];
    res.number = -1;
    [tasks enumerateObjectsUsingBlock:^(EZScheduledTask* obj, NSUInteger idx, BOOL *stop) {
        if([obj.PO.objectID isEqual:task.PO.objectID]){
            res.number = idx;
            *stop = true;
        }
    }];
    return res.number;
}


//The scheduledTask may or may not in current schduledTask list. 
//It will cause different behavior.
- (void) presentScheduledTask:(EZScheduledTask*)task
{
    EZScheduledDetail* scheduleDetail = [[EZScheduledDetail alloc] initWithStyle:UITableViewStyleGrouped];
    //EZScheduledTask* task = [scheduledTasks objectAtIndex:indexPath.row];
    scheduleDetail.schTask = task; 
    NSInteger pos = [self findTask:task inArray:scheduledTasks];
    
    scheduleDetail.deleteBlock = ^(){
        EZDEBUG(@"DeleteOp get called,pos:%i",pos);
        [EZAlarmUtility cancelAlarm:task];
        [[EZTaskStore getInstance] removeObject:task];
        if(pos > -1){
            NSMutableArray* mutArr = [NSMutableArray arrayWithArray:self.scheduledTasks];
            [mutArr removeObjectAtIndex:pos];
            self.scheduledTasks = mutArr;
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:pos inSection:0];
            [self performSelector:@selector(deleteRow:) withObject:indexPath afterDelay:0.3];
        }
    };
    
    scheduleDetail.rescheduleBlock = ^(){
        EZDEBUG(@"RescheduleOp get called");
        NSArray* schTasks = [[EZTaskScheduler getInstance] rescheduleStoredTask:task];
        if([schTasks count] > 0){
            [EZAlarmUtility cancelAlarm:task];
            [[EZTaskStore getInstance] removeObject:task];
            
            [[EZTaskStore getInstance] storeObjects:schTasks];
            [EZAlarmUtility setupAlarmBulk:schTasks];
            if(pos > -1){
                NSMutableArray* mutArr = [NSMutableArray arrayWithArray:self.scheduledTasks];
                [mutArr removeObjectAtIndex:pos];
                [mutArr addObjectsFromArray:schTasks];
                [mutArr sortUsingComparator:^(id obj1, id obj2) {
                    EZScheduledTask* task1 = obj1;
                    EZScheduledTask* task2 = obj2;
                    return [task1.startTime compare:task2.startTime];
                    
                }];
                self.scheduledTasks = mutArr;
                repalceTasks = schTasks;
                [self performSelector:@selector(replaceRow:) withObject:[NSIndexPath indexPathForRow:pos inSection:0] afterDelay:0.3];
            }
        }else{
            EZDEBUG(@"Could not find replacement for:%@",[task detail]);
        }
        
    };
    EZDEBUG(@"Before push detail");
    [self.navigationController pushViewController:scheduleDetail animated:NO];
    EZDEBUG(@"After push detail");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"Get cell for:%@, tableView frame:%@",indexPath, NSStringFromCGRect(self.tableView.frame));
    static NSString *CellIdentifier = @"ScheduledV2";
    EZScheduledTask* task = [scheduledTasks objectAtIndex:indexPath.row];
    EZScheduledV2Cell *cell = (EZScheduledV2Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [EZEditLabelCellHolder createScheduledV2Cell];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        EZDEBUG(@"Recycled:%@, for taskName:%@",cell.taskName.text, task.task.name);
    }
    
    
    cell.taskName.text = task.task.name;
    
    NSDate* endTime = [NSDate dateWithTimeInterval:task.duration*60 sinceDate:task.startTime];
    NSDate* now = [NSDate date];
    if([now InBetween:task.startTime end:endTime] ){
        EZDEBUG(@"Find current task.");
        [cell setStatus:EZ_NOW];
        if(cell.nowSign == nil){
            EZDEBUG(@"Add the counter now");
            cell.nowSign = counter.counterView;
            [cell addSubview:counter.counterView];
        }
        //cell.switchButton.enabled = false;
    }else if([task.startTime isPassed:now]) { //Passed task
        [cell setStatus:EZ_PASSED];
        if(cell.nowSign){
            [cell.nowSign removeFromSuperview];
            cell.nowSign = nil;
        }
        //cell.switchButton.enabled = false;
    } else {
        //cell.textLabel.textColor = FutureTaskColor;
        [cell setStatus:EZ_FUTURE];
        if(cell.nowSign){
            [cell.nowSign removeFromSuperview];
            cell.nowSign = nil;
        }
    }
    cell.startTime.text = [task.startTime stringWithFormat:@"MMM-dd HH:mm"];
    cell.endTime.text = [endTime stringWithFormat:@"HH:mm"];
    
    if(task.alarmType == EZ_MUTE){
        cell.alarmStatus.text = Local(@"OFF");
        cell.alarmStatus.textColor = [UIColor grayColor];
    }else{
        cell.alarmStatus.text = Local(@"ON");
        cell.alarmStatus.textColor = [UIColor createByHex:EZEditColor];
    }
    // Configure the cell..
    
    return cell;
}



#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    };
    
    scheduleDetail.rescheduleBlock = ^(){
        EZDEBUG(@"RescheduleOp get called");
        NSMutableArray* mutArr = [NSMutableArray arrayWithArray:self.scheduledTasks];
        NSArray* schTasks = [[EZTaskScheduler getInstance] rescheduleTask:task existTasks:scheduledTasks];
        if([schTasks count] > 0){
            [EZAlarmUtility cancelAlarm:task];
            [[EZTaskStore getInstance] removeObject:task];
            [[EZTaskStore getInstance] storeObjects:schTasks];
            [EZAlarmUtility setupAlarmBulk:schTasks];
            [mutArr removeObjectAtIndex:indexPath.row];
            [mutArr addObjectsFromArray:schTasks];
            [mutArr sortUsingComparator:^(id obj1, id obj2) {
                EZScheduledTask* task1 = obj1;
                EZScheduledTask* task2 = obj2;
                return [task1.startTime compare:task2.startTime];
                
            }];
            self.scheduledTasks = mutArr;
            repalceTasks = schTasks;
            [self performSelector:@selector(replaceRow:) withObject:indexPath afterDelay:0.3];
        }else{
            EZDEBUG(@"Could not find replacement for:%@",[task detail]);
        }
        
    };
    
    [self.superController.navigationController pushViewController:scheduleDetail animated:YES];

}

@end
