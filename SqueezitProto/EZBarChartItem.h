//
//  EZBarChartItem.h
//  SqueezitProto
//
//  Created by Apple on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZBaseChartItem.h"
#import "EZGraphHelper.h"

@interface EZBarChartItem : EZBaseChartItem<CPTPlotSpaceDelegate,
CPTBarPlotDelegate>

@property (strong, nonatomic) id<CPTPlotDataSource> dataSource;

@property (strong, nonatomic) id<EZGraphDataSource> mySource;

@end
