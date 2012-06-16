//
//  EZKeyBoardHolder.m
//  SqueezitProto
//
//  Created by Apple on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZKeyBoardHolder.h"
#import "EZPickerKeyboardTime.h"

@implementation EZKeyBoardHolder
@synthesize pickerKeyBoard, dateKeyBoard;

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

@end
