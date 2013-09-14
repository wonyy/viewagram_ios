//
//  NavigationViewController.m
//  REMenuExample
//
//  Created by Roman Efimov on 4/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
//  Sample icons from http://icons8.com/download-free-icons-for-ios-tab-bar
//

#import "NavigationViewController.h"
#import "CMainViewController.h"

#import "CAppDelegate.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
    
    // Blocks maintain strong references to any captured objects, including self,
    // which means that it’s easy to end up with a strong reference cycle if, for example,
    // an object maintains a copy property for a block that captures self
    // (which is the case for REMenu action blocks).
    //
    // To avoid this problem, it’s best practice to capture a weak reference to self:
    //
    
    [self InitMainMenu];
    [self InitFilterMenu];
    
}

- (void) InitMainMenu {
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"Home"
                                                       image:[UIImage imageNamed:@"homebtn"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                          
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:HOME_NOTIFICATION object:nil];
                                                          
                                                          //HomeViewController *controller = [[HomeViewController alloc] init];
                                                          //[weakSelf setViewControllers:@[controller] animated:NO];
                                                      }];
    
    REMenuItem *popularItem = [[REMenuItem alloc] initWithTitle:@"Popular"
                                                          image:[UIImage imageNamed:@"popularbtn"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:POPULAR_NOTIFICATION object:nil];
                                                             // ExploreViewController *controller = [[ExploreViewController alloc] init];
                                                             // [weakSelf setViewControllers:@[controller] animated:NO];
                                                         }];
    
    REMenuItem *trendingItem = [[REMenuItem alloc] initWithTitle:@"Trending"
                                                           image:[UIImage imageNamed:@"trendingbtn"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:TRENDING_NOTIFICATION object:nil];
                                                              // ActivityViewController *controller = [[ActivityViewController alloc] init];
                                                              // [weakSelf setViewControllers:@[controller] animated:NO];
                                                          }];
    
    REMenuItem *settingsItem = [[REMenuItem alloc] initWithTitle:@"Settings"
                                                           image:[UIImage imageNamed:@"navbar_settingbtn"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:SETTINGS_NOTIFICATION object:nil];
                                                              // ActivityViewController *controller = [[ActivityViewController alloc] init];
                                                              // [weakSelf setViewControllers:@[controller] animated:NO];
                                                          }];
    
    REMenuItem *signoutItem = [[REMenuItem alloc] initWithTitle:@"Sign Out"
                                                          image:[UIImage imageNamed:@"signoutbtn"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             [_menu closeWithCompletion:^(void) {
                                                                 CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;
                                                                 [appDelegate.instagram logout];
                                                                 [self popToRootViewControllerAnimated:YES];
                                                             }];
                                                             
                                                             
                                                         }];
    
    // You can also assign custom view for items
    // Uncomment the code below and add customViewItem to `initWithItems` array, e.g.
    // [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem, customViewItem]]
    //
    /*
     UIView *customView = [[UIView alloc] init];
     customView.backgroundColor = [UIColor blueColor];
     customView.alpha = 0.4;
     REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
     NSLog(@"Tap on customView");
     }];
     */
    
    homeItem.tag = 0;
    popularItem.tag = 1;
    trendingItem.tag = 2;
    settingsItem.tag = 3;
    signoutItem.tag = 4;
    
    
    
    _menu = [[REMenu alloc] initWithItems:@[homeItem, popularItem, trendingItem, settingsItem, signoutItem]];
    _menu.cornerRadius = 4;
    _menu.shadowRadius = 4;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(5, -1);
    _menu.waitUntilAnimationIsComplete = NO;
    
}

- (void) InitFilterMenu {
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor blueColor];
    customView.alpha = 0.4;
    
    REMenuItem *menuTitleItem = [[REMenuItem alloc] initWithTitle:@"Filter Settings"
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:nil];
    
    UIImage* imgCheck = [UIImage imageNamed:@"checkbtn"];
    UIImage* imgUnCheck = [UIImage imageNamed:@"uncheckbtn"];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    REMenuItem *pictureItem = [[REMenuItem alloc] initWithTitle:@"Pictures" image:(dataKeeper.m_bImageFilter) ? imgCheck : imgUnCheck highlightedImage:(dataKeeper.m_bImageFilter) ? imgUnCheck : imgCheck action:^(REMenuItem *item)
    {
        NSLog(@"Item: %@", item);
        
        if (dataKeeper.m_bImageFilter) {
            item.image = imgUnCheck;
            item.higlightedImage = imgCheck;
            
        } else {
            item.image = imgCheck;
            item.higlightedImage = imgUnCheck;
        }
        
        dataKeeper.m_bImageFilter = !(dataKeeper.m_bImageFilter);
        
        [dataKeeper saveDataToFile];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_NOTIFICATION object:nil];
    }];
    
    REMenuItem *videoItem = [[REMenuItem alloc] initWithTitle:@"Videos" image:(dataKeeper.m_bVideoFilter) ? imgCheck : imgUnCheck highlightedImage:(dataKeeper.m_bVideoFilter) ? imgUnCheck : imgCheck action:^(REMenuItem *item)
    {
        NSLog(@"Item: %@", item);
        
        if (dataKeeper.m_bVideoFilter) {
            item.image = imgUnCheck;
            item.higlightedImage = imgCheck;
            
        } else {
            item.image = imgCheck;
            item.higlightedImage = imgUnCheck;
        }
        
        dataKeeper.m_bVideoFilter = !(dataKeeper.m_bVideoFilter);
        
        [dataKeeper saveDataToFile];
        
      [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_NOTIFICATION object:nil];
    }];

    
    // You can also assign custom view for items
    // Uncomment the code below and add customViewItem to `initWithItems` array, e.g.
    // [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem, customViewItem]]
    //
    /*
     UIView *customView = [[UIView alloc] init];
     customView.backgroundColor = [UIColor blueColor];
     customView.alpha = 0.4;
     REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
     NSLog(@"Tap on customView");
     }];
     */
    
    menuTitleItem.tag = 0;
    pictureItem.tag = 1;
    videoItem.tag = 2;

    _filtermenu = [[REMenu alloc] initWithItems:@[menuTitleItem, pictureItem, videoItem]];
    _filtermenu.cornerRadius = 4;
    _filtermenu.shadowRadius = 4;
    _filtermenu.shadowColor = [UIColor blackColor];
    _filtermenu.shadowOffset = CGSizeMake(0, 1);
    _filtermenu.shadowOpacity = 1;
    _filtermenu.imageOffset = CGSizeMake(5, -1);
    _filtermenu.waitUntilAnimationIsComplete = NO;

}

- (void) dealloc {
    [super dealloc];
    [_menu release];
    [_filtermenu release];
}

- (void)toggleMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    if (_filtermenu.isOpen)
        [_filtermenu close];
    
    [_menu showFromRect:CGRectMake(0, 66, 320, self.view.frame.size.height) inView:self.view];
}

- (void)closeMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    if (_filtermenu.isOpen)
        return [_filtermenu close];
}

- (void)toggleFilterMenu
{
    if (_filtermenu.isOpen)
        return [_filtermenu close];
    
    if (_menu.isOpen)
        [_menu close];
    
    [_filtermenu showFromRect:CGRectMake(0, 66, 320, self.view.frame.size.height) inView:self.view];
    
    //    [_menu showInView: self.view];
    //    [_menu showFromNavigationController:self];
}


@end
