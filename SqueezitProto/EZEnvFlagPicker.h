//
//  EZEnvFlagPicker.h
//  SqueezitProto
//
//  Created by Apple on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

@interface EZEnvFlagPicker : UITableViewController

@property (assign, nonatomic) NSUInteger settedFlags;
@property (strong, nonatomic) EZOperationBlock doneBlock;
@property (strong, nonatomic) NSArray* availableFlags;
@property (strong, nonatomic) NSMutableDictionary* flagSelectionStatus;

@end
