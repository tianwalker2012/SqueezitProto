//
//  EZTestDotRoller.m
//  SqueezitProto
//
//  Created by Apple on 12-8-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTestDotRoller.h"
#import "EZDotRoller.h"
#import "Constants.h"
#import "EZTaskHelper.h"

@interface AccessTest : NSObject

@property (assign, nonatomic) NSInteger age;

- (void) setMyAge:(NSInteger)ag;

@end

@implementation AccessTest
@synthesize age;

- (void) setMyAge:(NSInteger)ag
{
    EZDEBUG(@"Before set the value");
    //age = ag;
}

- (void) dealloc
{
    EZDEBUG(@"Get dealloced");
}
@end


@interface EZTestDotRoller ()
{
    EZDotRoller* roller;
    AccessTest* access;
    
    //What's the purpose of this parameter?
    //It will hold the completeOps
    //Otherwise, the block's closure resource will be released by the system.
    completeOps completeHolder;
    NSInteger curPage;
}

- (void) rollRight;

- (void) changeThenRoll;

@end

@implementation EZTestDotRoller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Dots" image:[UIImage imageNamed:@"myDice"] tag:10];
    }
    return self;
}

/**
- (id) init
{
    self = [super init];
    if (self) {
        //self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:4];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Dots" image:[UIImage imageNamed:@"myDice"] tag:10];
    }
    return self;
}
**/

- (void)viewDidLoad
{
    [super viewDidLoad];
    curPage = 10;
    roller = [[EZDotRoller alloc] initWithFrame:(CGRectMake(20, 20, 200, 30))];
    //EZDotRoller* roller = [[EZDotRoller alloc] initWithFrame:(CGRectMake(20, 20, 200, 30))];
    roller.backgroundColor = [UIColor colorWithRed:0.88 green:0.44 blue:0.22 alpha:0.5];
    roller.dotsNumber = 10;
    roller.currentDotColor = [UIColor greenColor];
    roller.otherDotColor = [UIColor redColor];
    roller.currentDot = 3;
    roller.actualCurPage = curPage;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(rollRight)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(changeThenRoll)];
    [self.view addSubview:roller];
    access = [[AccessTest alloc] init];
    access.age = 20;

}
                                              
- (void) changeThenRoll
{
    --curPage;
    EZDEBUG(@"ChangeThenRoll get called, curPage %i", curPage);
    //[roller changeThenRollBack:TRUE];
    [roller adjustCurPage:curPage];
    
    
}

- (void) rollRight
{
    ++curPage;
    EZDEBUG(@"changeToRight, curPage:%i", curPage);
    //[roller changeThenRollBack:FALSE];
    [roller adjustCurPage:curPage];
}

- (void) rollRightOld
{
    EZDEBUG(@"What's the current dot:%i", roller.currentDot);
    EZDotRoller* troller = roller;
    completeHolder = ^(){
        //troller.currentDot = troller.currentDot - 1;
        troller.dotsNumber = troller.dotsNumber + 1;
        [troller performBlock:^(){
            troller.currentDot = troller.currentDot - 1;
            if(troller.currentDot < 0){
                troller.currentDot = 9;
            }
            troller.dotsNumber =  troller.dotsNumber - 1;
            [troller setNeedsDisplay];
        } withDelay:stepDelay];
    }; 
    [roller moveRightOneUnit:5 completeOps:completeHolder];

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

@end
