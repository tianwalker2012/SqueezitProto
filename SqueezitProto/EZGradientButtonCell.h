//
//  EZGradientButtonCell.h
//  SqueezitProto
//
//  Created by Apple on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"


@class GradientControl;
@interface EZGradientButtonCell : UITableViewCell

@property (strong, nonatomic) EZOperationBlock clickedOps;
@property (strong, nonatomic) IBOutlet GradientControl* gradientCtrl;
@property (strong, nonatomic) IBOutlet UILabel* buttonTitle;


- (IBAction) clicked:(id)sender;


@end
