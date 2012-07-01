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
#import "EZAvailableDayList.h"
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

@interface EZAppDelegate() {
    EZRootTabCtrl* tabCtrl;
    UINavigationController* scheduledNav;
    UINavigationController* taskNav;
    UINavigationController* timeSettingNav;
    EZScheduledTaskSlider* taskSlider;
    EZOperationBlock notificationBlock;
    NSTimer* tomorrowTimer;
    
}

- (void) scheduleForTomorrow;

@end


@implementation EZAppDelegate

@synthesize window = _window;
@synthesize rootCtrl;


- (void) setupNotification
{
    
    EZScheduledTask* schTask = [[EZScheduledTask alloc] init];
    schTask.startTime = [[NSDate date] adjustDays:-2];
    EZTask* task = [[EZTask alloc] initWithName:@"Tomorrow Test" duration:20 maxDur:20 envTraits:3];
    schTask.task = task;
    schTask.duration = 40;
    [[EZTaskStore getInstance] storeObject:schTask];
    
    NSString* taskURL = schTask.PO.objectID.URIRepresentation.absoluteString;
    UILocalNotification* nofication = [[UILocalNotification alloc] init];
    nofication.fireDate = [[NSDate date] adjust:20];
    nofication.alertBody = @"Test notification";
    //Mean I can pick my own customized name?
    nofication.soundName = UILocalNotificationDefaultSoundName;
    nofication.applicationIconBadgeNumber = 3;
    EZDEBUG(@"Notification creation,absolute taskURL:%@",taskURL);
    NSDictionary* infoDict = [NSDictionary dictionaryWithObjectsAndKeys:taskURL , EZNotificationKey,nil];
    nofication.userInfo = infoDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:nofication];
    EZDEBUG(@"Complete setup Nofication");
}


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
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:Local(@"Task %@ started %@"),schTask.task.name,startStr]  message:nil delegate:self cancelButtonTitle:Local(@"Cancel") otherButtonTitles:Local(@"Check It"),nil];
    [alertView show];
    
    notificationBlock = ^(){
        //I made assumption, this will 
        if(tabCtrl.selectedViewController != scheduledNav){
            tabCtrl.selectedViewController = scheduledNav;
        }
        EZDEBUG(@"Will pop to root");
        [scheduledNav popToRootViewControllerAnimated:NO];
        EZDEBUG(@"Start to present detail view");
        [taskSlider presentScheduledTask:schTask];
    };

}

