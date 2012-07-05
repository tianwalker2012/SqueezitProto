//
//  EZViewLayoutTester.m
//  SqueezitProto
//
//  Created by Apple on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZViewLayoutTester.h"
#import "Constants.h"

@interface EZViewLayoutTester ()

@end

@implementation EZViewLayoutTester
@synthesize name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    EZDEBUG(@"%@'s frame:%@, callstack:%@", name, NSStringFromCGRect(self.view.frame), [NSThread callStackSymbols]);
}

- (void) viewWillDisappear:(BOOL)animated
{
    EZDEBUG(@"%@ will disappear. callstack:%@",name, [NSThread callStackSymbols]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"TouchBegan");
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //EZDEBUG(@"Touch")
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"TouchedEnded");
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"touchesCancelled");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    EZDEBUG(@"%@'s frame:%@, stackTrace is %@",name, NSStringFromCGRect(self.view.frame), [NSThread callStackSymbols]);
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

- (id) initWithName:(NSString*)nm;
{
    self = [super init];
    EZDEBUG(@"%@,After init, view is:%@, frame is:%@",nm,self.view, NSStringFromCGRect(self.view.frame));
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
    name = nm;
    return self;
}
@end
