//
//  EZEditLabelCellHolder.h
//  SqueezitProto
//
//  Created by Apple on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZEditLabelCell, EZTaskGroupCell, EZPureEditCell, EZSettingCell, EZEnvFlagPickerCell, EZAvailableTimeCell;
//The purpose of this holder is serve as the file owner, 
//So that this cell could be used by many controllers.
@interface EZEditLabelCellHolder : NSObject

@property (strong, nonatomic) IBOutlet EZEditLabelCell* editCell;

@property (strong, nonatomic) IBOutlet EZTaskGroupCell* groupCell;

@property (strong, nonatomic) IBOutlet EZPureEditCell* pureEditCell;

@property (strong, nonatomic) IBOutlet EZSettingCell* settingCell;

@property (strong, nonatomic) IBOutlet EZEnvFlagPickerCell* flagCell;

@property (strong, nonatomic) IBOutlet EZAvailableTimeCell* timeCell;

//@property (strong, nonatomic) id<UITextFieldDelegate> delegate;

+ (EZEditLabelCell*) createCellWithDelegate:(id<UITextFieldDelegate>)deleg;
+ (EZTaskGroupCell*) createTaskGroupCellWithDelegate:(id<UITextFieldDelegate>)deleg;

+ (EZPureEditCell*) createPureEditCellWithDelegate:(id<UITextFieldDelegate>)deleg;

+ (EZSettingCell*) createSettingCell;

+ (EZEnvFlagPickerCell*) createFlagCell;

+ (EZAvailableTimeCell*) createTimeCell;

//Need to think about it later. 
//+ (UITableViewCell*) createCell:(NSString*)xibFile;

@end
