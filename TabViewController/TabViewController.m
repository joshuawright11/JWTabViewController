//
//  ViewController.m
//  TabbedViewController
//
//  Created by Josh Wright on 7/1/14.
//  Copyright (c) 2014 Josh Wright. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIView *tabBar;
@property (nonatomic, strong) UIView *selectedTab;
@end

@implementation TabViewController
{
    float offsetPerView;
    float tabLength;
    NSArray *titles;
    NSMutableArray *tabs;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedTabColor = [UIColor blackColor];
    self.highlightedTextColor = [UIColor lightGrayColor];
    self.textColor = [UIColor blackColor];
    self.topBarHeight = 44;
    self.tabsPerScreen = 3;
    
//    self.edgesForExtendedLayout = UIRectEdgeNone; // No see through yet :(
    
    self.pageViewController = [self createPageViewController];
}

- (UIView *)createTabs // MEMORY LEAK
{
    if(self.tabBar != nil){
        [self.tabBar removeFromSuperview];
    }
    UIView *tabBar = [[UIView alloc] init];
    
    if([self.viewControllers count] < 1) {
        return tabBar;
    }
    
    float screenWidth = self.pageViewController.view.bounds.size.width;
    
    if(self.tabsPerScreen <= [self.viewControllers count]){
        tabLength = screenWidth / self.tabsPerScreen;
    }else{
        tabLength = screenWidth / [self.viewControllers count];
    }
    
    float barLength = tabLength * [self.viewControllers count];
    
    if(barLength < self.view.bounds.size.width){
        barLength = self.view.bounds.size.width;
    }
    
    tabs = [[NSMutableArray alloc] init];
    
    tabBar.frame = CGRectMake(self.view.bounds.origin.x, self.view.frame.origin.y, barLength, self.topBarHeight);
    
    for(int i = 0; i < [self.viewControllers count]; i++){
        UILabel *tab = [[UILabel alloc] initWithFrame:CGRectMake((tabLength * i), tabBar.bounds.origin.y, tabLength, tabBar.bounds.size.height)];
        [tab setTextAlignment:NSTextAlignmentCenter];
        
        tab.text = [titles objectAtIndex:i];
        tab.textColor = (i == 0) ? self.highlightedTextColor : self.textColor;
        
        tab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToView:)];
        [tab addGestureRecognizer:tapGesture];
        
        [tabBar addSubview:tab];
        [tabs addObject:tab];
    }
    self.selectedTab = [[UIView alloc] initWithFrame:CGRectMake(self.selectedIndex*tabLength+20, tabBar.bounds.size.height - 7, tabLength-40, 3)];
    self.selectedTab.layer.cornerRadius = 1.0f;
    self.selectedTab.backgroundColor = self.selectedTabColor;
    
    [tabBar addSubview:self.selectedTab];
    
    
    
    for(UIView *view in self.pageViewController.view.subviews){
        if([view isKindOfClass:[UIScrollView class]]){
            ((UIScrollView *)view).delegate = self;
        }
    }
    
    return tabBar;
}

- (void)jumpToIndex:(NSInteger)index
{
    if(index < 0 || index > [self.viewControllers count]-1) return;
    [self jumpBarToIndex:index];
    [self jumpViewToIndex:index];
    self.selectedIndex = index;
}

-(void)jumpToView:(UITapGestureRecognizer *)gesture
{
    NSInteger index = [tabs indexOfObject:gesture.view];
    
    [self jumpBarToIndex:index];
    [self jumpViewToIndex:index];
    self.selectedIndex = index;
}

- (UIPageViewController *)createPageViewController
{
    UIPageViewController *pageViewController = [[UIPageViewController alloc]
                                                initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                options:nil];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    pageViewController.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+self.topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.topBarHeight);
    [self.view addSubview:pageViewController.view];
    [self addChildViewController:pageViewController];
    [pageViewController didMoveToParentViewController:self];
    
    return pageViewController;
}

