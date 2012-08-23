//
//  EZAllTaskStatsCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAllTaskStatsCtrl.h"
#import "Constants.h"
#import "EZBarChartItem.h"
#import "EZTaskStore.h"
#import "EZScheduleStats.h"



@interface EZAllTaskStatsCtrl ()
{
    EZBarChartItem* barChart;
    NSMutableArray* taskStats;
    UIScrollView* scrollView;
    UIView* graphView;
}

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Why need to set it hidden?
    //What's the purpose?
    if([UIDevice currentDevice].orientation != UIInterfaceOrientationLandscapeLeft){ 
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
        EZDEBUG(@"Will orient to the LandscapeLeft");
    }

}

//I assume this will be called, when I already rotated.
//Did this will be called for each orientation is faced.
//Let's test it.
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    EZDEBUG(@"What's the current frame:%@", NSStringFromCGRect(self.view.frame));
    [self.view addSubview:scrollView];
    [barChart renderInView:graphView withTheme:[CPTTheme themeNamed:kCPTSlateTheme]];
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
    //UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //label.font = [UIFont fontWithName:<#(NSString *)#> size:<#(CGFloat)#>
    //label.textAlignment = UITextAlignmentCenter;
    //label.text = @"I get reoriented";
    //[self.view addSubview:label];
	// Do any additional setup after loading the view.
    barChart = [[EZBarChartItem alloc] init];
    barChart.dataSource = self;
    barChart.mySource = self;
    NSDate* now = [NSDate date];
    taskStats = [NSMutableArray arrayWithArray:[[EZTaskStore getInstance] statsTaskFrom:[now adjustDays:-7].beginning to:now]];
    //Make assumption, I will use fixed frame. 
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 480, 300)];
    CGFloat graphWidth = 480;
    NSInteger remain = taskStats.count - 8;
    if(remain > 0){
        graphWidth += remain * 60; 
    }
    graphView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, graphWidth, 300)];
    [scrollView addSubview:graphView];
    scrollView.contentSize = CGSizeMake(graphWidth, 300);
    EZDEBUG(@"total states:%i",taskStats.count);
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    EZDEBUG(@"Should autorotate get called:%i", interfaceOrientation);
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        //[barChart renderInView:self.view withTheme:[CPTTheme themeNamed:kCPTSlateTheme]];
        return YES;
    }
    return NO;
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return taskStats.count;
}

-(NSArray *)numbersForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange
{
	NSArray *nums = nil;
	switch ( fieldEnum ) {
		case CPTBarPlotFieldBarLocation:
			nums = [NSMutableArray arrayWithCapacity:indexRange.length];
			for ( NSUInteger i = indexRange.location; i < NSMaxRange(indexRange); i++ ) {
				[(NSMutableArray *) nums addObject:[NSDecimalNumber numberWithUnsignedInteger:i]];
			}
			break;
            
		case CPTBarPlotFieldBarTip:{
			NSArray* stats = [taskStats objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:indexRange]];
            NSMutableArray* tmpArr = [[NSMutableArray alloc] initWithCapacity:stats.count];
            [stats iterate:^(EZScheduleStats* stat){
                NSInteger hours = stat.totalTime/60;
                if(hours == 0){
                    hours = 1;
                }
                [tmpArr addObject:[[NSNumber alloc] initWithInt:hours]];
            }];
            nums = tmpArr;
            }
			break;
            
		default:
			break;
	}
    
	return nums;
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx
{
	CPTColor *color = nil;
    NSInteger index = idx % 11;
    
	switch ( index ) {
		case 0:
			color = [CPTColor redColor];
			break;
            
		case 1:
			color = [CPTColor greenColor];
			break;
            
		case 2:
			color = [CPTColor blueColor];
			break;
            
		case 3:
			color = [CPTColor yellowColor];
			break;
            
		case 4:
			color = [CPTColor purpleColor];
			break;
            
		case 5:
			color = [CPTColor cyanColor];
			break;
            
		case 6:
			color = [CPTColor orangeColor];
			break;
            
		case 7:
			color = [CPTColor magentaColor];
			break;
            
        case 8:
            color = [CPTColor grayColor];
            break;
        
        case 9:
            color = [CPTColor lightGrayColor];
            break;
            
        case 10:
            color = [CPTColor whiteColor];
            break;
            
		default:
			break;
	}
    
	CPTGradient *fillGradient = [CPTGradient gradientWithBeginningColor:color endingColor:[CPTColor blackColor]];
    
	return [CPTFill fillWithGradient:fillGradient];
}

-(NSString *)legendTitleForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    EZScheduleStats* stat = [taskStats objectAtIndex:index];
    return stat.name;
}

//Assume the task have sorted according to it's total time
//The first one will be the largest.
- (CGFloat) getMaximumValue
{
    EZScheduleStats* stat = [taskStats objectAtIndex:0];
    return stat.totalTime/60;
}

- (CGFloat) getMinimumValue
{
    EZScheduleStats* stat = [taskStats objectAtIndex:taskStats.count - 1];
    return stat.totalTime/60;

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
