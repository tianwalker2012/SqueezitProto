//
//  EZAvTimeCell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvTimeCell.h"
#import "EZTaskHelper.h"

@interface EZAvTimeCell()
{
    CGFloat startTimeOrgLeft;
    CGFloat endTimeOrgLeft;
}

@end

@implementation EZAvTimeCell
@synthesize name, envLabel, startTime, endTime;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    startTimeOrgLeft = startTime.left;
    endTimeOrgLeft = endTime.left;
    //EZDEBUG(@"startTimeOrgLeft:%f", startTimeOrgLeft);
}

- (void) hideTime
{
    //EZDEBUG(@"hideTime");
    startTime.alpha = 0;
    endTime.alpha = 0;
}

- (void) showTime
{
    //EZDEBUG(@"showTime");
    startTime.alpha = 1;
    endTime.alpha = 1;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    //EZDEBUG(@"Will transitionState called, mask value:%i",state);
    if(state & UITableViewCellStateShowingDeleteConfirmationMask){
        [self hideTime];
    }else{
        [self showTime];
    }
}

- (void) setEditing:(BOOL)et animated:(BOOL)animated
{
    [super setEditing:et animated:animated];
    
    EZOperationBlock block = ^(){
        if(et){
            startTime.left = startTimeOrgLeft - 10;
            endTime.left = endTimeOrgLeft - 10;
        }else{
            startTime.left = startTimeOrgLeft + 10;
            endTime.left = endTimeOrgLeft + 10;
        }
    };
    if(animated){
        [UIView beginAnimations:@"Hide times" context:nil];
        [UIView animateWithDuration:0.2 animations:block];
        [UIView commitAnimations];
    }else{
        block();
    }
}

@end
