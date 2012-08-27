//
//  EZAppDelegate.m
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAppDelegate.h"
#import "EZTestSuite.h"
#import "EZCoreAccessor.h"
#import "EZTaskStore.h"
#import "EZAvailableDay.h"
#import "MAvailableDay.h"
#import "EZMainCtrl.h"
#import "EZScheduledTaskController.h"
#import "EZListCtrl.h"
#import "EZRootTabCtrl.h"
#import "EZTask.h"
#import "EZScheduledTask.h"
#import "EZTaskHelper.h"
#import "MScheduledTask.h"
#import "EZSlideViewTester.h"
#import "EZViewLayoutTester.h"
#import "EZSlideViewWrapper.h"
#import "EZScheduledTaskSlider.h"
#import "EZGlobalLocalize.h"
#import "EZConfigureCtrl.h"
#import "MEnvFlag.h"
#import "EZEnvFlag.h"
#import "EZAlarmUtility.h"
#import "EZStatisticMainCtrl.h"
#import "EZTestDotRoller.h"

@interface EZAppDelegate() {
    EZRootTabCtrl* tabCtrl;
    UINavigationController* scheduledNav;
    UINavigationController* taskNav;
    UINavigationController* timeSettingNav;
    EZScheduledTaskSlider* taskSlider;
    EZOperationBlock notificationBlock;
    NSTimer* tomorrowTimer;
    
    //What's the purpose of this flag?
    //Used to differentiate the notification case 1 from case 2. Case 2 should be like Case 3. 
    BOOL notifiedInBackground;
    
}

- (void) scheduleForTomorrow;

//Don't repeat yourself.
- (void) raiseAlertView:(NSString*)title cancelText:(NSString*)cancelText otherText:(NSString*)otherText yesBlock:(EZOperationBlock)blk;


//This will be called for the first time the application started
- (void) firstTimeCall;


@end


@implementation EZAppDelegate

@synthesize window = _window;
@synthesize rootCtrl;


//What's the purpose of this function?
//When a notification recieved, this method will get called. 
//What will happen?
//System will generate a alertView, Tell user what happen. User could determined what to do.
//The AlertView have a delegate. The user action will be processed in the Delegate. 
//Why not allow block to do this?
//We have context information for this. Much better for the logic right. 
//Check if API provide block way of call back or not. 
//AlertView could be explicitly dismissed by function call. 
//Start of notification processing code {{
- (void) processTaskNotify:(NSString*)taskIDURL
{
    EZScheduledTask* schTask = [[EZTaskStore getInstance] fetchScheduledTaskByURL:taskIDURL];
    //Should I show a warning page?
    //Add it later. Edge case, let's polish it gradually
    EZDEBUG(@"TaskURL:%@, task name:%@", taskIDURL, schTask.task.name);
    if(schTask == nil){
        EZDEBUG(@"Can not find ScheduledTask");
        return;
    }
    NSString* startStr = Local(@"now");
    NSTimeInterval passed = [schTask.startTime timeIntervalSinceNow];
    passed = -passed;
    if(passed > 60){
        int minutes = passed;
        minutes = minutes/60;
        startStr = [NSString stringWithFormat:@"%i minutes ago",minutes];
    }
    
    EZOperationBlock optBlock = ^(){
        //I made assumption, this will 
        if(tabCtrl.selectedViewController != scheduledNav){
            tabCtrl.selectedViewController = scheduledNav;
        }
        EZDEBUG(@"Will pop to root");
        [scheduledNav popToRootViewControllerAnimated:NO];
        EZDEBUG(@"Start to present detail view");
        [taskSlider presentScheduledTask:schTask];
    };
    
    [self raiseAlertView:[NSString stringWithFormat:Local(@"Task %@ started %@"),schTask.task.name,startStr] cancelText:Local(@"Canel") otherText:Local(@"Check It") yesBlock:optBlock];
    
}

