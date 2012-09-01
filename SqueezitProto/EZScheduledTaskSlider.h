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

//What's the purpose of this function?
//Tell us today have changed.
//The timecounter will call this method to indicate that today is over.
- (void) updateToday:(NSDate*)today;

@property (strong, nonatomic) EZOperationBlock viewAppearBlock;

@end
