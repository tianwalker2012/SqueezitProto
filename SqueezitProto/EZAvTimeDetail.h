//
//  EZAvTimeDetail.h
//  SqueezitProto
//
//  Created by Apple on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTableSelector.h"
#import "EZPickerWrapper.h"
#import "EZTaskHelper.h"

@class EZAvailableTime;

@interface EZAvTimeDetail : UITableViewController<EZPickerWrapperDelegate, EZTableSelectorDelegate, UITextFieldDelegate>

@property (strong, nonatomic) EZAvailableTime* avTime;
@property (strong, nonatomic) EZOperationBlock doneBlock;
@property (strong, nonatomic) EZOperationBlock cancelBlock;

@end