- (void) processTomorrowNotify
{
    if([[EZTaskStore getInstance]getScheduledTaskByDate:[[NSDate date] adjustDays:1]].count > 0){
        EZDEBUG(@"Have scheduled for tomorrow, no showing of event");
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:Local(@"Want schedule task for tomorrow?") message:nil delegate:self cancelButtonTitle:Local(@"NO") otherButtonTitles:Local(@"YES"),nil];
    [alertView show];
    
    notificationBlock = ^(){
        //I made assumption, this will 
        if(tabCtrl.selectedViewController != scheduledNav){
            tabCtrl.selectedViewController = scheduledNav;
        }
        EZDEBUG(@"Will pop to root");
        [scheduledNav popToRootViewControllerAnimated:NO];
        EZDEBUG(@"Start to present detail view");
        [taskSlider scheduleForTomorrow];
    };

    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification 
{
    EZDEBUG(@"Recieved notification");
    
    //Any better place?
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString* taskIDURL = [notification.userInfo objectForKey:EZNotificationKey];
    NSString* tomorrowStr = [notification.userInfo objectForKey:EZAssignNotificationKey];    

    if(taskIDURL){
        [self processTaskNotify:taskIDURL];
    }else{
        //I don't need to care which days notify it is.
        //I only need to show them tomorrow.
        [self processTomorrowNotify];
    }
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

- (void) setupTomorrowNotification
{
    NSString* tomorrowNofityKey = @"TomorrowNotificationKey";
    NSString* disableTomorrowKey = @"DisableTomorrow";
    NSUserDefaults* userSetting = [NSUserDefaults standardUserDefaults];
    BOOL disabled = [userSetting boolForKey:disableTomorrowKey];
    if(disabled){
        EZDEBUG(@"Disabled by user");
        return;
    }
    id notifyObj = [userSetting objectForKey:tomorrowNofityKey];
    
    UILocalNotification* storeNotify = [NSKeyedUnarchiver unarchiveObjectWithData:notifyObj];
    if(notifyObj){
        EZDEBUG(@"already setup nofication, alertBody:%@",storeNotify.alertBody);
        return;
    }
    UILocalNotification* nofication = [[UILocalNotification alloc] init];
    NSDate* tomorrow = [[NSDate date] adjustDays:1];
    nofication.fireDate = [[NSDate date] adjust:20];
    nofication.alertBody = Local(@"Time to schedule tomorrow's task for you.");
        //Mean I can pick my own customized name?
    nofication.soundName = UILocalNotificationDefaultSoundName;
    nofication.applicationIconBadgeNumber = 1;
    nofication.repeatCalendar = nil;
    nofication.repeatInterval = kCFCalendarUnitDay;
    NSDictionary* infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[tomorrow stringWithFormat:@"yyyyMMdd"], EZAssignNotificationKey ,nil];
    nofication.userInfo = infoDict;
    [[UIApplication sharedApplication] scheduleLocalNotification:nofication];
    [userSetting setValue:[NSKeyedArchiver archivedDataWithRootObject:nofication] forKey:tomorrowNofityKey];
    
    
}

- (void) testRelatedActivity
{
    //[[EZTaskStore getInstance] removeScheduledTaskByDate:[[NSDate date]adjustDays:1]];
    //[self disableTomorrowNotification];
    //[self setupTomorrowNotification];
    [EZTestSuite testSchedule];
    
    //NSArray* flags = [[EZTaskStore getInstance] fetchAllWithVO:[EZEnvFlag class] PO:[MEnvFlag class] sortField:@"flag"];
    //EZDEBUG(@"Before delete, EnvFlag count %i,  The last flag is %i", flags.count, ((EZEnvFlag*)[flags objectAtIndex:flags.count -1]).flag);
    //[[EZTaskStore getInstance] removeObjects:flags];
    
    //[[EZTaskStore getInstance] fillEnvFlag];
    //EZDEBUG(@"EnvFlag count %i", [EZTaskStore getInstance].envFlags.count);
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    EZDEBUG(@"Lanch options:%@", launchOptions);
    [self testRelatedActivity];
    //[EZCoreAccessor cleanDefaultDB];
    //Make sure the persistence layer initialization completeds
    [EZCoreAccessor getInstance];
    if([[[EZTaskStore getInstance] fetchAllWithVO:[EZAvailableDay class] PO:[MAvailableDay class] sortField:nil] count] == 0){
        EZDEBUG(@"Fill Test data");
        [[EZTaskStore getInstance] fillTestData];
    }
    [[EZTaskStore getInstance] populateEnvFlags];
    //[self setupNotification];
    //Notification related code
    NSString* optionKey = @"UIApplicationLaunchOptionsLocalNotificationKey";
    UILocalNotification* notification = [launchOptions objectForKey:optionKey];
    if(notification != nil){
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    EZScheduledTask* schTask = [[EZTaskStore getInstance] fetchScheduledTaskByURL:[notification.userInfo objectForKey:EZNotificationKey]];
    
    NSString* tomorrowStr = [notification.userInfo objectForKey:EZAssignNotificationKey];
    //End of get notification
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.rootCtrl = [[UIViewController alloc] init];
    self.window.rootViewController = rootCtrl;
    [self.window addSubview:self.rootCtrl.view];
    tabCtrl = [[EZRootTabCtrl alloc] init];
    
    taskSlider = [[EZScheduledTaskSlider alloc] init];
    
    if(schTask){
        //__weak EZAppDelegate* weakSelf = self;
        taskSlider.viewAppearBlock = ^(){
            [taskSlider presentScheduledTask:schTask];
        };
    }
    
    if(tomorrowStr){
        taskSlider.viewAppearBlock = ^(){
            [taskSlider scheduleForTomorrow];
        };
    }
    
    //stc.currentDate = [NSDate date];
    scheduledNav = [[UINavigationController alloc] initWithRootViewController:taskSlider];
    
    //For the task configure
    EZListCtrl* tlc = [[EZListCtrl alloc] initWithStyle:UITableViewStylePlain isTasklist:YES];
    taskNav = [[UINavigationController alloc] initWithRootViewController:tlc];
    
    //For the time configure
    EZListCtrl* tsl = [[EZListCtrl alloc] initWithStyle:UITableViewStylePlain isTasklist:NO];
    timeSettingNav = [[UINavigationController alloc] initWithRootViewController:tsl];
    
    EZSlideViewWrapper* slider = [[EZSlideViewWrapper alloc] init];
    UINavigationController* sliderNav = [[UINavigationController alloc] initWithRootViewController:slider];
    
    EZConfigureCtrl* configurePage = [[EZConfigureCtrl alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController* configNav = [[UINavigationController alloc] initWithRootViewController:configurePage];
    
    tabCtrl.viewControllers = [NSArray arrayWithObjects:scheduledNav, taskNav, timeSettingNav, sliderNav, configNav, nil];
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
    EZDEBUG(@"applicationDidEnterBackground get called");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    EZDEBUG(@"applicationWillEnterForeground get called");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
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
