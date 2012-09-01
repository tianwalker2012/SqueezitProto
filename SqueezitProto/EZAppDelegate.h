//
//  EZAppDelegate.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZScheduledTaskSlider;

@interface EZAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController* rootCtrl;

@property (strong, nonatomic) EZScheduledTaskSlider* taskSlider;

//All component could check this see if user start the application for the first time. 
//One thing is that, if user never close our application, should we treat this as first time also?
//Interesting question. 
//This policy should be determined by us,
//Honestly gloabl status is meaningless, each component should keep their own status. 
//@property (assign, nonatomic) BOOL firstTimeUser;

@end
