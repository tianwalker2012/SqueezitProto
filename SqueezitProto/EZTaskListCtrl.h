//
//  EZTaskListCtrl.h
//  SqueezitProto
//
//  Created by Apple on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZEditCell;

typedef void(^AlertOperation)();

@interface EZTaskListCtrl : UITableViewController<UITextFieldDelegate> {
    NSMutableArray* taskGroups;
    UIAlertView* alertView;
}

- (void) editClicked:(id)sender;

//Will do some check before disable 
- (void) setCellTextField:(UITableViewCell*)cell enabled:(BOOL)enabled;

@property (strong, nonatomic) UIBarButtonItem* editButton;
@property (strong, nonatomic) UIBarButtonItem* doneButton;
@property (weak, nonatomic) UITableViewCell* addCell;
@property (strong, nonatomic) AlertOperation operation;

@property (strong, nonatomic) IBOutlet EZEditCell* addCellView;
@property (strong, nonatomic) IBOutlet UITextField* inputGroupName;


@end
