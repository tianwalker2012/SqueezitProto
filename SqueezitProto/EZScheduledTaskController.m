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
#import "EZScheduledDay.h"
#import "EZScheduledLayer.h"
#import "EZKeyBoardHolder.h"
#import "EZActivityLayer.h"
#import "EZDotRoller.h"
#import "EZThreadPool.h"
#import "EZScheduledTaskSlider.h"
#import "EZAppDelegate.h"

@interface EZNumberWrapper : NSObject 

@property (assign, nonatomic) NSInteger number;

@end

@implementation EZNumberWrapper
@synthesize number;
@end


@interface EZScheduledTaskController () {
    EZTimeCounterView* counterView;
    EZTimeCounter* counter;
    EZScheduledLayer* noTasklayer;
    EZActivityLayer* activityLayer;
    //What's the meaning of this flag?
    //Check it out. I will not allow vague naming like this in my code
    //This is unbearable. It seriously affect my intimate relationship with my code.
    //BOOL displayed;
}

- (EZTimeCounter*) createTimeCounter; 

//To find out any task will start to run now
//If found out return the index of the task
//The reason to add parameter is to make it more testable
//The influence from Lisp
- (NSInteger) findOngoingTask:(NSArray*)tks;

- (void) showNoTaskLayout;

- (void) hideNoTaskLayout;

- (void) showActivityLayer;

- (void) hideActivityLayer;

//This is the function without animation.
//Only have the logic of reschedule.
- (void) rawReschedule;

@end

@implementation EZScheduledTaskController
@synthesize currentDate, scheduledTasks, viewAppearBlock, superController, frameView;


//What's logic will be included in this method?
//If the currentDate is today,
//We can just get the date right. 
//The rescheduleAll will handle all the logic right.
- (void) rescheduleTasks
{
    [self hideNoTaskLayout];
    [self showActivityLayer];
    [self executeBlockInBackground:^(){
        [self rawReschedule];
        [self executeBlockInMainThread:^(){
            [self.tableView reloadData];
            [self hideActivityLayer];
        }];
        counter.isCounting = false;
    } inThread:[EZThreadPool getWorkerThread]];
    
}

//This will called when have no data.
//When it was dismissed?
- (void) showNoTaskLayout
{
    __weak EZScheduledTaskController* weakSelf = self;
    if(!noTasklayer){
        noTasklayer = [EZKeyBoardHolder createScheduledLayer];
        noTasklayer.infoLabel.text = Local(@"No Scheduled Tasks");
        noTasklayer.clickedBlock = ^(){
            //[weakSelf hideNoTaskLayout];
            noTasklayer.activityView.alpha = 1;
            [noTasklayer.activityView startAnimating];
            //EZDEBUG(@"Main threadID:%i",(NSInteger)[NSThread currentThread]);
            [weakSelf executeBlockInBackground:^(){
                [weakSelf rawReschedule];
                //EZDEBUG(@"Background threadID:%i", (NSInteger)[NSThread currentThread]);
                [weakSelf executeBlockInMainThread:^(){
                    [weakSelf.tableView reloadData];
                    [noTasklayer.activityView stopAnimating];
                    noTasklayer.activityView.alpha = 0;
                    [weakSelf hideNoTaskLayout];
                }];
            } inThread:[EZThreadPool getWorkerThread]];
        };
    }
    EZDEBUG(@"about to displayNoTaskLayer:%@", noTasklayer);
    //Why have this code? This is need explaination
    self.tableView.scrollEnabled = false;
    [self.frameView addSubview:noTasklayer];
}

- (void) rawReschedule
{
    EZDEBUG(@"date for the schedule is: %@", [currentDate stringWithFormat:@"yyyy-MM-dd"]);
    EZTaskScheduler* scheduler = [EZTaskScheduler getInstance];
    if([currentDate equalWith:[NSDate date] format:@"yyyyMMdd"]){
        currentDate = [currentDate combineTime:[NSDate date]];
    }
    scheduledTasks = [scheduler rescheduleAll:scheduledTasks date:currentDate];
    //[[EZTaskStore getInstance] storeObjects:scheduledTasks];
    //[EZAlarmUtility setupAlarmBulk:scheduledTasks];
    
    //Why do we have this?
    //I guess it is to display the day on the slider window, right?
    //Should we check if we already have this date or not right?
    EZDEBUG(@"Caused by null date:%@",[currentDate stringWithFormat:@"yyyyMMdd"]);
    EZScheduledDay* schDay = [[EZTaskStore getInstance] createDayNotExist:currentDate];
    schDay.scheduledDate = currentDate;
    [[EZTaskStore getInstance] storeObject:schDay];
    
}

