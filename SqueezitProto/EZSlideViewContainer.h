//
//  EZSlideViewContainerViewController.h
//  SqueezitProto
//
//  Created by Apple on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EZSlideViewPage<NSObject>

- (NSString*) getIdentifier;
- (BOOL) isInContainerCache;
- (void) setInContainerCache:(BOOL)indicator;

@end
//What's my expectation out of this delegate
//Let's learn from the UITableView.
//1. Tell how many page it have
//2. Inform the page when it get displayed.
//3. Get current View Controller and show it.
//Good enough?
@class  EZSlideViewContainer;
@protocol  EZSlideViewDelegate<NSObject>

- (NSInteger) pageCount:(EZSlideViewContainer*)container;
- (UIView<EZSlideViewPage>*) container:(EZSlideViewContainer*)container viewForPage:(NSInteger)page;
//Why not tell view?
- (void) container:(EZSlideViewContainer*)container pageDisplayed:(NSInteger)page;


//The purpose of this function call it that
//If the container reach the end of the page, it will call this method
//ask if it have more?
//If it is, return the next PageCount.
//If not, just return the old PageCount.
//If your page will keep increasing, then, you just keep increasing the pageCount 
- (NSInteger) nextPage:(NSInteger)page;

@end



@interface EZSlideViewContainer : UIViewController<UIScrollViewDelegate> {
    UIScrollView* scrollView;
}

//@property (assign, nonatomic) CGSize contentSize;
@property (strong, nonatomic) id<EZSlideViewDelegate> containerDelegate;

//Outside only change the number of the pages. This make sense, right?
//@property (assign, nonatomic) NSInteger pageCount;
@property (assign, nonatomic) NSInteger currentPage;

- (id) init;

//Mean the view changed, let's get it from the delegate again.
- (void) reloadPage:(NSInteger)page;

//Mean will reload all the paged.
//Following assumption will be made.
//Cache will be cleaned
//CurrentPage will set to zero.
//Page count will be readed
//Good enough?
//Should I animated it?
//It is animated by default?
//Consider it on next iteration
- (void) reload;

//Descript the logic in this method
//1. Get the object from the NSDictionary by the identifier. 
//2. Make sure it is not contained in current cluster.
//3. Return it
//What will be the change to the rest of the code?
//No more cache. 
//Every time try to get the page from the delegate.
//Have a mutableArray to maintian the current visible pages.
//How to update them?
//The cluster call is the right time to update that array
- (id<EZSlideViewPage>) dequeueWithIdentifier:(NSString*)identifier;



@end
