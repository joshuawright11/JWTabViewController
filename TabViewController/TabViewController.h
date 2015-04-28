//
//  ViewController.h
//  TabbedViewController
//
//  Created by Josh Wright on 7/1/14.
//  Copyright (c) 2014 Josh Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate,UIScrollViewDelegate>



// Remove Soon
@property (nonatomic, assign) NSInteger topBarHeight;
@property (nonatomic, assign) NSInteger tabsPerScreen;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIFont *tabFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightedTextColor;
@property (nonatomic, strong) UIColor *selectedTabColor;
@property (nonatomic, strong) UIColor *tabBarBackgroundColor;
@property (nonatomic, strong) UIColor *pageViewBackgroundColor;

- (void)putViewControllers:(NSArray *)viewControllers withTitles:(NSArray *)viewControllerTitles;
- (UIView *)createTabs;
- (void)jumpToIndex:(NSInteger)index;

@end
