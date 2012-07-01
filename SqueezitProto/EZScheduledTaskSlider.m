//
//  EZScheduledTaskSlider.m
//  SqueezitProto
//
//  Created by Apple on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledTaskSlider.h"
#import "EZTaskStore.h"
#import "EZScheduledDay.h"
#import "MScheduledDay.h"
#import "EZViewWrapper.h"
#import "EZScheduledTaskController.h"
#import "EZGlobalLocalize.h"
#import "EZScheduledTask.h"
#import "EZTaskScheduler.h"

@interface EZScheduledTaskSlider ()
{
    //Initially will read from the date base, about all the history date.
    //No need to including future date. 
    //If today is not included, will add today into it
    NSMutableArray* scheduledDates;
    NSMutableArray* cachedControllers;
    NSInteger todayPage;
    BOOL initialized;
}

//Get the related date for this page
- (NSDate*) pageToDate:(NSInteger)page; 

//Will find the current taskController and call it's method
- (void) rescheduleTasks;

- (void) scroll2Today;

- (NSInteger) dateToPage:(NSDate*)date;

//The title and button status will be change according to different pages
- (void) changeSettingForPage:(NSInteger)page;


@end

@implementation EZScheduledTaskSlider
@synthesize viewAppearBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString*) titleForPage:(NSInteger)page
{
    if(page != todayPage){
        return [[self pageToDate:page] stringWithFormat:@"yyyyMMdd"];
    }else{
        return [NSString stringWithFormat:Local(@"%@(Today)"),
                [[self pageToDate:page] stringWithFormat:@"yyyyMMdd"]];
    }
}

- (void) scrollToPage:(NSInteger)page animated:(BOOL)animated
{
    [super scrollToPage:page animated:animated];
    [self changeSettingForPage:page];
}

- (void) scroll2Today
{
    self.currentPage = todayPage;
    self.navigationItem.leftBarButtonItem.enabled = false;
    self.navigationItem.rightBarButtonItem.enabled = true;
    self.navigationItem.title = [self titleForPage:todayPage];
}

//Everytime the the view loaded again?
//Will screen from dark to get this method be called?
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    EZDEBUG(@"ViewWillAppear get called");
    if(viewAppearBlock){
        viewAppearBlock();
    }
    self.viewAppearBlock = nil;
}

//You can actully treat this as init method.
//Because controller normally loaded by NIB, so you have no opportunity to do things in init. This method is call within the init code, so yo just treat it as init for UIViewController.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.containerDelegate = self;
    NSDate* today = [[NSDate date] beginning];
	scheduledDates = [NSMutableArray arrayWithArray:[[EZTaskStore getInstance] fetchWithPredication:[NSPredicate predicateWithFormat:@"scheduledDate < %@",today] VO:[EZScheduledDay class] PO:[MScheduledDay class] sortField:@"scheduledDate"]];
    EZDEBUG(@"history date number:%i",scheduledDates.count);
    cachedControllers = [[NSMutableArray alloc] init];
    EZScheduledDay* todaySchedule = [[EZScheduledDay alloc] init];
    todaySchedule.scheduledDate = today;
    [scheduledDates addObject:todaySchedule];
    todayPage = scheduledDates.count - 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rescheduleTasks)];
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
    self.navigationItem.title = [self titleForPage:todayPage];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Local(@"Today") style:UIBarButtonItemStyleBordered target:self action:@selector(scroll2Today)];
    self.navigationItem.leftBarButtonItem.enabled = false;
    
    //currentPage = scheduledDates.count - 1;
    
}

- (NSInteger) dateToPage:(NSDate *)date
{
    for(int i = 0; i < scheduledDates.count; i++){
        EZScheduledDay* day = [scheduledDates objectAtIndex:i];
        if([day.scheduledDate equalWith:date format:@"yyyyMMdd"]){
            return i;
        }
    }
    return -1;
}

- (EZScheduledDay*) createDayNotExist:(NSDate*)date
{
    NSDate* begin = date.beginning;
    NSDate* end = [begin adjust:SecondsPerDay - 1];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"scheduleDate >= %@ AND scheduledDate <= %@",begin, end];
    NSArray* scheduledDayArr = [[EZTaskStore getInstance] fetchWithPredication:predicate VO:[EZScheduledDay class] PO:[MScheduledDay class] sortField:nil];
    if(scheduledDayArr.count == 0){
        EZScheduledDay* sd = [[EZScheduledDay alloc] init];
        sd.scheduledDate = date;
        [[EZTaskStore getInstance] storeObject:sd];
        return sd;
    }else{
        assert(scheduledDayArr.count == 1);
        return [scheduledDayArr objectAtIndex:0];
    }
}