- (void) hideNoTaskLayout
{
    self.tableView.scrollEnabled = true;
    [noTasklayer removeFromSuperview];
}

//This method is created for the purpose of testing today bug fixing
//Once this called I will start the time counter.
//Once the time counter started it will start and found out today is passed,
//Then it will call updateToday on the Slider, The slider will change the setting accordingly.
//My key observation is that the page will get refreshed.
- (void) startTimeCounter
{
   // EZDEBUG(@"Time counter is:%@", counter);
    [counter start:1];
}

- (void) showActivityLayer
{
    if(activityLayer == nil){
        activityLayer = [EZKeyBoardHolder createActivityLayer];
    }
    CGRect org = activityLayer.frame;
    activityLayer.frame = CGRectMake(0, self.tableView.contentOffset.y, org.size.width, org.size.height);
    self.tableView.scrollEnabled = false;
    [self.view addSubview:activityLayer];
    [activityLayer.activityView startAnimating];
}

- (void) hideActivityLayer
{
    self.tableView.scrollEnabled = true;
    [activityLayer.activityView stopAnimating];
    [activityLayer removeFromSuperview];
}

//Just create the counter and the counter view.
//Set the proper frame for the counterView.
//The caller will take responsibility to restart it.
//Who will call timeCounter?
//What's it's responsibility?
//It will create the time counter.
//What's the responsibility of TimeCounter?
//Will in charge of update the timer on the cell. 
- (EZTimeCounter*) createTimeCounter
{
    EZTimeCounter* tc = [[EZTimeCounter alloc] init];
    counterView = [EZEditLabelCellHolder createTimeCounterView];
    counterView.frame = CGRectMake(200, 2, counterView.frame.size.width, counterView.frame.size.height);
    tc.counterView = counterView;
    return tc;
}



//Who will call it.
//What's it's responsibility?
//Is this deprecated code.
- (void) reloadScheduledTask:(NSDate *)date
{
    self.currentDate = date;
    EZDEBUG(@"About to load task for date:%@",[date stringWithFormat:@"yyyyMMdd"]);
    if([date equalWith:[NSDate date] format:@"yyyyMMdd"]){
        [counter start:1];
    }else{
        [counter stop];
    }
    [self showActivityLayer];
    [self executeBlockInBackground:^(){
        NSArray* tasks = [[EZTaskStore getInstance]getScheduledTaskByDate:date];
        EZDEBUG(@"Task count:%i for date %@", tasks.count, [date stringWithFormat:@"yyyyMMdd"]);
        [self executeBlockInMainThread:^(){
            [self hideActivityLayer];
            if(tasks.count == 0){
                [self showNoTaskLayout];
                self.scheduledTasks = nil;
            }else{
                self.scheduledTasks = tasks;
                [self.tableView reloadData];
                [self hideNoTaskLayout];
            }
        }];
    } inThread:[EZThreadPool getWorkerThread]];
     
}

- (void) loadWithTask:(NSArray *)tasks date:(NSDate *)date
{
    
    if(tasks.count > 0){
        [self hideNoTaskLayout];
    }else{
        [self showNoTaskLayout];
        return;
    }
    [self showActivityLayer];
    //currentDate = date;
    scheduledTasks = [NSMutableArray arrayWithArray:tasks];
    //EZDEBUG(@"Before reload");
    [self.tableView reloadData];
    [self hideActivityLayer];
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


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
       
    }
    return self;
}



//Will delete data in tableView, not the data in persistent layer
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
//Who will call this?
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


