//
//  EZDotRoller.m
//  SqueezitProto
//
//  Created by Apple on 12-8-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZDotRoller.h"
#import "Constants.h"
#import "EZTaskHelper.h"

@interface EZDotRoller()
{
    completeOps completeHolder;
}

//What's the length of the whole picture
- (NSInteger) calculateLength:(NSInteger)dotNumber;

- (void) innerMove:(NSInteger)steps completeOps:(completeOps)ops isLeft:(BOOL)isLeft;

@end

@implementation EZDotRoller
@synthesize currentDot, currentDotColor, otherDotColor, dotsNumber, accumulatedSteps, otherAction, defaultAction, actualCurPage;


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    //__weak EZDotRoller* weakSelf = self;
    EZDEBUG(@"initWithFrame");
    defaultAction = ^(CGContextRef context, EZDotRoller* roller){
        CGFloat height = roller.frame.size.height;
        CGFloat width = roller.frame.size.width;
        CGSize pictureSize = [roller calculateSize:roller.dotsNumber];
        
        CGFloat shiftX = (width - pictureSize.width)/2;
        CGFloat shiftY = (height - pictureSize.height)/2;
        
        for(int i = 0; i < roller.dotsNumber; i++){
            [roller drawDots:i color:(i == roller.currentDot?roller.currentDotColor:roller.otherDotColor) shiftX:shiftX shiftY:shiftY ctx:context];
        }

    };
    return self;
}


//How many case do I have?
//1. If newAp larger than old AP, mean user flip right.
// deltaAp = newAp - oldAp
//How many kind of actions do I have?
// a. if totalDotNumber - curDot -1 > newAp, then just set the curDot + delta
//    else curDot = totalDotNumber - 2;
// b. if curDot + newAp > 0, then 
// One issue need to notice, is that my controller coupled with my logic. 
// So what I design for my controller.
// This is the most efficient way to do thing. 
// Design specifically for this purpose. 
- (void) adjustCurPage:(NSInteger)newAp;
{
    NSInteger deltaAp =  newAp - actualCurPage;
    if(deltaAp > 0){//Mean flip from right to left
        if(dotsNumber - currentDot - 1 > deltaAp){
            currentDot += deltaAp;
            [self setNeedsDisplay];
        }else{
            currentDot = dotsNumber - 2;
            [self setNeedsDisplay];
            [self changeThenRollBack:FALSE];
        }
        
    }else if(deltaAp < 0){  //Mean flip left to right
        if(currentDot + deltaAp > 0){ 
            currentDot += deltaAp;
            [self setNeedsDisplay];
        }else{
            if(newAp <= 0){
                currentDot = 0;
                [self setNeedsDisplay];
            }else{
                currentDot = 1;
                [self changeThenRollBack:TRUE];
            }
        }
        
    }
    actualCurPage = newAp;
}

//How many dots 
//Why do we need this?
//I guess not. 
//Why? This is just as a effect generator
//It will work with my EZPageControl to get the job done.
//@property (assign, nonatomic) NSInteger totalDots;
- (void) rollLeftCount:(NSInteger)counts animated:(BOOL)animated completeOps:(completeOps)ops
{
    
}

//Draw cycles on the canvas.
//Typing each line of code by hand.
//Any time I will try to on the center of the view frame.
//I will automatically keep at the center.
//I assume client left enough space for it.
//Reasonable assumption. 
//No checking any more.
- (void) drawRect:(CGRect)rect
{
    //EZDEBUG(@"DotRoller drawRect");
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(otherAction){
        //EZDEBUG(@"Call other");
        otherAction(context, self);
    }else{
        //EZDEBUG(@"call defaultAction");
        defaultAction(context, self);
    }
}


//Who will call me?
//What's the expectation of the caller?
//What I was doing in this method?
//When do we use this method?
//When the dot move the second position of the dot control,
//There are still availble hidden pages, so I will create a animation 
//Which the dot will move out of the hidden places, and then the dot will back to that place.
- (void) moveLeftOneUnit:(NSInteger)steps completeOps:(completeOps)ops
{
    [self innerMove:steps completeOps:ops isLeft:TRUE];
}

