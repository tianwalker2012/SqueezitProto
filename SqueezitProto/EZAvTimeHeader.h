//
//  EZAvTimeHeader.h
//  SqueezitProto
//
//  Created by Apple on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZAvTimeHeader : UIView

- (void) showButton:(BOOL)show;

- (void) setupCellWithButton:(BOOL)yes;

@property (strong, nonatomic) IBOutlet UILabel* title;
@property (strong, nonatomic) IBOutlet UIButton* addButton;

@end
