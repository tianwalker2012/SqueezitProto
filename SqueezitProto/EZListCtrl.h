//
//  EZTaskListCtrl.h
//  SqueezitProto
//
//  Created by Apple on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"


//Take time to write down it's functionality
//Then start to change the code to match the described functionality
//All the task list will be showing on this page. 
//Once the edit was clicked, The editableCell become editable.
//You can click the last editable button you can input things.
//Each edit table will change color to editable color.
//This behavior will be consistent in this applciation.

@interface EZListCtrl : UITableViewController<UITextFieldDelegate> {
    NSMutableArray* values;
    UIAlertView* alertView;
}

- (void) editClicked:(id)sender;


- (id)initWithStyle:(UITableViewStyle)style isTasklist:(BOOL)tasklist;


@property (strong, nonatomic) UIBarButtonItem* editButton;
@property (strong, nonatomic) UIBarButtonItem* doneButton;

@property (strong, nonatomic) EZOperationBlock operation;

//Whether we serve tasklist or TimeSetting?
@property (assign, nonatomic) BOOL isServeTaskList;



@end
