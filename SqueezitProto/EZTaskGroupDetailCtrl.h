//
//  EZTaskGroupDetailCtrl.h
//  SqueezitProto
//
//  Created by Apple on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZTaskGroup;

@interface EZTaskGroupDetailCtrl : UITableViewController 

@property (strong, nonatomic) EZTaskGroup* taskGroup;
@property (assign, nonatomic) NSInteger barType;

- (void) changeLeftBarButton;

@end
