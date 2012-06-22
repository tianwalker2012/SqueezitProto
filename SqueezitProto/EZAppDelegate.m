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
#import "EZTaskListCtrl.h"
#import "EZRootTabCtrl.h"
#import "EZAvailableDayList.h"
#import "EZTask.h"
#import "EZScheduledTask.h"
#import "EZTaskHelper.h"
#import "MScheduledTask.h"

@interface EZAppDelegate() {
    EZRootTabCtrl* tabCtrl;
    UINavigationController* scheduledNav;
    UINavigationController* taskNav;
    UINavigationController* timeSettingNav;
    EZScheduledTaskController* scheduledListCtrl;
    
}

@end


@implementation EZAppDelegate

@synthesize window = _window;
@synthesize rootCtrl;


- (void) setupNotification
{
    
    EZScheduledTask* schTask = [[EZScheduledTask alloc] init];
    schTask.startTime = [[NSDate date] adjustDays:1];
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification 
{
    EZDEBUG(@"Recieved notification");
    
    //Any better place?
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString* taskIDURL = [notification.userInfo objectForKey:EZNotificationKey];
    EZScheduledTask* schTask = [[EZTaskStore getInstance] fetchScheduledTaskByURL:taskIDURL];
    //Should I show a warning page?
    //Add it later. Edge case, let's polish it gradually
    EZDEBUG(@"TaskURL:%@, task name:%@", taskIDURL, schTask.task.name);
    if(schTask == nil){
        EZDEBUG(@"Can not find ScheduledTask");
        return;
    }
    //I made assumption, this will not change
    if(tabCtrl.selectedViewController != scheduledNav){
        EZDEBUG(@"Switch to correct navigation");
        tabCtrl.selectedViewController = scheduledNav;
    }
    EZDEBUG(@"Will pop to root");
    [scheduledNav popToRootViewControllerAnimated:NO];
    EZDEBUG(@"Start to present detail view");
    [scheduledListCtrl presentScheduledTask:schTask];
    if(scheduledListCtrl.navigationController != scheduledNav){
        EZDEBUG(@"There are different navigation controller");
    }else{
        EZDEBUG(@"They navigation controller is the same");
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    EZDEBUG(@"Lanch options:%@", launchOptions);
    [EZTestSuite testSchedule];
    //[EZCoreAccessor cleanDefaultDB];
    //Make sure the persistence layer initialization completeds
    [EZCoreAccessor getInstance];
    if([[[EZTaskStore getInstance] fetchAllWithVO:[EZAvailableDay class] po:[MAvailableDay class] sortField:nil] count] == 0){
        EZDEBUG(@"Fill Test data");
        [[EZTaskStore getInstance] fillTestData];
    }
    [[EZTaskStore getInstance] populateEnvFlags];
    [self setupNotification];
    
    
    //Notification related code
    NSString* optionKey = @"UIApplicationLaunchOptionsLocalNotificationKey";
    UILocalNotification* notification = [launchOptions objectForKey:optionKey];
    if(notification != nil){
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    EZScheduledTask* schTask = [[EZTaskStore getInstance] fetchScheduledTaskByURL:[notification.userInfo objectForKey:EZNotificationKey]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.rootCtrl = [[UIViewController alloc] init];
    self.window.rootViewController = rootCtrl;
    [self.window addSubview:self.rootCtrl.view];
    tabCtrl = [[EZRootTabCtrl alloc] init];
    scheduledListCtrl = [[EZScheduledTaskController alloc] initWithStyle:UITableViewStylePlain];
    if(schTask){
        scheduledListCtrl.viewAppearBlock = ^(){
            [scheduledListCtrl presentScheduledTask:schTask];
        };
    }
    
    
    //stc.currentDate = [NSDate date];
    scheduledNav = [[UINavigationController alloc] initWithRootViewController:scheduledListCtrl];
    
    EZTaskListCtrl* tlc = [[EZTaskListCtrl alloc] initWithStyle:UITableViewStylePlain];
    taskNav = [[UINavigationController alloc] initWithRootViewController:tlc];
    
    EZAvailableDayList* tsl = [[EZAvailableDayList alloc] initWithStyle:UITableViewStylePlain];
    timeSettingNav = [[UINavigationController alloc] initWithRootViewController:tsl];
    
    tabCtrl.viewControllers = [NSArray arrayWithObjects:scheduledNav, taskNav, timeSettingNav, nil];
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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EZCoreAccessor getInstance] saveContext];
}

@end
