//
//  EZSlideViewContainerViewController.m
//  SqueezitProto
//
//  Created by Apple on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZSlideViewContainer.h"
#import "Constants.h"
#import "EZLimitMap.h"


@interface EZSlideViewContainer () {
    BOOL initailized;
    EZLimitMap* cachedPage;
    NSMutableDictionary* identifierMap;
    
    NSInteger pageCount;
    BOOL scrollAnimated;
}

//The meaning of this function is to move the view Port to that page.
//Will load the page before and after this page.
//Set this page as current.
//Set Current will call it, right?
//What's the difference, I prefer to get this as internal method call.
//setCurrent will check if current equal the setting, if equal will not call this method.
- (void) scrollFrom:(NSInteger)fromPage to:(NSInteger)toPage  animate:(BOOL)animate;

- (void) loadPage:(NSInteger)page;
- (void) releasePage:(NSInteger)page;

//Expose to subview?
- (void) putView:(UIView*)view atPage:(NSInteger)page;

//When the pageCount changed. What's the right place to call this?
//currentPage or loadPage.
- (void) adjustPageCountFrom:(NSInteger)from to:(NSInteger)to;

- (void) putToIdentifierMap:(UIView<EZSlideViewPage>*)pageView;

//Will load the page count again
//Here is 2 cases
//1. The first time this view loaded, the count will be called.
//2. Later this will get called again. When
//I guess, we will proved reload functionality which will do this right?

//The cache and release policy will get done here. 
//So the outside should not cache at all, right?
//It is not the right place to do things.
//The only case fail it is the setCurrentPage function call, 
//Which need to have all the views ready to scroll through it.
- (void) loadPageCluster:(NSInteger)page;

@end

@implementation EZSlideViewContainer
@synthesize containerDelegate, currentPage;

- (id) init;
{
    self = [super init];
    //[self.view setFrame:frame];
    identifierMap = [[NSMutableDictionary alloc] init];
    //Enough to aviod shake
    cachedPage = [[EZLimitMap alloc] initWithLimit:5];
    //self.containerDelegate = delegate;
    //self.pageCount = [delegate pageCount:self];
    scrollView = [[UIScrollView alloc] init];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    self.view.backgroundColor = [UIColor redColor];
    //[self.view setFrame:scrollView.frame];
	[self.view addSubview:scrollView];
    currentPage = 0;
    initailized = false;
    scrollAnimated = NO;
    return self;
}

- (void) putToIdentifierMap:(UIView<EZSlideViewPage>*)pageView
{
    NSString* identifier = pageView.getIdentifier;
    NSMutableArray* pageViews = [identifierMap objectForKey:identifier];
    if(pageViews == nil){
        pageViews = [[NSMutableArray alloc] init];
        [pageViews addObject:pageView];
        [identifierMap setObject:pageViews forKey:identifier];
    }else{
        if(![pageViews containsObject:pageView]){
            [pageViews addObject:pageView];
        }
    }
    
}

- (void) loadPageCluster:(NSInteger)page
{
    [self loadPage:page];
    [self loadPage:page+1];
    [self loadPage:page-1];
}

//The meaning of this function is to move the view Port to that page.
//Will load the page before and after this page.
//Set this page as current.
//Set Current will call it, right?
//What's the difference, I prefer to get this as internal method call.
//setCurrent will check if current equal the setting, if equal will not call this method.
- (void) scrollFrom:(NSInteger)fromPage  to:(NSInteger)toPage  animate:(BOOL)animate
{
    [self loadPageCluster:toPage];
    
    /**
    if(fromPage != toPage){
        NSInteger begin = fromPage;
        NSInteger end = toPage;
        if(fromPage > toPage){
            begin = toPage;
            end = fromPage;
        }
        for(NSInteger i = (begin+1); i <  end; i++){
            [self loadPage:i];
        }
    }
     **/
    scrollAnimated = YES;
    [scrollView setContentOffset:CGPointMake(toPage*scrollView.frame.size.width, 0) animated:animate];
    scrollAnimated = animate;
}

