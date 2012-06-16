//
//  EZTimeSnippetList.h
//  SqueezitProto
//
//  Created by Apple on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZAvailableDayList : UITableViewController<UITextFieldDelegate, UIAlertViewDelegate>

@property(strong, nonatomic) NSMutableArray* avDays;

@end
