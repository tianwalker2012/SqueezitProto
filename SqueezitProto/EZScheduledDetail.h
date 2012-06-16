//
//  EZScheduledDetail.h
//  SqueezitProto
//
//  Created by Apple on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

@class EZScheduledTask;

@interface EZScheduledDetail : UITableViewController

@property (strong, nonatomic) EZScheduledTask* schTask;
@property (strong, nonatomic) EZOperationBlock deleteBlock;
@property (strong, nonatomic) EZOperationBlock rescheduleBlock;

@end
