//
//  EZDotRoller.h
//  SqueezitProto
//
//  Created by Apple on 12-8-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//The default pixel is 3. will make it configurable later
#define radius 4

#define gapDistance  14

#define fixedPadding  2

#define stepDelay 0.01

#define pauseDelay 0.1

@class EZDotRoller;

typedef void (^ completeOps)();

typedef void (^ DrawAction)(CGContextRef ctx, EZDotRoller* roller);

//This with the code is much better and effective than in air. 
//Think in air, you will fall. 
//Just like create product with engage with real customer. 
//It will destined to fall. 
@interface EZDotRoller : UIView

//What's the purpose of this.
//How many dots is visible to you
@property (assign, nonatomic) NSInteger dotsNumber;

//What's is the currentDot
@property (assign, nonatomic) NSInteger currentDot;

//As it's name imply
@property (strong, nonatomic) UIColor* currentDotColor;

//As it's name imply
@property (strong, nonatomic) UIColor* otherDotColor;

//Why do I add this?
//I want to determined the action I should take within myself?
//Is this information enough?
//I think so.
@property (assign, nonatomic) NSInteger actualCurPage;


@property (assign, nonatomic) NSInteger accumulatedSteps;

@property (strong, nonatomic) DrawAction defaultAction;

@property (strong, nonatomic) DrawAction otherAction;

//How many dots 
//Why do we need this?
//I guess not. 
//Why? This is just as a effect generator
//It will work with my EZPageControl to get the job done.
//@property (assign, nonatomic) NSInteger totalDots;
- (void) rollLeftCount:(NSInteger)counts animated:(BOOL)animated completeOps:(completeOps)ops;

- (void) moveLeftOneUnit:(NSInteger)steps completeOps:(completeOps)ops;

- (void) moveRightOneUnit:(NSInteger)steps completeOps:(completeOps)ops;

//The meaning is on which direction the selected dot are move.
//The roll direction is reverse with the this direction
- (void) changeThenRollBack:(BOOL)isLeft;

- (void) adjustCurPage:(NSInteger)page;


@end
