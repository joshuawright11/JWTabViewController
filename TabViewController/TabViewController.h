//
//  ViewController.h
//  TabbedViewController
//
//  Created by Josh Wright on 7/1/14.
//  Copyright (c) 2014 Josh Wright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIView *tabBar;
@property (nonatomic, strong) UIView *selectedTab;

@property (nonatomic, assign) NSInteger topBarHeight;


// Remove Soon
@property UIFont *labelFont;
@property UIColor *textColor;
@property UIColor *highlightedTextColor;
@property UIColor *selectedTabColor;

-(void)putViewControllers:(NSArray *)viewControllers withTitles:(NSArray *)viewControllerTitles;

@end
