//
//  EZBeginEndTimeCell.h
//  SqueezitProto
//
//  Created by Apple on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZBeginEndTimeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* beginTitle;
@property (strong, nonatomic) IBOutlet UILabel* endTitle;

@property (strong, nonatomic) IBOutlet UILabel* beginTime;
@property (strong, nonatomic) IBOutlet UILabel* endTime;

- (void) setHaveAccessor:(BOOL)haveAccessor;


@end