//Another error causd by the block.
//What am I suspecting?
//The block keep the temporary data for reference. 
//Mean it will hold a copy of that data?
- (NSInteger) findOngoingTaskEx
{
    //EZDEBUG(@"Total count:%i",scheduledTasks.count);
    for(int i = 0; i < scheduledTasks.count; i++){
        EZScheduledTask* st = [scheduledTasks objectAtIndex:i];
        NSDate* endDate = [st.startTime adjustMinutes:st.duration];
        //EZDEBUG(@"%@: %@ - %@",st.task.name, [st.startTime stringWithFormat:@"dd-HHmmss"], [endDate stringWithFormat:@"dd-HHmmss"]);
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
    //displayed = false;
    counter = [self createTimeCounter];
    counter.isCounting = false;
    __weak EZScheduledTaskController* weakSelf = self;
    counter.tickBlock = ^(EZTimeCounter* ct){
        //EZDEBUG("isCounting: %@", ct.isCounting?@"TRUE":@"FALSE");
        if(!ct.isCounting){
            //Why this is the right place?
            NSDate* endDay = currentDate.ending;
            
            //If endOfDay is before the current Date, mean today is over.
            if([endDay isPassed:[NSDate date]]){
                EZDEBUG(@"today is passed, switch to another day");
                [ct stop];
                EZAppDelegate* delegate = (EZAppDelegate*)[UIApplication sharedApplication].delegate;
                [delegate.taskSlider updateToday:[NSDate date]];
                return;
            }
            counter.ongoingTaskPos = [weakSelf findOngoingTaskEx];
            //EZDEBUG(@"Any task going on:%i",counter.ongoingTaskPos);
            if(counter.ongoingTaskPos < 0){//Quit if no task is showing
                return;
            }
            
            EZScheduledTask* st = [weakSelf.scheduledTasks objectAtIndex:counter.ongoingTaskPos];
            //EZDEBUG(@"Ongoing task name:%@",st.task.name);
            NSDate* endTime = [st.startTime adjustMinutes:st.duration];
            ct.remainTime = endTime.timeIntervalSinceNow;
            ct.isCounting = true;
            //EZDEBUG(@"remainTime:%f, startTime:%@, duration:%i",ct.remainTime,[st.startTime stringWithFormat:@"HH:mm:ss"], st.duration);
            [ct update];
            EZScheduledV2Cell* cell = (EZScheduledV2Cell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:counter.ongoingTaskPos inSection:0]]; 
            [cell setStatus:EZ_NOW nowSign:counterView];
            
        }else{
            //Finally, I figure out why do I need to check whether the cell 
            //Have been recyled or not?
            //Because table view recycle the cell not according to my assumption. 
            //What should we do?
            //I guess this is the right solution
            if(ct.counterView.superview == nil && counter.ongoingTaskPos > -1){
                if([currentDate equalWith:[NSDate date] format:@"yyyyMMdd"]){
                    EZScheduledV2Cell* v2Cell = (EZScheduledV2Cell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:counter.ongoingTaskPos inSection:0]];
                    [v2Cell setStatus:EZ_NOW nowSign:ct.counterView];
                }
            }
            
        }
    };
    counter.timeupOps = ^(EZTimeCounter* ct){
        EZDEBUG(@"TimeCounter timeout, threadID:%i",(NSInteger)[NSThread currentThread]);
        ct.isCounting = false;
        if(counter.ongoingTaskPos > -1){
            EZScheduledV2Cell* cell = (EZScheduledV2Cell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:counter.ongoingTaskPos inSection:0]];
            [cell setStatus:EZ_PASSED nowSign:counterView];
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

- (BOOL)canBecomeFirstResponder
{
    //EZDEBUG(@"canBecomeFirstResponder get called,stack trace %@",[NSThread callStackSymbols]);
    return TRUE;
}

//This method will not be called, because they are not in the controller list.
//So no event will pass to them. as far as I know. 
//What should I do to enable the event. 
//Why? 
- (void)viewDidAppear:(BOOL)animated {
    EZDEBUG(@"viewDidAppear get called");
    [self becomeFirstResponder];
    //currentDate = [NSDate date];
    //currentDate = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120629"];
    if(viewAppearBlock){
        viewAppearBlock();
        self.viewAppearBlock = nil;
    }
    
    //Re add it again. 
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    EZDEBUG(@"viewWillDisappear get called");
    [super viewWillDisappear:animated];
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
            counter.isCounting = false;
        }
    };
    
    scheduleDetail.rescheduleBlock = ^(){
        EZDEBUG(@"RescheduleOp get called");
        //Some places the storage happened within, some place the storage happened outside.
        //Can I call this persistence inconsistency?
        //Nice name. 
        //Let's fix them.
        //I forget to do one thing, that is asking why? The reason is:
        //If I could not successfully find the replacement, I will not delete the old one.
        //That's why deletion should not happen within the method.
        NSArray* schTasks = [[EZTaskScheduler getInstance] rescheduleStoredTask:task];
        if([schTasks count] > 0){
            [EZAlarmUtility cancelAlarm:task];
            [[EZTaskStore getInstance] removeObject:task];
            
            //Do you feel this sandwitch like code are ugly?
            //How to fix them? No other way but the way of sandwitch. 
            //Because alarm need the objectID from stored object.
            [[EZTaskStore getInstance] storeObjects:schTasks];
            [EZAlarmUtility setupAlarmBulk:schTasks];
            [[EZTaskStore getInstance] storeObjects:schTasks];
            
            if(pos > -1){
                //Why? need to calculate the time again.
                counter.isCounting = false;
                
                
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
    //EZDEBUG(@"Before push detail:%@", self.navigationController);
    //[self.navigationController pushViewController:scheduleDetail animated:YES];
    [self.superController.navigationController pushViewController:scheduleDetail animated:NO];
    EZDEBUG(@"After push detail");
}

//Need to review the live cycle of the View controller to really understand what's going on. 
//This will have no effect, since it will not be called. Only the view get used.
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    EZDEBUG(@"Readd no task layer see if problem solved");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //EZDEBUG(@"Get cell for:%@, tableView frame:%@",indexPath, NSStringFromCGRect(self.tableView.frame));
    static NSString *CellIdentifier = @"ScheduledV2";
    EZScheduledTask* task = [scheduledTasks objectAtIndex:indexPath.row];
    EZScheduledV2Cell *cell = (EZScheduledV2Cell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [EZEditLabelCellHolder createScheduledV2Cell];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        //EZDEBUG(@"Recycled:%@, for taskName:%@",cell.taskName.text, task.task.name);
    }
    
    
    cell.taskName.text = task.task.name;
    
    NSDate* endTime = [NSDate dateWithTimeInterval:task.duration*60 sinceDate:task.startTime];
    NSDate* now = [NSDate date];
    if([now InBetween:task.startTime end:endTime] ){
        EZDEBUG(@"Find current task.");
        [cell setStatus:EZ_NOW nowSign:counterView];
        
    }else if([task.startTime isPassed:now]) { //Passed task
        [cell setStatus:EZ_PASSED nowSign:counterView];
        //cell.switchButton.enabled = false;
    } else {
        //cell.textLabel.textColor = FutureTaskColor;
        [cell setStatus:EZ_FUTURE nowSign:counterView];
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
    return 61;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EZScheduledDetail* scheduleDetail = [[EZScheduledDetail alloc] initWithStyle:UITableViewStyleGrouped];
    EZScheduledTask* task = [scheduledTasks objectAtIndex:indexPath.row];
    scheduleDetail.schTask = task; 
   
    scheduleDetail.deleteBlock = ^(){
        EZDEBUG(@"DeleteOp get called, task.name:%@, id:%@",task.task.name, task.PO.objectID);
        [EZAlarmUtility cancelAlarm:task];
        NSMutableArray* mutArr = [NSMutableArray arrayWithArray:self.scheduledTasks];
        [mutArr removeObjectAtIndex:indexPath.row];
        self.scheduledTasks = mutArr;
        [[EZTaskStore getInstance] removeObject:task];
        [self performSelector:@selector(deleteRow:) withObject:indexPath afterDelay:0.3];
        //Why? to fix the bug of after delete and reschedule some task will not show.
        counter.isCounting = false;
        
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
