//
//  EZPickerKeyboardTime.h
//  SqueezitProto
//
//  Created by Apple on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EZValueSelector <NSObject>

@required
- (void) selectedRow:(NSInteger)row component:(NSInteger)component;

@end

@interface EZPickerKeyboardTime : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView* picker;
@property (strong, nonatomic) IBOutlet UILabel* title1;
@property (strong, nonatomic) IBOutlet UILabel* title2;
@property (strong, nonatomic) id<EZValueSelector> selector;

@end
