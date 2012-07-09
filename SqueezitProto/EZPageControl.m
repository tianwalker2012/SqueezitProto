//
//  EZPageControl.m
//  SqueezitProto
//
//  Created by Apple on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZPageControl.h"
#import "EZTaskHelper.h"

#define OffsetUnit 16.0
#define InitialOffset 16.0
#define CountPerPage 10

//For the first iteration,
//I assume the page can be infinite
//So no need delegate to tell me so.
@interface EZPageControl()
{
    //The beginning of the page.
    int startPage;
    //CGFloat offsetX;
}

- (void) adjustPosition:(NSInteger)startPage animated:(BOOL)animated;

@end


@implementation EZPageControl
@synthesize pageDelegate, currentPage, pageControl;


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    pageControl.backgroundColor = [UIColor grayColor];
    [self addSubview:pageControl];
    self.clipsToBounds = true;
    return self;
}
   
- (void) awakeFromNib
{
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    pageControl.backgroundColor = [UIColor grayColor];
    [self addSubview:pageControl];
}

- (void) updatePageControlFrame:(NSInteger)pages
{
    CGRect updateFrame = pageControl.frame;
    updateFrame.size.width = 6 + (pages - 1)*OffsetUnit;
    pageControl.frame = updateFrame;
}

//Will be called the first time enter into the page
- (void) setInitialCurrentPage:(NSInteger)cp
{
    pageControl.currentPage = cp;
    if(cp < (CountPerPage-1)){
        pageControl.numberOfPages = CountPerPage;
        startPage = 0;
    }else{
        [self updatePageControlFrame:cp + 2];
        pageControl.numberOfPages = cp + 2;
        startPage = pageControl.numberOfPages - CountPerPage;
    }
    EZDEBUG(@"currentPage:%i, startPage:%i, numberOfPages:%i",cp, startPage, pageControl.numberOfPages);
    [self adjustPosition:startPage animated:false];
}



//We have following cases
//1. It change between the gap, not shift needed
//2. Change between gap, but need shift.
//3. Change out of the range of current window.
//What we should do?
//This not gonna happen in the near future
//I assume people will check for minus page outside.
- (void) setCurrentPage:(NSInteger)cp
{
    //raise exception for not processed causes
    //Mean I don't support jumping so far
    //assert(cp < pageControl.numberOfPages);
    if(cp > startPage && cp < (startPage + CountPerPage - 1)){
        EZDEBUG(@"Normal case, setting current page and do nothing");
        pageControl.currentPage = cp;
    }else if(cp >= (startPage + CountPerPage - 1)){
        if(pageControl.numberOfPages < ( cp + 2)){
            [self updatePageControlFrame:cp + 2];
            pageControl.numberOfPages = cp + 2;
        }
        pageControl.currentPage = cp;
        startPage = cp + 2 - CountPerPage;
        [self adjustPosition:startPage animated:YES];
    }else if(cp <= startPage){
        pageControl.currentPage = cp;
        if(cp == 0){
            startPage = 0;
        }else{
            startPage = cp - 1;
        }
        [self adjustPosition:startPage animated:YES];
    }
}

//Adjust position according to the startPage.
//Add to animation later.
- (void) adjustPosition:(NSInteger)sp animated:(BOOL)animated
{
    CGFloat offsetX = 0;
    offsetX += -sp * OffsetUnit;
    EZDEBUG(@"offsetX:%f for startPage:%i, currentPage:%i", offsetX, sp, pageControl.currentPage);
    if(pageControl.left != offsetX){
        if(animated){
            [self performBlock:^(){
                [UIView beginAnimations:@"Move page control" context:nil];
                [UIView animateWithDuration:0.2 animations:^(){
                    pageControl.left = offsetX;
                }];
                [UIView commitAnimations];
            } withDelay:0.2];
        }else{
            pageControl.left = offsetX;
        }
    }
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
