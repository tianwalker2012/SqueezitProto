//
//  EZPageControl.h
//  SqueezitProto
//
//  Created by Apple on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EZPageControlDelegate<NSObject>

- (NSInteger) limit;
- (void) setLimit:(NSInteger)pageLimit;

//This will be called, if it reach the end of the current pages
- (NSInteger) nextPage:(NSInteger)page;

- (NSInteger) Page;

@end

//What's the purpose of this class?
//The current issue with the standard PageControl
//It have no infinite page mode. 
//What should we do then?
//Many setting from the protocol. 
//For first iteration, just make it useful in the simplest cases
//Next iteration, make it a controller which can be used on many cases
//Be a pragmatic hacker. 
//Make it good for the use case at your hand.
@interface EZPageControl : UIView

@property (strong, nonatomic) IBOutlet UIPageControl* pageControl;

@property (assign, nonatomic) NSInteger currentPage;

@property (strong, nonatomic) id<EZPageControlDelegate> pageDelegate;

//- (id) initWithFrame:(CGRect)frame delegate:(id<EZPageControlDelegate>)delegate;
- (void) setInitialCurrentPage:(NSInteger)page;

@end
