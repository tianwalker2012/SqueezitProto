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
        if(scheduledTasks){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Shakeduler" message:@"Are you sure you want reschedule?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
            [alert show];
        }else{
        //message.text = @"Shaked";
            [self rescheduleTasks];
        }
    }
    
}

- (void) rescheduleTasks
{
    EZTaskScheduler* scheduler = [EZTaskScheduler getInstance];
    scheduledTasks = [scheduler scheduleTaskByDate:currentDate exclusiveList:nil];
    [EZAlarmUtility setupAlarmBulk:scheduledTasks];
    [self.tableView reloadData];
    [self cancelShakeMessage];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        currentDate = [NSDate date];
    }
    return self;
}

- (void) presentShakeMessage:(NSString*)msg
{
    if(!shakeMessage){
        shakeMessage = [[UIView alloc] initWithFrame:self.view.bounds];
        shakeMessage.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        shakeMessage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        message.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        message.center = shakeMessage.center;
        //message.font = [[UIFont alloc] init];
        message.textAlignment = UITextAlignmentCenter;
        message.text = msg;
        [shakeMessage addSubview:message];
    }else{
        message.text = msg;
    }
    [self.view addSubview:shakeMessage];
}

//Could this be animatable?
//Let's give a shot later.
- (void) cancelShakeMessage
{
    [shakeMessage removeFromSuperview];
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
    NSLog(@"I am NSLog");
    EZDEBUG(@"I am EZDEBUG");
    [super viewDidLoad];
    //[UIApplication sharedApplication]
    
    EZTaskStore* store = [EZTaskStore getInstance];
    [store fillTestData];
    //EZTaskScheduler* scheduler = [[EZTaskScheduler alloc] init];
    //scheduledTasks = [scheduler scheduleTaskByDate:currentDate exclusiveList:nil];
    scheduledTasks = [store getScheduledTaskByDate:currentDate];
    if(!scheduledTasks){
        [self presentShakeMessage:@"Shake shake"];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    static NSString *CellIdentifier = @"ContentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ContentCell"];
    }
    EZScheduledTask* task = [scheduledTasks objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",task.task.name,(task.alarmNotification?@"setup alarm":@"no alarm")];
    NSDate* endTime = [NSDate dateWithTimeInterval:task.duration*60 sinceDate:task.startTime];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",[task.startTime stringWithFormat:@"HH:mm"],[endTime stringWithFormat:@"HH:mm"]];
    
    // Configure the cell..
    
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
    // Navigation logic may go here. Create and push another view controller.
        
    EZScheduledTaskDetailCtrl* detailViewController = [[EZScheduledTaskDetailCtrl alloc] initWithNibName:@"EZScheduledTaskDetailCtrl" bundle:nil];
    EZScheduledTask* task = [scheduledTasks objectAtIndex:indexPath.row];
    detailViewController.schTask = task; 
    //detailViewController.row = indexPath.row;
    detailViewController.indexPath = indexPath;
    detailViewController.deleteOp = ^(NSIndexPath* path){
        EZDEBUG(@"DeleteOp get called");
        EZScheduledTask* delTask = [scheduledTasks objectAtIndex:path.row];
        [EZAlarmUtility cancelAlarm:delTask];
        NSMutableArray* mutArr = [NSMutableArray arrayWithArray:self.scheduledTasks];
        [mutArr removeObjectAtIndex:path.row];
        self.scheduledTasks = mutArr;
        //How to animate more precisely.
        //[self.tableView reloadData];
        [self dismissModalViewControllerAnimated:YES];
        [self performSelector:@selector(deleteRow:) withObject:path afterDelay:0.3];
        //[self deleteRow:path];
    };
    
    detailViewController.reschuduleOp = ^(NSIndexPath* path){
        EZDEBUG(@"RescheduleOp get called");
        NSMutableArray* mutArr = [NSMutableArray arrayWithArray:self.scheduledTasks];
        EZScheduledTask* schTask = [mutArr objectAtIndex:path.row];
        
        NSArray* schTasks = [[EZTaskScheduler getInstance] rescheduleTask:schTask existTasks:scheduledTasks];
        if([schTasks count] > 0){
            [EZAlarmUtility cancelAlarm:[mutArr objectAtIndex:path.row]];
            [EZAlarmUtility setupAlarmBulk:schTasks];
            [mutArr removeObjectAtIndex:path.row];
            [mutArr addObjectsFromArray:schTasks];
            [mutArr sortUsingComparator:^(id obj1, id obj2) {
                EZScheduledTask* task1 = obj1;
                EZScheduledTask* task2 = obj2;
                return [task1.startTime compare:task2.startTime];
                
            }];
            self.scheduledTasks = mutArr;
            //[self.tableView reloadData];
            [self dismissModalViewControllerAnimated:YES];
            repalceTasks = schTasks;
            [self performSelector:@selector(replaceRow:) withObject:path afterDelay:0.3];
        }else{
            EZDEBUG(@"Could not find replacement for:%@",[schTask detail]);
        }
        
    };
    
    //The purpose of this is to provide a bar to anchor the button and the title.
    UIViewController* dummyRoot = [[UIViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:dummyRoot];
    [nav pushViewController:detailViewController animated:NO];
    // ...
     // Pass the selected object to the new view controller.
    [self presentModalViewController:nav animated:YES];
}

@end
