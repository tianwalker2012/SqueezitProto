//
//  EZScheduledCell.h
//  SqueezitProto
//
//  Created by Apple on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "EZTaskHelper.h"

@interface EZScheduledCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* title;
@property (strong, nonatomic) IBOutlet UILabel* timeSpanTitle;
@property (strong, nonatomic) IBOutlet UIButton* alarmButton;
@property (strong, nonatomic) EZOperationBlock clickBlock;

- (void) setButtonStatus:(NSNumber*)type;

- (IBAction)buttonClicked:(id)sender;

@end