- (void)putViewControllers:(NSArray *)viewControllers withTitles:(NSArray *)viewControllerTitles
{
    
    self.viewControllers = viewControllers;
    titles = viewControllerTitles;
    UIView *tabBar = [self createTabs];
    self.tabBar = tabBar;
    [self.view addSubview:tabBar];
    
    [self.pageViewController setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.selectedIndex = 0;
    
}

#pragma mark - UIPageViewControllerSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger newIndex = [self.viewControllers indexOfObject:viewController]+1;
    if(newIndex < [self.viewControllers count]){
        return [self.viewControllers objectAtIndex:newIndex];
    }else{
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger newIndex = [self.viewControllers indexOfObject:viewController]-1;
    if(newIndex >= 0){
        return [self.viewControllers objectAtIndex:newIndex];
    }else{
        return nil;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSInteger newIndex = [self.viewControllers indexOfObject:self.pageViewController.viewControllers[0]];
    [self jumpBarToIndex:newIndex];
    self.selectedIndex = newIndex;
}

- (void)jumpBarToIndex:(NSInteger)index
{
    
    float actualTabs = (self.tabsPerScreen <= [self.viewControllers count]) ? self.tabsPerScreen : [self.viewControllers count];
    
    float offSet = (([self.viewControllers count] - actualTabs)*tabLength)/([self.viewControllers count]-1);
    
    
    UILabel *oldLabel = ((UILabel*)[tabs objectAtIndex:self.selectedIndex]);
    UILabel *newLabel = ((UILabel*)[tabs objectAtIndex:index]);
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.selectedTab.frame = CGRectMake(index*tabLength+20, self.selectedTab.frame.origin.y, tabLength-40, self.selectedTab.bounds.size.height);
        
        self.tabBar.frame = CGRectMake(-index*(offSet), self.tabBar.frame.origin.y, self.tabBar.bounds.size.width, self.tabBar.bounds.size.height);
    }completion:nil];
    
    [UIView transitionWithView:oldLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        oldLabel.textColor = self.textColor;
    } completion:^(BOOL finished) {
    }];
    [UIView transitionWithView:newLabel duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        newLabel.textColor = self.highlightedTextColor;
    } completion:^(BOOL finished) {
    }];
}

- (void)jumpViewToIndex:(NSInteger)index
{
    
    UIPageViewControllerNavigationDirection direction = index > self.selectedIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    __block TabViewController *blocksafeSelf = self;
    NSArray *vcs = @[self.viewControllers[index]];
    [self.pageViewController setViewControllers:vcs direction:direction animated:YES completion:^(BOOL finished){
        if(finished)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [blocksafeSelf.pageViewController setViewControllers:vcs direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];// bug fix for uipageview controller
            });
        }
    }];
}

#pragma mark - setters

-(void)setTabsPerScreen:(NSInteger)tabsPerScreen
{
    _tabsPerScreen = tabsPerScreen;
    //TODO
}

-(void)setTopBarHeight:(NSInteger)topBarHeight
{
    _topBarHeight = topBarHeight;
    //TODO
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for (int i = 0 ; i < [tabs count] ; i++) {
        if (i != self.selectedIndex) {
            ((UILabel *)[tabs objectAtIndex:i]).textColor = textColor;
        }
    }
}

-(void)setTabFont:(UIFont *)tabFont
{
    _tabFont = tabFont;
    for (UILabel *label in tabs) {
        label.font = tabFont;
    }
}

-(void)setHighlightedTextColor:(UIColor *)highlightedTextColor
{
    _highlightedTextColor = highlightedTextColor;
    ((UILabel *)[tabs objectAtIndex:self.selectedIndex]).textColor = highlightedTextColor;
}

-(void)setSelectedTabColor:(UIColor *)selectedTabColor
{
    _selectedTabColor = selectedTabColor;
    self.selectedTab.backgroundColor = selectedTabColor;
}

-(void)setPageViewBackgroundColor:(UIColor *)pageViewBackgroundColor
{
    _pageViewBackgroundColor = pageViewBackgroundColor;
    self.pageViewController.view.backgroundColor = pageViewBackgroundColor;
}

-(void)setTabBarBackgroundColor:(UIColor *)tabBarBackgroundColor
{
    _tabBarBackgroundColor = tabBarBackgroundColor;
    self.tabBar.backgroundColor = tabBarBackgroundColor;
}

@end