//
//  CAppDelegate.h
//  viewagram
//
//  Created by wonymini on 6/28/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@class NavigationViewController;

@interface CAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Instagram *instagram;
@property (strong, nonatomic) NSString *myID;
@property (strong, nonatomic) NavigationViewController *viewController;
@property (strong, nonatomic) FBSession *session;



@end
