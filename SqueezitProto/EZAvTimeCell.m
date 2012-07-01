//
//  EZAvTimeCell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvTimeCell.h"
#import "EZTaskHelper.h"

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

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    EZOperationBlock block = ^(){
        if(editing){
            startTime.alpha = 0;
            endTime.alpha = 0;
        }else{
            startTime.alpha = 1;
            endTime.alpha = 1;
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
