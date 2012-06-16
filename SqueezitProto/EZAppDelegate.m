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

#import "EZTestTabCtrl.h"
#import "EZTestViewCtrl.h"
#import "EZAvailableDayList.h"

@implementation EZAppDelegate

@synthesize window = _window;
@synthesize rootCtrl;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [EZTestSuite testSchedule];
    [EZCoreAccessor cleanDefaultDB];
    //Make sure the persistence layer initialization completeds
    [EZCoreAccessor getInstance];
    if([[[EZTaskStore getInstance] fetchAllWithVO:[EZAvailableDay class] po:[MAvailableDay class] sortField:nil] count] == 0){
        EZDEBUG(@"Fill Test data");
        [[EZTaskStore getInstance] fillTestData];
    }
    [[EZTaskStore getInstance] populateEnvFlags];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /**
    self.rootCtrl = [[UIViewController alloc] init];
    self.window.rootViewController = rootCtrl;
    [self.window addSubview:self.rootCtrl.view];
    
    
    EZMainCtrl* mctrl = [[EZMainCtrl alloc] init];
    // Custom initialization
    EZScheduledTaskController* stc = [[EZScheduledTaskController alloc] initWithStyle:UITableViewStylePlain];
    EZTaskListCtrl* tlc = [[EZTaskListCtrl alloc] initWithStyle:UITableViewStylePlain];
    mctrl.viewControllers = [NSArray arrayWithObjects:stc, tlc, nil];
    [self.rootCtrl addChildViewController:mctrl];
    [self.rootCtrl.view addSubview:mctrl.view];
    **/
    
    self.rootCtrl = [[UIViewController alloc] init];
    self.window.rootViewController = rootCtrl;
    [self.window addSubview:self.rootCtrl.view];
    EZTestTabCtrl* tabCtrl = [[EZTestTabCtrl alloc] init];
    EZTestViewCtrl* viewCtrl1 = [[EZTestViewCtrl alloc] init];
    EZTestViewCtrl* viewCtrl2 = [[EZTestViewCtrl alloc] init];
    EZScheduledTaskController* stc = [[EZScheduledTaskController alloc] initWithStyle:UITableViewStylePlain];
    
    stc.currentDate = [NSDate stringToDate:@"yyyyMMdd" dateString:@"20120615"];
    UINavigationController* nstc = [[UINavigationController alloc] initWithRootViewController:stc];
    
    EZTaskListCtrl* tlc = [[EZTaskListCtrl alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController* tnav = [[UINavigationController alloc] initWithRootViewController:tlc];
    
    EZAvailableDayList* tsl = [[EZAvailableDayList alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController* tslNav = [[UINavigationController alloc] initWithRootViewController:tsl];
    
    tabCtrl.viewControllers = [NSArray arrayWithObjects:nstc, tnav, tslNav,viewCtrl2, nil];
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
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EZCoreAccessor getInstance] saveContext];
}

@end
