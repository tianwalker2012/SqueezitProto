//
//  EZKeyBoardHolder.h
//  SqueezitProto
//
//  Created by Apple on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZPickerKeyboardTime;

@interface EZKeyBoardHolder : NSObject

@property (strong, nonatomic) IBOutlet EZPickerKeyboardTime* pickerKeyBoard;

+ (EZPickerKeyboardTime*) createPickerKeyBoard;

@end
