//
//  EZEnvFlagPickerCell.h
//  SqueezitProto
//
//  Created by Apple on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

@interface EZEnvFlagPickerCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* name;
@property (strong, nonatomic) IBOutlet UIButton* infoButton;
@property (strong, nonatomic) EZOperationBlock infoClickOperation;


- (IBAction) infoClicked:(id)sender;

@end
