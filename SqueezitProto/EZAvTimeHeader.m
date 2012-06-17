//
//  EZAvTimeHeader.m
//  SqueezitProto
//
//  Created by Apple on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZAvTimeHeader.h"
#import "Constants.h"

@interface EZAvTimeHeader(){
    BOOL showed;
    CGFloat orgX;
}

@end

@implementation EZAvTimeHeader
@synthesize addButton, title;


- (id) init
{
    EZDEBUG(@"EZAvTimeHeader raw init get called");
    self = [super init];
    
    return self;
}

//Should only call this once,
//I need to put it in the init method, but since I load this view 
//from Xib files, so far I found the init didn't get called.
- (void) setupCellWithButton:(BOOL)hasButton;
{
    showed = hasButton;
    orgX = title.frame.origin.x;
    addButton.alpha = 1;
    EZDEBUG(@"OrginX is:%f, title Frame:%@",orgX,NSStringFromCGRect(title.frame));
    if(showed){
        [title setFrame:CGRectMake(44, title.frame.origin.x, title.frame.size.width, title.frame.size.height)];
        [addButton setFrame:CGRectMake(7, addButton.frame.origin.y, addButton.frame.size.width, addButton.frame.size.height)];
    }else{
        [addButton setFrame:CGRectMake(-addButton.frame.size.width, addButton.frame.origin.y, addButton.frame.size.width, addButton.frame.size.height)];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    EZDEBUG(@"EZAvTimerHeader initWithFrame get called");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) showButton:(BOOL)show
{
    if(showed == show){//status didn't change do nothing.
        return;
    }
    
    showed = show;
    [UIView beginAnimations:@"ShowButton" context:nil];
    [UIView animateWithDuration:0.3 animations:^(){
        if(show){
            [title setFrame:CGRectMake(44, title.frame.origin.y, title.frame.size.width, title.frame.size.height)];
            [addButton setFrame:CGRectMake(7, addButton.frame.origin.y, addButton.frame.size.width, addButton.frame.size.height)];
        }else{
            [title setFrame:CGRectMake(orgX, title.frame.origin.y, title.frame.size.width, title.frame.size.height)];
            [addButton setFrame:CGRectMake(-addButton.frame.size.width, addButton.frame.origin.y, addButton.frame.size.width, addButton.frame.size.height)];
        }
    }];
    [UIView commitAnimations];
        
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
