//
//  EZScheduledTaskDetailCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZScheduledTaskDetailCtrl.h"

#import "EZScheduledTask.h"
#import "EZTask.h"
#import "EZTaskHelper.h"

@interface EZScheduledTaskDetailCtrl ()

@end

@implementation EZScheduledTaskDetailCtrl
@synthesize deleteBtn, rescheduleBtn, startTime, endTime,duration, schTask, deleteOp, reschuduleOp, row, indexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction) deleteClicked:(id)sender
{
    EZDEBUG(@"delete get called: %@",sender);
    deleteOp(self.indexPath);
}

- (IBAction) rescheduleCalled:(id)sender
{
    EZDEBUG(@"reschedule get called:%@",sender);
    reschuduleOp(self.indexPath);
}

- (void) backTapped
{
    EZDEBUG(@"Back button get tapped");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = schTask.task.name;
    self.startTime.text = [schTask.startTime stringWithFormat:@"HH:mm"];
    self.endTime.text = [[schTask.startTime adjustMinutes:schTask.duration] stringWithFormat:@"HH:mm"];
    self.duration.text = [NSString stringWithFormat:@"%i minutes",schTask.duration];
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backTapped)];
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(backTapped);    
    //[button addTarget:<#(id)#> action:<#(SEL)#> forControlEvents:<#(UIControlEvents)#>]
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

@end
