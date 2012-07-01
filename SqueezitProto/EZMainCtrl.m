//
//  EZMainCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZMainCtrl.h"
#import "Constants.h"
#import "EZScheduledTaskController.h"
#import "EZListCtrl.h"

@interface EZMainCtrl ()

@end

@implementation EZMainCtrl
@synthesize tabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.delegate = self;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/**

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    EZDEBUG(@"shouldSelectViewController");
    return true;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    EZDEBUG(@"didSelectViewController get called");
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers
{
    EZDEBUG(@"willBeginCustomizingViewControllers");
}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
    EZDEBUG(@"willEndCustomizingViewControllers, changed:%@", changed?@"TRUE":@"FALSE");
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
    EZDEBUG(@"didEndCustomizingViewControllers, changed:%@", changed?@"TRUE":@"FALSE");
}
**/


@end
