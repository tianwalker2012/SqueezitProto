//
//  EZScheduledTaskSlider.h
//  SqueezitProto
//
//  Created by Apple on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZSlideViewContainer.h"
#import "EZTaskHelper.h"

@class EZScheduledTask;
@interface EZScheduledTaskSlider : EZSlideViewContainer<EZSlideViewDelegate>

- (void) presentScheduledTask:(EZScheduledTask*)task;

- (void) scheduleForTomorrow;

@property (strong, nonatomic) EZOperationBlock viewAppearBlock;

@end