//What I will do in this method?
//Add tomorrow into the scheduledDay.
//Call scheduleForDate.
//Move the page to be current.
//Time to sleep
- (void) scheduleForTomorrow
{
    EZDEBUG(@"Tomorrow get called");
    NSDate* tomorrow = [[NSDate date] adjustDays:1];
    NSInteger page = [self dateToPage:tomorrow];
    if(page < 0){
        //My page will not jump ahead. So far I provide no mean to do so.
        //Tomorrow not read out doesn't mean it is not exist right?
        //Fix it now
        EZScheduledDay* day = [self createDayNotExist:tomorrow];
        [scheduledDates addObject:day];
        page = scheduledDates.count - 1;
    }
    
    NSArray* schTasks = [[EZTaskStore getInstance] getScheduledTaskByDate:tomorrow];
    if(schTasks.count == 0){
       schTasks = [[[EZTaskScheduler alloc] init] scheduleTaskByDate:tomorrow.beginning exclusiveList:nil];
        [[EZTaskStore getInstance] storeObjects:schTasks];
    }
    self.currentPage = page;
    EZViewWrapper* wrapper = [self getViewWrapperByPage:page];
    EZScheduledTaskController* stc = (EZScheduledTaskController*)wrapper.controller;
    [stc loadWithTask:schTasks date:tomorrow];
}
//I made an assumption, that is all notification task's date will be find 
//in my list. This is valid assumption right.
- (void) presentScheduledTask:(EZScheduledTask*)task
{
    NSInteger page = [self dateToPage:task.startTime];
    EZDEBUG(@"date %@ correspond to page:%i",[task.startTime stringWithFormat:@"yyyyMMdd"], page);
    if(page == -1){
        return;
    }
    self.currentPage = page;
    EZViewWrapper* wrapper = [self getViewWrapperByPage:page];
    EZScheduledTaskController* stc = (EZScheduledTaskController*)wrapper.controller;
    [stc presentScheduledTask:task];
}

//Use the current page to fetch Controller.
- (void) rescheduleTasks
{
    EZViewWrapper* wrapper = [self getViewWrapperByPage:self.currentPage];
    EZScheduledTaskController* stc = (EZScheduledTaskController*)wrapper.controller;
    [stc rescheduleTasks];
    
}

- (NSInteger) firstDisplayPage:(EZSlideViewContainer *)container
{
    EZDEBUG(@"firstDisplayPage get called:%i", todayPage);
    return todayPage;
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

- (NSInteger) pageCount:(EZSlideViewContainer*)container
{
    EZDEBUG(@"Page count get called");
    return scheduledDates.count;
}


- (EZViewWrapper*) container:(EZSlideViewContainer*)container viewForPage:(NSInteger)page
{
    EZDEBUG(@"viewForPage %i",page);
    NSString* identifier = @"TaskController";
    EZViewWrapper* res = [self dequeueWithIdentifier:identifier];
    if(res == nil){
        EZScheduledTaskController* stc = [[EZScheduledTaskController alloc] initWithStyle:UITableViewStylePlain];
        [stc.view setFrame:CGRectMake(0, 0, 320, 367)];
        [self addChildViewController:stc];
        res = [[EZViewWrapper alloc] initWithView:stc.view identifier:identifier];
        res.controller = stc;
        stc.superController = self;
        //stc.navigationItem = self.navigationItem;
        
    }
    EZScheduledTaskController* taskController = (EZScheduledTaskController*)res.controller;

    //taskController.currentDate = [self pageToDate:page];
    [taskController reloadScheduledTask:[self pageToDate:page]];
    return res;
    
}



//Why not tell view?
//What I need to do here?
//I may need to change the Button status in the navigation bar.
//I assume the willDisplay will get called automatically.
//Otherwise I will have to call the display by myself.
- (void) container:(EZSlideViewContainer*)container pageDisplayed:(NSInteger)page
{
    [self changeSettingForPage:page];
}

- (void) changeSettingForPage:(NSInteger)page
{
    EZDEBUG(@"Page displayed:%i, date is:%@",page,[[self pageToDate:page] stringWithFormat:@"yyyyMMdd"]);
    self.navigationItem.title = [self titleForPage:page];   
    if(page == todayPage){
        self.navigationItem.leftBarButtonItem.enabled = false;
    }else{
        self.navigationItem.leftBarButtonItem.enabled = true;
    }
    if(page < todayPage){
        //Not allow user to reschedule what already passed
        self.navigationItem.rightBarButtonItem.enabled = false;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = true;
    }
}
//The purpose of this function call it that
//If the container reach the end of the page, it will call this method
//ask if it have more?
//If it is, return the next PageCount.
//If not, just return the old PageCount.
//If your page will keep increasing, then, you just keep increasing the pageCount 
- (NSInteger) nextPage:(NSInteger)page
{
    //I assume the page count will only increased 1 at a time.
    //If any case violate this assumption, I need to come back and get it fixed.
    //NSDate* curDate = [self pageToDate:page];
    NSInteger nextP = page+1;
    //assert(nextP == scheduledDates.count);
    EZDEBUG(@"page:%i, count:%i",page,scheduledDates.count);
    NSDate* lastDate =  ((EZScheduledDay*)[scheduledDates objectAtIndex:page-1]).scheduledDate;
    
    EZScheduledDay* schDay = [[EZScheduledDay alloc] init];
    schDay.scheduledDate = [lastDate adjustDays:1];
    [scheduledDates addObject:schDay];
    return nextP;
}

- (NSDate*) pageToDate:(NSInteger)page
{
    return  ((EZScheduledDay*)[scheduledDates objectAtIndex:page]).scheduledDate;
}

@end