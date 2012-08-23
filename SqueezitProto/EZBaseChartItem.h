//
//  EZBaseChartItem.h
//  SqueezitProto
//
//  Created by Apple on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CorePlot-CocoaTouch.h>


@class CPTGraph;
@class CPTTheme;

@interface EZBaseChartItem : NSObject
{
	CPTGraphHostingView *defaultLayerHostingView;
    
	NSMutableArray *graphs;
	NSString *title;
	CPTNativeImage *cachedImage;
}

@property (nonatomic, retain) CPTGraphHostingView* defaultLayerHostingView;
@property (nonatomic, retain) NSMutableArray *graphs;
@property (nonatomic, retain) NSString *title;

-(void)renderInView:(UIView *)hostingView withTheme:(CPTTheme *)theme;

-(CPTNativeImage *)image;

-(void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme;

-(void)setTitleDefaultsForGraph:(CPTGraph *)graph withBounds:(CGRect)bounds;
-(void)setPaddingDefaultsForGraph:(CPTGraph *)graph withBounds:(CGRect)bounds;

-(void)reloadData;
-(void)applyTheme:(CPTTheme *)theme toGraph:(CPTGraph *)graph withDefault:(CPTTheme *)defaultTheme;

-(void)addGraph:(CPTGraph *)graph;
-(void)addGraph:(CPTGraph *)graph toHostingView:(CPTGraphHostingView *)layerHostingView;
-(void)killGraph;

-(void)generateData;


@end