//What's the purpose of this code?
//If user click the notification of tomorrow, this will get called.
//It will bring user to the tomorrow's scheduled screen.
//As long as it is tomorrow's notification, no matter which's day's notification, it will bring
//User to current tomorrow. You know what I mean, 
//For example in June 20 I sent out a tomorrow notification, if user open it June 25, I will jump to 
//June 26 rather than June 21, right?
//Cool. 
- (void) processTomorrowNotify
{
    if([[EZTaskStore getInstance]getScheduledTaskByDate:[[NSDate date] adjustDays:1]].count > 0){
        EZDEBUG(@"Have scheduled for tomorrow, no showing of event");
    }
    
    EZOperationBlock optBlock = ^(){
        //I made assumption, this will 
        if(tabCtrl.selectedViewController != scheduledNav){
            tabCtrl.selectedViewController = scheduledNav;
        }
        EZDEBUG(@"Will pop to root");
        [scheduledNav popToRootViewControllerAnimated:NO];
        EZDEBUG(@"Start to present detail view");
        [taskSlider scheduleForTomorrow];
    };
    
    [self raiseAlertView:Local(@"Schedule task for tomorrow?")  cancelText:Local(@"NO") otherText:Local(@"YES") yesBlock:optBlock];
    
}

//Raise the alertView
- (void) raiseAlertView:(NSString*)title cancelText:(NSString*)cancelText otherText:(NSString*)otherText yesBlock:(EZOperationBlock)blk
{
    notificationBlock = blk;
    if(notifiedInBackground){
        notificationBlock();
        return;
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:cancelText otherButtonTitles:otherText ,nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        EZDEBUG(@"Cancelled");
    }else if(notificationBlock){
        notificationBlock();
    }
    notificationBlock = nil;
}




//Who will call this?
//When we change the tomorrow notification's time. 
//When have options to change the time. 
//OK. I used the NSKeyedUnarchiever to persist the data.
- (void) disableTomorrowNotification
{
    NSString* tomorrowNofityKey = @"TomorrowNotificationKey";
    NSUserDefaults* userSetting = [NSUserDefaults standardUserDefaults];
    id notifyObj = [userSetting objectForKey:tomorrowNofityKey];
    [userSetting removeObjectForKey:tomorrowNofityKey];
    UILocalNotification* storeNotify = [NSKeyedUnarchiver unarchiveObjectWithData:notifyObj];
    [[UIApplication sharedApplication] cancelLocalNotification:storeNotify];
    EZDEBUG(@"Canceled notification:%@",storeNotify.alertBody);
}


//All the test code invoked here. 
//It was called before any window are generated. 
- (void) testRelatedActivity
{
   
    [EZTestSuite testSchedule];
    EZScheduledTask* schTask = [[EZScheduledTask alloc] init];
    EZTask* notificationTest = [[EZTask alloc] initWithName:@"Notification Test"];
    schTask.startTime = [[NSDate date] adjust:20];
    schTask.task = notificationTest;
    
}

//This is suitable to call here.
//Why?
- (void) firstTimeCall
{
    EZDEBUG(@"Fill Test data");
    [[EZTaskStore getInstance] fillTestData];
    
    //For the first time, I will setup the daily notification time
    //Test daily notification setup for the first time
    //NSString* timeStr = [[[NSDate date] adjust:50] stringWithFormat:@"HH:mm"];
    NSDate* date = [[NSDate date] combineTime:[NSDate stringToDate:@"HH:mm" dateString:@"22:30"]];
    UILocalNotification* notes = [EZAlarmUtility createNotificationFromDate:date];
    [EZAlarmUtility setupDailyNotification:notes];
    //EZDEBUG(@"Completed setup the daily notificaiton, time is:%@",[date stringWithFormat:@"dd HH:mm:ss"]);
    //Setup the notification for tomorrow. 
    //Encapsulate all the detail to the AlarmUtility.
    
}

- (EZScheduledTask*) getTaskFromNotification:(NSDictionary*)launchOptions
{
    EZDEBUG(@"TaskFromNotification get called");
    NSString* optionKey = @"UIApplicationLaunchOptionsLocalNotificationKey";
    UILocalNotification* notification = [launchOptions objectForKey:optionKey];
    EZScheduledTask* schTask = nil;
    if(notification != nil){
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        NSString* taskID = [notification.userInfo objectForKey:EZNotificationKey];
        if(taskID){
            schTask = [[EZTaskStore getInstance] fetchScheduledTaskByURL:taskID];
        }
        EZDEBUG(@"Try to get data from notification, taskID:%@, Task is:%@",taskID, schTask.task.name);
    }
    return schTask;
}

