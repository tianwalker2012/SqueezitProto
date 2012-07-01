//
//  EZTestTableViewCtrl.h
//  SqueezitProto
//
//  Created by Apple on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZTestTableViewCtrl : UITableViewController

- (id)initWithStyle:(UITableViewStyle)style isFamily:(BOOL)family;

@property (assign, readonly) BOOL isFamily;

@property (strong, nonatomic) NSString* familyName;

@property (strong, nonatomic) UINavigationController* selfNavCtrl;

@end
