//
//  EZAvTimeCell.h
//  SqueezitProto
//
//  Created by Apple on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZAvTimeCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UILabel* name;
@property(strong, nonatomic) IBOutlet UILabel* envLabel;
@property(strong, nonatomic) IBOutlet UILabel* startTime;
@property(strong, nonatomic) IBOutlet UILabel* endTime;

@end
