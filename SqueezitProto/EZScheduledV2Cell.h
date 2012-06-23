//
//  EZScheduledV2Cell.h
//  SqueezitProto
//
//  Created by Apple on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZScheduledV2Cell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* taskName;
@property (strong, nonatomic) IBOutlet UILabel* startTime;
@property (strong, nonatomic) IBOutlet UILabel* endTime;
@property (strong, nonatomic) IBOutlet UILabel* alarmTitle;
@property (strong, nonatomic) IBOutlet UILabel* alarmStatus;

@end
