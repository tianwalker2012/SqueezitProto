//
//  EZScheduledLayer.h
//  SqueezitProto
//
//  Created by Apple on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZTaskHelper.h"

@interface EZScheduledLayer : UIView

@property (strong, nonatomic) IBOutlet UILabel* infoLabel;
@property (strong, nonatomic) IBOutlet UIButton* button;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityView;
@property (strong, nonatomic) EZOperationBlock clickedBlock;

- (IBAction)clicked:(id)sender;

@end
