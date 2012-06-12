//
//  EZAvTimeForEnvTrait.h
//  SqueezitProto
//
//  Created by Apple on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

@interface EZAvTimeForEnvTrait : UITableViewController

@property (assign, nonatomic) NSUInteger envFlag;
@property (strong, nonatomic) NSArray* avTimes;
@property (strong, nonatomic) EZOperationBlock backBlock;

@end
