//
//  EZPickerWrapper.h
//  SqueezitProto
//
//  Created by Apple on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//What's the purpose of this class
//I found that we need Page to collect user's choice from a picker.
//I have implmented those thing twice, 
//It is an experiement to see how can I encapsulate a view to do this.
//KeyBoard will be raise from bottom by it's height. 
//KeyBoard will be down fall to the bottom when the controller disappear.

//What is the particular cell get selected? how to update the value in the picker?
//The caller passing a delegate
//Since the keyBoard to them is just a UIView.
//The responsibility to capture the value change is on the caller.
//What caller need to do, when the change is done. 
//Need way to update value in animated way.
//How about the caller keep the cell he instantiated?
//So he can just upate the cell whenever he liked.
//Wrapper could raise corresponding keyboard accordingly.
//That will be the second iteration
@class EZPickerWrapper;

@protocol EZPickerWrapperDelegate <NSObject>

//How many rows in this picker controller;
- (int) getRow:(EZPickerWrapper*)pickerWrapper;

- (int) getSection:(EZPickerWrapper*)pickerWrapper;

- (NSIndexPath*) getDefaultSelected:(EZPickerWrapper*)pickerWrapper;

//Will be called, when user selected a cell. 
//In this method, delegate need to setup the picker to the value of the 
//Current cell. 
//The keyboard raise will be handled by EZPickerWrapper
- (void) pickerWrapper:(EZPickerWrapper*)pickerWrapper cellSelected:(UITableViewCell*)cell indexPath:(NSIndexPath*)path keyboard:(UIView*)keyboard;

- (UITableViewCell*) pickerWrapper:(EZPickerWrapper*)pickerWrapper getCell:(NSIndexPath*)path;

//Will be used later when when have differnt keyboard for different indexPath
- (UIView*) pickerWrapper:(EZPickerWrapper*)pickerWrapper getKeyBoard:(NSIndexPath*)path;


//When the user changed the value in the picker, this delegate method will
//Get called
//The reason I comment it out is because it will hurt the generality.
//- (void) pickerValueChanged:(EZPickerWrapper *)pickerWrapper; 

- (void) doneClicked:(EZPickerWrapper*)pickerWrapper;

- (void) cancelClicked:(EZPickerWrapper*)pickerWrapper;

@end


@interface EZPickerWrapper : UITableViewController

//@property (strong, nonatomic) UIView* keyboard;
@property (strong, nonatomic) id<EZPickerWrapperDelegate> wrapperDelegate;

//Return the index of the current selected cell
- (NSIndexPath*) getSelectedRow;

- (UITableViewCell*) getCellByIndexPath:(NSIndexPath*)indexPath;

//It is for sync up the status.
//Use to address following scenerio.
//When this Wrapper used again, it cell will not reloaded, 
//It just keep the old status.
//For example, the first time I get this view displayed, 
//How about make it called internally during willDisplay period?
//- (void) reloadData;

@end


