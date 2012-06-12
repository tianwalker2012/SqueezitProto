//
//  EZEnvFlagPickerCell.m
//  SqueezitProto
//
//  Created by Apple on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZEnvFlagPickerCell.h"

@implementation EZEnvFlagPickerCell
@synthesize name, infoButton, infoClickOperation;

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

//I love the power of closure. 
- (IBAction) infoClicked:(id)sender
{
    EZDEBUG(@"Info button get clicked");
    if(infoClickOperation){
        infoClickOperation();
    }
}

@end
