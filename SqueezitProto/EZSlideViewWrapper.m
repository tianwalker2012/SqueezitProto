//
//  EZSlideViewWrapper.m
//  SqueezitProto
//
//  Created by Apple on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZSlideViewWrapper.h"
#import "Constants.h"
#import "EZViewWrapper.h"
#import "EZViewLayoutTester.h"
#import "EZTestTableViewCtrl.h"
#import "EZScheduledTask.h"
#import "EZTaskScheduler.h"
#import "EZTaskStore.h"
#import "EZScheduledTaskController.h"
#import "EZAlarmUtility.h"
#import "Constants.h"

@interface EZSlideViewWrapper () {
    //NSMutableDictionary* currentViews;
    NSInteger curPageCount;
}

- (void) moveToLast;

@end

@implementation EZSlideViewWrapper


- (void) moveToLast
{
    EZDEBUG(@"Move to last get called");
    self.currentPage = 20;
    EZDEBUG(@"Move to last is over");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init
{
    self = [super init];
    self.containerDelegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moveToLast)];
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
    curPageCount = 10;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.wantsFullScreenLayout = true;
    
    [self performBlock:^(){
    UIPageControl* pc = [[UIPageControl alloc] initWithFrame:CGRectMake(0,0, 320, 10)];
    pc.backgroundColor = [UIColor grayColor];
    pc.numberOfPages = 20;
    pc.currentPage = 0;
    [self.view addSubview:pc];
    } withDelay:0.1];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger) nextPage:(NSInteger)page
{
    EZDEBUG(@"nextPage:%i",page);
    curPageCount = page+1;
    return curPageCount;
}

- (NSInteger) pageCount:(EZSlideViewContainer*)container
{
    EZDEBUG(@"Page count get called");
    return curPageCount;
}

/**
- (EZViewWrapper*) container:(EZSlideViewContainer*)container viewForPage:(NSInteger)page
{
    EZDEBUG(@"viewForPage %i",page);
    NSString* identifier = @"TaskController";
    EZViewWrapper* res = [self dequeueWithIdentifier:identifier];
    if(res == nil){
        EZScheduledTaskController* stc = [[EZScheduledTaskController alloc] initWithStyle:UITableViewStylePlain];
        
        stc.currentDate = [NSDate date];
        NSArray* schTasks = [[EZTaskStore getInstance]getScheduledTaskByDate:stc.currentDate];
        if(schTasks.count == 0){
            schTasks = [[[EZTaskScheduler alloc]init] scheduleTaskByDate:stc.currentDate exclusiveList:nil];
            [[EZTaskStore getInstance] storeObjects:schTasks];
            [EZAlarmUtility setupAlarmBulk:schTasks];
        }
        
        [stc.tableView setFrame:CGRectMake(0, 0, 320, 367)];
        EZDEBUG(@"Content offset:%@, contentSize:%@", NSStringFromCGPoint( stc.tableView.contentOffset), NSStringFromCGSize(stc.tableView.contentSize));
        res = [[EZViewWrapper alloc] initWithView:stc.view identifier:identifier];
        res.controller = stc;
        stc.superController = self;
        //stc.navigationItem = self.navigationItem;
        
    }
    EZScheduledTaskController* taskController = (EZScheduledTaskController*)res.controller;
    
    //taskController.currentDate = [self pageToDate:page];
    [taskController reloadScheduledTask:[NSDate date]];
    return res;
    
}
**/

- (EZViewWrapper*) container:(EZSlideViewContainer*)container viewForPage:(NSInteger)page;
{
    EZDEBUG(@"viewForPage get called:%i", page);
    
    
    NSString* testID  = @"Tester";
    EZViewWrapper* res = [self dequeueWithIdentifier:testID]; 
    NSInteger labelTag = 10;
    
    if(res == nil){
        EZDEBUG(@"Create view for page:%i",page);
        EZTestTableViewCtrl* layoutTester = [[EZTestTableViewCtrl alloc] initWithStyle:UITableViewStylePlain isFamily:YES];
        layoutTester.selfNavCtrl = self.navigationController;
        [layoutTester.view setFrame:CGRectMake(0, 0, 320, 367)];
        UIView* vw = layoutTester.view;
        vw.backgroundColor = [UIColor colorWithRed:0.1*page green:0.1*page blue:0.1*page alpha:1];
        //[vw addSubview:label];

        res = [[EZViewWrapper alloc] initWithView:vw identifier:testID];
        res.controller = layoutTester;
    }
       
    UILabel* label = (UILabel*)[res.view viewWithTag:labelTag];
    label.text = [NSString stringWithFormat:@"Page:%i", page];
    return res;
}

//Why not tell view?
- (void) container:(EZSlideViewContainer*)container pageDisplayed:(NSInteger)page
{
    EZDEBUG(@"Page displayed:%i", page);
   /**
    UIView* pageView = [currentViews objectForKey:[[NSNumber alloc] initWithInt:page]];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    label.textAlignment = UITextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"Displayed Page:%i", page];
    label.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [pageView addSubview:label];
    **/
}
- (NSInteger) firstDisplayPage:(EZSlideViewContainer*)container
{
    return 8;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
