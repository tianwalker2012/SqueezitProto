//
//  EZKeyBoardHolder.m
//  SqueezitProto
//
//  Created by Apple on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZKeyBoardHolder.h"
#import "EZPickerKeyboardTime.h"
#import "EZScheduledLayer.h"
#import "EZActivityLayer.h"
#import "EZPageControl.h"

@implementation EZKeyBoardHolder
@synthesize pickerKeyBoard, dateKeyBoard, scheduleLayer, activityLayer, pageControl;

+ (EZPickerKeyboardTime*) createPickerKeyboard
{
    EZKeyBoardHolder* holder = [[EZKeyBoardHolder alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"PickerKeyboardTime" owner:holder options:nil];
    holder.pickerKeyBoard.picker.delegate = holder.pickerKeyBoard;
    holder.pickerKeyBoard.picker.dataSource = holder.pickerKeyBoard;
    return holder.pickerKeyBoard;
}

+ (EZPickerKeyboardDate*) createDateKeyboard
{
    EZKeyBoardHolder* holder = [[EZKeyBoardHolder alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"PickerKeyboardDate" owner:holder options:nil];
    return holder.dateKeyBoard;
}

+ (EZScheduledLayer*) createScheduledLayer
{
    EZKeyBoardHolder* holder = [[EZKeyBoardHolder alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"EZScheduledLayer" owner:holder options:nil];
    return holder.scheduleLayer;
}

+ (EZActivityLayer*) createActivityLayer
{
    EZKeyBoardHolder* holder = [[EZKeyBoardHolder alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"EZActivityLayer" owner:holder options:nil];
    return holder.activityLayer;
}

+ (EZPageControl*) createPageControl
{
    EZKeyBoardHolder* holder = [[EZKeyBoardHolder alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"EZPageControl" owner:holder options:nil];
    return holder.pageControl;
}

@end
