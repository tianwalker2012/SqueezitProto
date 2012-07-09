//
//  EZBeginEndTimeCell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZBeginEndTimeCell.h"
#import "EZTaskHelper.h"

@interface EZBeginEndTimeCell()
{
    CGFloat orgRight;
}

@end

@implementation EZBeginEndTimeCell
@synthesize beginTime, endTime, endTitle, beginTitle;


- (void) awakeFromNib
{
    orgRight = beginTime.right;
}

//Made a assumption, that is the width set in the cell are for having accessory.
- (void) setHaveAccessor:(BOOL)haveAccessor
{
    EZDEBUG(@"Orginal right:%f", orgRight);
    if(haveAccessor){
        beginTime.right = orgRight;
        endTime.right = orgRight;
    }else{
        beginTime.right = orgRight - 20;
        endTime.right = orgRight - 20;
    }
}

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

@end
