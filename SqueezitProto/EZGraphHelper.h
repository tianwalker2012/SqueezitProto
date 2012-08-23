//
//  EZGraphHelper.h
//  SqueezitProto
// 
//  Created by Apple on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//The purpose of this class is to encapsulate a bunch of method which could make the task of customize graph to demostrate message easier to client. 
//I love this
//The firs method is format.

@interface EZGraphHelper : NSObject

@end

//First iteration, I need to make sure what kind number will 
//Be pass inside?
//Did NSArray a convinient mapping structure for us?
@interface EZLabelFormatter : NSNumberFormatter


@end

//In the end I will use my protocol to replace 
//All the protocol method of the CorePlot. 
//Now do it iterative way.
@protocol EZGraphDataSource <NSObject>

- (CGFloat) getMaximumValue;

- (CGFloat) getMinimumValue;

@end