- (NSString*) getTomorrowFromNotification:(NSDictionary*)launchOptions
{
    EZDEBUG(@"TomorrowFromNotification get called");
    NSString* optionKey = @"UIApplicationLaunchOptionsLocalNotificationKey";
    UILocalNotification* notification = [launchOptions objectForKey:optionKey];
    if(notification != nil){
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        NSString* tomorrow = [notification.userInfo objectForKey:EZAssignNotificationKey];
        EZDEBUG(@"Try to get data from notification, Tomorrow:%@",tomorrow);
        return tomorrow;
    }
    return nil;
}



//When this will get called?
//We will have 3 status, right?
//1. Application in the foreground, recieved a notification
//2. Application in the background, recieved a notification
//3. Application are not started, it started by system, when user click a notification.
//I guess the 1,2 are belonging to this case. 
//Honestly, when application in background, user click the notification, it should not start the alertView again.
//Right? so case 2, should different with case 1. Currently, I am doing the same thing. 
//The pre-condition to differentiate this 2 is that, somewhere I should have the difference, right?
//It depends on the live cycle right?
//Why something wrong, I guess we failed to get data out of the database, since we cleaned the database.
//This really make sense. 
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification 
{
    EZDEBUG(@"Recieved notification");
    
    //Any better place?
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString* taskIDURL = [notification.userInfo objectForKey:EZNotificationKey];
    
    
    NSString* tomorrowStr = [notification.userInfo objectForKey:EZAssignNotificationKey];    
    
    EZDEBUG(@"userInfo:%@, taskIDURL:%@, tomorrowStr:%@", notification.userInfo, taskIDURL, tomorrowStr);
    
    if(taskIDURL){
        [self processTaskNotify:taskIDURL];
    }else if(tomorrowStr){
        //I don't need to care which days notify it is.
        //I only need to show them tomorrow.
        [self processTomorrowNotify];
    }else{
        EZDEBUG(@"Why notification with no task nor tomorrow");
    }
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    EZDEBUG(@"Lanch options:%@", launchOptions);
    
    //Test related behavior happened in this method
    [self testRelatedActivity];
  
    [EZCoreAccessor cleanDB:CoreDBName];
    [[EZTaskStore getInstance] fillTestData];
    //EZDEBUG(@"After clean the database");
    //[[EZTaskStore getInstance] setFirstTime:true];
    EZDEBUG(@"initialize staff");
    [EZCoreAccessor getInstance];
    //[[EZTaskStore getInstance] setFirstTime:TRUE];
    if([[EZTaskStore getInstance] isFirstTime]){
        [self firstTimeCall];
        [[EZTaskStore getInstance] setFirstTime:false];
    }
    
    [[EZTaskStore getInstance] populateEnvFlags];
    //[EZTestSuite cleanOrphanTask];
    
    
    //[self setupNotification];
    //Notification related code
    //The time before refactoring are trying to understand them.
    
    EZScheduledTask* schTask = [self getTaskFromNotification:launchOptions];
    NSString* tomorrowStr = [self getTomorrowFromNotification:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.rootCtrl = [[UIViewController alloc] init];
    self.window.rootViewController = rootCtrl;
    [self.window addSubview:self.rootCtrl.view];
    tabCtrl = [[EZRootTabCtrl alloc] init];
    
    taskSlider = [[EZScheduledTaskSlider alloc] init];
    
    //Will not show off at the same time
    //Why do we need this?
    //If we started because some notification user clicked, we will jump to the content.
    //This is a mechanism we have built for the action after the controller are loaded.
    if(schTask){
        //__weak EZAppDelegate* weakSelf = self;
        taskSlider.viewAppearBlock = ^(){
            [taskSlider presentScheduledTask:schTask];
        };
    }else if(tomorrowStr){
        taskSlider.viewAppearBlock = ^(){
            [taskSlider scheduleForTomorrow];
        };
    }
    
    //stc.currentDate = [NSDate date];
    scheduledNav = [[UINavigationController alloc] initWithRootViewController:taskSlider];
    
    //For the task list
    EZListCtrl* tlc = [[EZListCtrl alloc] initWithStyle:UITableViewStylePlain isTasklist:YES];
    taskNav = [[UINavigationController alloc] initWithRootViewController:tlc];
    
    //For the time configure
    EZListCtrl* tsl = [[EZListCtrl alloc] initWithStyle:UITableViewStylePlain isTasklist:NO];
    timeSettingNav = [[UINavigationController alloc] initWithRootViewController:tsl];
    
    //Remove statistics, only add function when all the functionality are stable, and have firm feedback from user that we are developing something people really need. 
    //Otherwise don't do this. 
    //EZSlideViewWrapper* slider = [[EZSlideViewWrapper alloc] init];
    //EZStatisticMainCtrl* stats = [[EZStatisticMainCtrl alloc] initWithStyle:UITableViewStyleGrouped];
    
    
    //UINavigationController* sliderNav = [[UINavigationController alloc] initWithRootViewController:stats];
    //EZViewLayoutTester* viewTester = [[EZViewLayoutTester alloc] initWithName:@"Tester"];
    
    
    EZTestDotRoller* test = [[EZTestDotRoller alloc] initWithNibName:nil bundle:nil];
    UINavigationController* dotNav = [[UINavigationController alloc] initWithRootViewController:test];
    
    EZConfigureCtrl* configurePage = [[EZConfigureCtrl alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController* configNav = [[UINavigationController alloc] initWithRootViewController:configurePage];
    
    tabCtrl.viewControllers = [NSArray arrayWithObjects:scheduledNav, taskNav, timeSettingNav, configNav, dotNav, nil];
    //self.window.rootViewController = tabCtrl;
    [self.rootCtrl addChildViewController:tabCtrl];
    [self.rootCtrl.view addSubview:tabCtrl.view];
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    EZDEBUG(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //Persistent the data in the session to disk.
    [[EZCoreAccessor getInstance] saveContext];
    EZDEBUG(@"applicationDidEnterBackground get called");
}

//Actually, this will get called. 
//The call sequence is WillEnterForeground then didRecieveLocalNotification.
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    notifiedInBackground = TRUE;
    EZDEBUG(@"applicationWillEnterForeground get called");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    notifiedInBackground = FALSE;
    EZDEBUG(@"applicationDidBecomeActive get called");
}

- (void) sendTimeAssignmentNotification:(NSDate*)date assignedDate:(NSDate*)assignedDate;
{
    UILocalNotification* nofication = [[UILocalNotification alloc] init];
    nofication.fireDate = date;
    nofication.alertBody = Local(@"Squeezit have scheduled tomorrow tasks for you, please check.");
    //Mean I can pick my own customized name?
    nofication.soundName = UILocalNotificationDefaultSoundName;
    nofication.applicationIconBadgeNumber = 1;
    NSDictionary* infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[assignedDate stringWithFormat:@"yyyyMMdd"] , EZAssignNotificationKey, nil];
    nofication.userInfo = infoDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:nofication];
}


- (BOOL) haveScheduled:(NSDate*)date
{
    return [[EZTaskStore getInstance] getScheduledTaskByDate:date].count > 0;
}

- (void) scheduleForTomorrow
{
    if([self haveScheduled:[[NSDate date] adjustDays:1]]){
        EZDEBUG(@"Quit since already scheduled");
    }
    
    
}
//I will take case of the case, if date already passed.
- (void) setTimerForTomorrowSchedule:(NSDate*)date
{
    NSTimeInterval gap = [date timeIntervalSinceNow];
    
    if(gap <= 0){
        //Mean if ready due, we will start after 15 seconds
        gap = 15;
    }
    
    tomorrowTimer = [NSTimer scheduledTimerWithTimeInterval:gap target:self selector:@selector(scheduleForTomorrow) userInfo:nil repeats:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    [[EZCoreAccessor getInstance] saveContext];
   
}

@end
