//
//  EZAvailableDayDetail.h
//  SqueezitProto
//
//  Created by Apple on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"
#import "EZPickerWrapper.h"

@class EZAvailableDay;

@interface EZAvailableDayDetail : UITableViewController<UITextFieldDelegate, EZPickerWrapperDelegate>

@property(strong, nonatomic) EZAvailableDay* avDay;

//Will be called when return to upper level
@property(strong, nonatomic) EZOperationBlock updateBlock;

- (IBAction) addButtonClicked:(id)sender;

@end
