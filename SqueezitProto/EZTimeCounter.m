//
//  EZTimeCounter.m
//  SqueezitProto
//
//  Created by Apple on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTimeCounter.h"
#import "EZTimeCounterView.h"

@interface EZTimeCounter(){
    NSTimer* timer;
    NSDate* lastTime;
}

- (void) timeTick;


@end


@implementation EZTimeCounter
@synthesize remainTime, timeupOps, counterView, tickBlock, isCounting, ongoingTaskPos;

// Each fire will get called
- (void) timeTick
{
    //EZDEBUG(@"Time tick get called");
    if(tickBlock){
        tickBlock(self);
    }
    if(!isCounting){
        return;
    }
   // EZDEBUG(@"Start update time, remaining:%f",remainTime);
    NSDate* now = [NSDate date];
    NSTimeInterval gap = now.timeIntervalSince1970 - lastTime.timeIntervalSince1970;
    lastTime = now;
    remainTime -= gap;
    if(remainTime <= 0){
        remainTime = 0.0;
        isCounting = false;
        if(timeupOps){
            timeupOps(self);
        }
    }
    if(counterView){
        counterView.counter.text = [self updateTitle];
    }
    //EZDEBUG(@"timeTick completed");
}

- (void) update
{
    [self timeTick];
}

- (NSString*) intToZeroPaddingString:(NSInteger)val
{
    NSString* res = [NSString stringWithFormat:@"%i", val];
    if(res.length < 2){
        return [NSString stringWithFormat:@"0%@",res];
    }
    return res;
}


- (NSString*) updateTitle 
{
    NSInteger hours = remainTime/(60*60);
    
    NSInteger minutes = remainTime;
    minutes = (minutes%(60*60))/60;
    NSInteger seconds = remainTime;
    seconds = seconds%60;
    return [NSString stringWithFormat:@"%@:%@:%@",
                [self intToZeroPaddingString:hours],
                [self intToZeroPaddingString:minutes],
                [self intToZeroPaddingString:seconds]];
    
}



- (void) start:(NSTimeInterval)intervel
{
    lastTime = [NSDate date];
    if(timer){
        [timer invalidate];
        timer = nil;
    }
    //timer = [NSTimer timerWithTimeInterval:intervel target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
    timer = [NSTimer scheduledTimerWithTimeInterval:intervel target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
}

- (void) stop
{
    [timer invalidate];
}



@end
