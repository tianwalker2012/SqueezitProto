//
//  EZSlideViewTester.m
//  SqueezitProto
//
//  Created by Apple on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZSlideViewTester.h"
#import "Constants.h"

@interface EZSlideViewTester ()
{
    NSMutableDictionary* currentViews; 
    EZSlideViewContainer* container;
}
@end

@implementation EZSlideViewTester

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
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
    currentViews = [[NSMutableDictionary alloc] init];
    EZDEBUG(@"View did load get called, Frame is %@", NSStringFromCGRect(self.view.frame));
    //Seems I found the place.
    container = [[EZSlideViewContainer alloc] init];
    container.containerDelegate = self;
    EZDEBUG(@"Container frame:%@", NSStringFromCGRect(container.view.frame));
    [self addChildViewController:container];
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:container.view];
	// Do any additional setup after loading the view.
    
    
    return self;
}

- (NSInteger) pageCount:(EZSlideViewContainer*)container
{
    EZDEBUG(@"Page count get called");
    return 10;
}
- (UIView*) container:(EZSlideViewContainer*)container viewForPage:(NSInteger)page;
{
    EZDEBUG(@"viewForPage get called:%i", page);
    UIView* res = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    res.backgroundColor = [UIColor colorWithRed:0.1*page green:0.1*page blue:0.1*page alpha:1];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    label.textAlignment = UITextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"Page:%i", page];
    label.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [res addSubview:label];
    [currentViews setObject:res forKey:[[NSNumber alloc] initWithInt:page]];
    return res;
}
//Why not tell view?
- (void) container:(EZSlideViewContainer*)container pageDisplayed:(NSInteger)page
{
    EZDEBUG(@"Page displayed:%i", page);
    UIView* pageView = [currentViews objectForKey:[[NSNumber alloc] initWithInt:page]];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    label.textAlignment = UITextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"Displayed Page:%i", page];
    label.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [pageView addSubview:label];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    container.currentPage = 2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
