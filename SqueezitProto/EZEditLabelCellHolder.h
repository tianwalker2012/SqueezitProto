//
//  EZEditLabelCellHolder.h
//  SqueezitProto
//
//  Created by Apple on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class EZEditLabelCell, EZTaskGroupCell, EZPureEditCell, EZSettingCell, EZEnvFlagPickerCell, EZAvailableTimeCell, EZScheduledCell, EZAvTimeCell, EZAvTimeHeader, EZBeginEndTimeCell, EZScheduledTaskCell, EZTimeCounterView, EZButtonCell, EZScheduledV2Cell, EZGradientButtonCell;
//The purpose of this holder is serve as the file owner, 
//So that this cell could be used by many controllers.

//For test purpose only
@class EZPrematureCell;

@interface EZEditLabelCellHolder : NSObject

@property (strong, nonatomic) IBOutlet EZEditLabelCell* editCell;

@property (strong, nonatomic) IBOutlet EZTaskGroupCell* groupCell;

@property (strong, nonatomic) IBOutlet EZPureEditCell* pureEditCell;

@property (strong, nonatomic) IBOutlet EZSettingCell* settingCell;

@property (strong, nonatomic) IBOutlet EZEnvFlagPickerCell* flagCell;

@property (strong, nonatomic) IBOutlet EZAvailableTimeCell* timeCell;

@property (strong, nonatomic) IBOutlet EZScheduledCell* scheduledCell;

@property (strong, nonatomic) IBOutlet EZAvTimeCell* avTimeCell;

@property (strong, nonatomic) IBOutlet EZAvTimeHeader* avTimeHeader;

@property (strong, nonatomic) IBOutlet EZBeginEndTimeCell* beginEndTimeCell;
@property (strong, nonatomic) IBOutlet EZScheduledTaskCell* scheduledTaskCell;

@property (strong, nonatomic) IBOutlet EZTimeCounterView* timeCounterView;

@property (strong, nonatomic) IBOutlet EZButtonCell* buttonCell;

@property (strong, nonatomic) IBOutlet EZScheduledV2Cell* scheduleV2Cell;

@property (strong, nonatomic) IBOutlet EZPrematureCell* prematureCell;


@property (strong, nonatomic) IBOutlet EZGradientButtonCell* gradientButton;

//@property (strong, nonatomic) id<UITextFieldDelegate> delegate;

+ (EZEditLabelCellHolder*) getInstance;

+ (EZEditLabelCell*) createCellWithDelegate:(id<UITextFieldDelegate>)deleg;

+ (EZTaskGroupCell*) createTaskGroupCellWithDelegate:(id<UITextFieldDelegate>)deleg;

//Almost like the previous one.
//Only difference is that it is higher.
//Do I need all the trouble?
//Ye let's do it. 
//Time to reload the knowledge about NIB.
+ (EZTaskGroupCell*) createHigherTaskGroupCellWithDelegate:(id<UITextFieldDelegate>)deleg;

+ (EZPureEditCell*) createPureEditCellWithDelegate:(id<UITextFieldDelegate>)deleg;

//Create a higher version.
+ (EZPureEditCell*) createHigherPureEditCellWithDelegate:(id<UITextFieldDelegate>)deleg;

+ (EZSettingCell*) createSettingCell;

+ (EZEnvFlagPickerCell*) createFlagCell;

+ (EZAvailableTimeCell*) createTimeCell;

+ (EZScheduledCell*) createScheduledCell;

+ (EZAvTimeCell*) createAvTimeCell;
//Need to think about it later. 
//+ (UITableViewCell*) createCell:(NSString*)xibFile;

+ (EZAvTimeHeader*) createAvTimeHeader;

+ (EZBeginEndTimeCell*) createBeginEndTimeCell;

+ (EZScheduledTaskCell*) createScheduledTaskCell;

+ (EZTimeCounterView*) createTimeCounterView;

+ (EZButtonCell*) createButtonCell;

+ (EZScheduledV2Cell*) createScheduledV2Cell;

+ (EZPrematureCell*) createPrematureCell;

+ (EZGradientButtonCell*) createGradientButtonCell;

@end
