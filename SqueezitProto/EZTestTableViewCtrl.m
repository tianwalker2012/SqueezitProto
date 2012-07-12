//
//  EZTestTableViewCtrl.m
//  SqueezitProto
//
//  Created by Apple on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTestTableViewCtrl.h"
#import "Constants.h"
#import "EZPrematureCell.h"
#import "EZEditLabelCellHolder.h"
#import "EZCanvas.h"
#import "EZTaskHelper.h"

@interface EZTestTableViewCtrl ()
{
    NSArray* names;
}

@end

@implementation EZTestTableViewCtrl
@synthesize isFamily, familyName, selfNavCtrl;

- (id)initWithStyle:(UITableViewStyle)style isFamily:(BOOL)family
{
    isFamily = family;
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(isFamily){
        names = [UIFont familyNames];
    }else{
        names = [UIFont fontNamesForFamilyName:familyName];
    }
    
    EZCanvas* ec = [[EZCanvas alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
    [self performBlock:^(){
        [self.view addSubview:ec];
    } withDelay:0.1];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    EZDEBUG(@"viewWillDisappear");
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    EZDEBUG(@"ViewWillAppear");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return names.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZDEBUG(@"load index:%@", indexPath);
    static NSString *CellIdentifier = @"Premature";
    EZPrematureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [EZEditLabelCellHolder createPrematureCell];
    }else{
        EZDEBUG(@"Recycled content:%@, for:%@",cell.upTitle.text,[names objectAtIndex:indexPath.row]);  
    }
    //UIFont* font = [[UIFont alloc] init];
    //cell.textLabel.font = 
    //cell.textLabel.text = [NSString stringWithFormat:@"Row:%i", indexPath.row];
    if(isFamily){
        cell.upTitle.text = [NSString stringWithFormat:@"%@", [names objectAtIndex:indexPath.row]];
        cell.downTitle.text = [NSString stringWithFormat:@"%@", [names objectAtIndex:indexPath.row]];
    }else{
        NSString* fontName = [NSString stringWithFormat:@"12:34:56%@", [names objectAtIndex:indexPath.row]];
        
        cell.downTitle.text = [NSString stringWithFormat:@"%@:开心", familyName];
        cell.downTitle.font = [UIFont fontWithName:[names objectAtIndex:indexPath.row] size:17];
        
        cell.upTitle.text = fontName;
        cell.upTitle.font = [UIFont fontWithName:[names objectAtIndex:indexPath.row] size:17];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    EZDEBUG(@"selected:%i",indexPath.row);
    if(isFamily){
        EZDEBUG(@"About to show new view");
        EZTestTableViewCtrl* ctrl = [[EZTestTableViewCtrl alloc]initWithStyle:UITableViewStylePlain isFamily:false];
        ctrl.familyName = [names objectAtIndex:indexPath.row];
        [selfNavCtrl pushViewController:ctrl animated:YES];
    }
}

@end
