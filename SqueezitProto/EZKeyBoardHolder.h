//
//  EZKeyBoardHolder.h
//  SqueezitProto
//
//  Created by Apple on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZPickerKeyboardTime, EZPickerKeyboardDate, EZScheduledLayer, EZActivityLayer, EZPageControl;

@interface EZKeyBoardHolder : NSObject

@property (strong, nonatomic) IBOutlet EZPickerKeyboardTime* pickerKeyBoard;

@property (strong, nonatomic) IBOutlet EZPickerKeyboardDate* dateKeyBoard;

@property (strong, nonatomic) IBOutlet EZScheduledLayer* scheduleLayer;

@property (strong, nonatomic) IBOutlet EZActivityLayer* activityLayer;

@property (strong, nonatomic) IBOutlet EZPageControl* pageControl;

+ (EZPickerKeyboardTime*) createPickerKeyboard;


+ (EZPickerKeyboardDate*) createDateKeyboard;


+ (EZScheduledLayer*) createScheduledLayer;


+ (EZActivityLayer*) createActivityLayer;

+ (EZPageControl*) createPageControl;

@end