- (void) moveRightOneUnit:(NSInteger)steps completeOps:(completeOps)ops
{
    [self innerMove:steps completeOps:ops isLeft:FALSE];
}

- (void) innerMove:(NSInteger)steps completeOps:(completeOps)ops isLeft:(BOOL)isLeft
{
    CGFloat unitStep = gapDistance/steps;
    accumulatedSteps = 0;
    otherAction = ^(CGContextRef context,EZDotRoller* roller){
        CGFloat height = roller.frame.size.height;
        CGFloat width = roller.frame.size.width;
        CGSize pictureSize = [roller calculateSize:roller.dotsNumber];
        ++roller.accumulatedSteps;
        CGFloat shiftX = (width - pictureSize.width)/2; 
        
        if(isLeft){
            shiftX -=  roller.accumulatedSteps * unitStep;
        }else{
            shiftX += roller.accumulatedSteps * unitStep;
        }
        
        CGFloat shiftY = (height - pictureSize.height)/2;
        
        for(int i = 0; i < roller.dotsNumber; i++){
            [roller drawDots:i color:(i == roller.currentDot?roller.currentDotColor:roller.otherDotColor) shiftX:shiftX shiftY:shiftY ctx:context];
        }
        
        if(roller.accumulatedSteps == steps){
            roller.otherAction = nil;
            //[roller performBlock:^(){ ops();} withDelay:stepDelay];
            ops();
            [roller performBlock:^(){[roller setNeedsDisplay];} withDelay:stepDelay];
        }else{
            [roller performBlock:^(){[roller setNeedsDisplay];} withDelay:stepDelay];
        }
        
    };
    [self setNeedsDisplay];
}


- (void) changeThenRollBack:(BOOL)isLeft
{
    EZDotRoller* troller = self;
    if(isLeft){
        troller.currentDot = troller.currentDot - 1;
    }else{
        troller.currentDot = troller.currentDot + 1;
    }
    [troller setNeedsDisplay];
    
    completeHolder = ^(){
        troller.dotsNumber = troller.dotsNumber + 1;
        if(isLeft){
            troller.currentDot = troller.currentDot + 1;
        }else{
            troller.currentDot = troller.currentDot - 1;
        }
        [troller performBlock:^(){
            troller.dotsNumber = troller.dotsNumber - 1;
            [troller setNeedsDisplay];
        } withDelay:pauseDelay];
    };
    
    [troller performBlock:^(){
        //troller.currentDot = troller.currentDot + 1;
        //troller.dotsNumber = troller.dotsNumber + 1;
        [troller innerMove:3 completeOps:completeHolder isLeft:!isLeft];
    } withDelay:pauseDelay];
}

//Draw the dots out.
- (void) drawDots:(NSInteger)curDot color:(UIColor*)color shiftX:(CGFloat)x shiftY:(CGFloat)y
ctx:(CGContextRef)ctx
{
    CGContextBeginPath(ctx);
    
    CGFloat realX = x + fixedPadding + curDot*gapDistance;
    CGFloat realY = y + fixedPadding;
    
    //EZDEBUG(@"x:%f, realX:%f, curDot:%i",x, realX, curDot);
    //CGContextMoveToPoint(ctx, realX, realY);
    CGContextAddEllipseInRect(ctx, CGRectMake(realX, realY, radius*2 , radius*2));
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillPath(ctx);
}

//What's the size of the whole picture
- (CGSize) calculateSize:(NSInteger)dotNumber
{
    if(dotsNumber <= 1){
        return CGSizeMake(radius*2+fixedPadding*2, radius*2+fixedPadding*2);
    }
    
    return CGSizeMake((dotsNumber-1)*gapDistance + fixedPadding*2 + radius*2, radius*2+fixedPadding*2);
    
}

@end
