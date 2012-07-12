//
//  EZAllTaskStatsCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAllTaskStatsCtrl.h"
#import "Constants.h"

@interface EZAllTaskStatsCtrl ()

@end

@implementation EZAllTaskStatsCtrl

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
    //Why need to set it hidden?
    //What's the purpose?
    if([UIDevice currentDevice].orientation != UIInterfaceOrientationLandscapeLeft){ 
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
        EZDEBUG(@"Will orient to the LandscapeLeft");
    }
    
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    EZDEBUG(@"Will recover the orientation");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //label.font = [UIFont fontWithName:<#(NSString *)#> size:<#(CGFloat)#>
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"I get reoriented";
    [self.view addSubview:label];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    EZDEBUG(@"Should autorotate get called:%i", interfaceOrientation);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"touchesBegin get called");
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"touchesMoved");
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch end get called");
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    
}

@end
