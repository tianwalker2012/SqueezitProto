//
//  EZRootViewController.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZScheduledTaskController;

@interface EZRootViewController : UIViewController <UIPageViewControllerDelegate> {
    EZScheduledTaskController* scheduleController;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