//PageCount changed, what will happened?
//Will only handle increase cases for now.
- (void) adjustPageCountFrom:(NSInteger)from to:(NSInteger)to
{
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * to, scrollView.frame.size.height);
}

//Do no validation check?
//I should do right?
//Yes, confirmed
//Why make setCurrentPage have side effect?
//Ok for asking this questions.
//But for this iteration. Keep it up and run as fast as possible.
//Fine tune it on production iteration.
- (void) setCurrentPage:(NSInteger)cp
{
    //assert(cp < pageCount);
    if(cp >= pageCount){
        NSInteger newPageCount = [containerDelegate nextPage:cp];
        if(newPageCount != pageCount){
            [self adjustPageCountFrom:pageCount to:newPageCount];
            pageCount = newPageCount;
        }
    }
    
    if(cp >= pageCount || cp < 0){
        EZDEBUG(@"Page Count %i, requested:%i, request will get ignored",pageCount, cp);
    }
    
    if(cp == currentPage){//Do nothing
        return;
    }
    [self scrollFrom:currentPage to:cp animate:YES];
    currentPage = cp;
    
}


- (void) reloadPage:(NSInteger)page
{
    UIView* view = [containerDelegate container:self viewForPage:page];
    [cachedPage setObject:view forKey:[[NSNumber alloc] initWithInteger:page]];

    [self putView:view atPage:page];
}


//When to release?
//Release 
//Unless farther noticed, I will use my cached view
//I will release the cached view according to my needs
//Normally only 3 view will be kept in cache
- (void) loadPage:(NSInteger)page
{
    if(page >= pageCount){
        NSInteger newPageCount = [containerDelegate nextPage:page];
        if(newPageCount != pageCount){
            [self adjustPageCountFrom:pageCount to:newPageCount];
            pageCount = newPageCount;
        }
    }
    if(page >= pageCount){
        EZDEBUG(@"Quit load for page %i exceed %i",page ,pageCount);
        return;
    }
    UIView<EZSlideViewPage>* view = [cachedPage getObjectForKey:[[NSNumber alloc] initWithInt:page]];
    if(view == nil){
        view = [containerDelegate container:self viewForPage:page];
        UIView<EZSlideViewPage>* removeView = [cachedPage setObject:view forKey:[[NSNumber alloc] initWithInteger:page]];
        [removeView setInContainerCache:NO];
        [view setInContainerCache:YES];
        
    }
    [self putView:view atPage:page];
}

- (void) putView:(UIView*)view atPage:(NSInteger)page
{
    CGFloat x = page * scrollView.frame.size.width;
    if(view.frame.origin.x != x){
        //I hope this will decrease the shaking
        [view setFrame:CGRectMake(x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
    }
    if(view.superview != scrollView){
        [scrollView addSubview:view];
    }
}


//I guess this is the right place to call the page displayed
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    EZDEBUG(@"didEndDecelerating get called");
    [containerDelegate container:self pageDisplayed:currentPage];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    //if(scrollAnimated){
    //    return;
    //}
    //EZDEBUG(@"didScroll get called");
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(currentPage == page){
        return;
    }
    currentPage = page;
    [self loadPageCluster:currentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    EZDEBUG(@"End scroll animation called");
    scrollAnimated = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//This is like reset.
//Once this called,This container will be sure in some status.
//I love this
- (void) reload
{
    EZDEBUG(@"Reload called");
    pageCount = [containerDelegate pageCount:self];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [containerDelegate pageCount:self], scrollView.frame.size.height);
    [cachedPage removeAllObjects];
    currentPage = 0;
    [self scrollFrom:currentPage to:currentPage animate:NO];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor yellowColor];
    [scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    if(!initailized){
        initailized = true;
        [self reload];
    }
    EZDEBUG(@"End of viewWillAppear, frame:%@, currentPage:%i", NSStringFromCGRect(self.view.frame), currentPage);
    
}

- (id<EZSlideViewPage>) dequeueWithIdentifier:(NSString*)identifier
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
