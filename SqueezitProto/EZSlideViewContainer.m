//
//  EZSlideViewContainerViewController.m
//  SqueezitProto
//
//  Created by Apple on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZSlideViewContainer.h"
#import "Constants.h"
#import "EZLRUMap.h"
#import "EZViewWrapper.h"


@interface EZSlideViewContainer () {
    //What's the purpose of this flag.
    //Some step I only do once, use this to keep the status.
    //Why not do it in the init?
    BOOL initailized;
    
    //Why do we need this?
    //Page in it could be reused. The least Used one will be served.
    //Why? I don't get it.
    //What I mean my use?
    //Since it is already in the cache, how people could use it?
    //Hit count?
    EZLRUMap* cachedPage;
    
    NSMutableDictionary* identifierMap;
    
    NSInteger pageCount;
    //BOOL scrollAnimated;
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

- (void) putToIdentifierMap:(EZViewWrapper*)pageView;

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
    cachedPage = [[EZLRUMap alloc] initWithLimit:5];
    //self.containerDelegate = delegate;
    //self.pageCount = [delegate pageCount:self];
    scrollView = [[UIScrollView alloc] init];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    //scrollView.scrollEnabled = false;
    //self.view.backgroundColor = [UIColor redColor];
    //[self.view setFrame:scrollView.frame];
	[self.view addSubview:scrollView];
    currentPage = 0;
    initailized = false;
    //scrollAnimated = NO;
    return self;
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    EZDEBUG(@"begin drag");
}
// called on finger up if the user dragged. velocity is in points/second. targetContentOffset may be changed to adjust where the scroll view comes to rest. not called when pagingEnabled is YES
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    EZDEBUG(@"scrollViewEndDragging get called");
}

- (void) putToIdentifierMap:(EZViewWrapper*)pageView
{
    NSString* identifier = pageView.identifier;
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
    [scrollView setContentOffset:CGPointMake(toPage*scrollView.frame.size.width, 0) animated:animate];
    //scrollAnimated = animate;
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
    [self scrollToPage:cp animated:NO];
}

- (void) scrollToPage:(NSInteger)cp animated:(BOOL)animated
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
    [self scrollFrom:currentPage to:cp animate:animated];
    currentPage = cp;

}

- (void) reloadPage:(NSInteger)page
{
    //I understand why remove the page from cache now.
    //Otherwise, the delegate will not get called. I will use the page in 
    //The cache and present it.
    [cachedPage removeObjectForKey:[[NSNumber alloc] initWithInt:page]];
    
    [self loadPage:page];
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
    if(page >= pageCount || page < 0){
        EZDEBUG(@"Quit load for page %i, currentCount: %i",page ,pageCount);
        return;
    }
    EZViewWrapper* viewWrapper = [cachedPage getObjectForKey:[[NSNumber alloc] initWithInt:page]];
    if(viewWrapper == nil){
        viewWrapper = [containerDelegate container:self viewForPage:page];
        [self putToIdentifierMap:viewWrapper];
        EZViewWrapper* removeView = [cachedPage setObject:viewWrapper forKey:[[NSNumber alloc] initWithInteger:page]];
        removeView.isInCache = NO;
        viewWrapper.isInCache = YES;
    }
    [self putView:viewWrapper.view atPage:page];
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
    //scrollAnimated = NO;
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
    currentPage = [containerDelegate firstDisplayPage:self];
    [self scrollFrom:currentPage to:currentPage animate:NO];
}

//When will viewWillAppear get called?
//When it show on screen. 
//Could I make it simpler, mean it add into Window and window about to display it?
//It maybe called multiple times so I use initialize to indicate this.
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.view.backgroundColor = [UIColor yellowColor];
    [scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    if(!initailized){
        initailized = true;
        [self reload];
    }
    EZDEBUG(@"End of viewWillAppear, frame:%@, currentPage:%i", NSStringFromCGRect(self.view.frame), currentPage);
    
}

//The only reason I could think of doing this it to update the weight in the cache.
//Now conception connected, This is the source of usage. 
//Should we have a suitable name for it?
- (EZViewWrapper*) getViewWrapperByPage:(NSInteger)page
{
    return [cachedPage getObjectForKey:[[NSNumber alloc] initWithInt:page]];
}

- (EZViewWrapper*) dequeueWithIdentifier:(NSString*)identifier
{
    NSArray* viewsForID = [identifierMap objectForKey:identifier];
    if(viewsForID){
        for(EZViewWrapper* wrapper in viewsForID){
            if(!wrapper.isInCache){
                EZDEBUG(@"Find view in cache for %@", identifier);
                return wrapper;
            }
        }
    }
    EZDEBUG(@"No find view for:%@",identifier);
    return nil;
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
