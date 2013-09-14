//
//  CAppDelegate.m
//  viewagram
//
//  Created by wonymini on 6/28/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import "CAppDelegate.h"
#import "CMainViewController.h"
#import "CLoginViewController.h"
#import "NavigationViewController.h"
#import "Appirater.h"

@implementation CAppDelegate
@synthesize session = _session;


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"672083051"];
    [Appirater setDaysUntilPrompt:30];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:YES];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    [dataKeeper loadDataFromFile];
    
     self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.instagram = [[Instagram alloc] initWithClientId:INSTAGRAM_APP_ID
                                                delegate:nil];
    
    // Override point for customization after application launch.
    CLoginViewController *loginVC = [[[CLoginViewController alloc] initWithNibName:@"CLoginViewController" bundle:nil] autorelease];
    self.viewController = [[[NavigationViewController alloc] initWithRootViewController: loginVC] autorelease];
    [self.viewController setNavigationBarHidden: YES];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
 //   [Appirater appLaunched:YES];
    
    return YES;
}

// YOU NEED TO CAPTURE igAPPID:// schema
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *str = [url absoluteString];
    
    if ([[str substringToIndex:2] isEqualToString:@"ig"])
    {
        return [self.instagram handleOpenURL:url];
    }
    
    return [self.session handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *str = [url absoluteString];
    
    if ([[str substringToIndex:2] isEqualToString:@"ig"])
    {
        return [self.instagram handleOpenURL:url];
    }
    
    return [self.session handleOpenURL:url]; 
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  //  [Appirater appEnteredForeground:YES];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    
    //  DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    //  dataKeeper.m_bShouldRefresh = YES;
    
    //  [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION object:nil];
    
    [FBSession.activeSession handleDidBecomeActive];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.session close];

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
