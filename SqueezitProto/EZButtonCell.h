//
//  EZButtonCell.h
//  SqueezitProto
//
//  Created by Apple on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

@interface EZButtonCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton* button;
@property (strong, nonatomic) EZEventOpsBlock clickedOps;

- (IBAction) buttonClicked:(id)sender;

@end
