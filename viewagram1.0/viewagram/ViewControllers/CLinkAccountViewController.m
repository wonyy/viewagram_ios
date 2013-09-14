//
//  CLinkAccountViewController.m
//  viewagram
//
//  Created by wonymini on 7/3/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import "CLinkAccountViewController.h"
#import "CMainViewController.h"
#import "CAppDelegate.h"

@interface CLinkAccountViewController ()

@end

@implementation CLinkAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_m_scrollView setContentSize:CGSizeMake(320, 501)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_scrollView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setM_scrollView:nil];
    [super viewDidUnload];
}

#pragma mark - Touch Actions

- (IBAction)onTouchSkipBtn:(id)sender {
    CMainViewController *mainVC = [[CMainViewController alloc] initWithNibName:@"CMainViewController" bundle: nil];
    
    [self.navigationController pushViewController:mainVC animated: YES];
    
    [mainVC release];
}

- (IBAction)onTouchLinkFBAccount:(id)sender {
    CAppDelegate *appDelegate = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        dataKeeper.m_bFacebookLink = YES;
        [self onTouchSkipBtn: nil];
    } else {
        // Create a new, logged out session.
        appDelegate.session = [[FBSession alloc] initWithPermissions:[NSArray arrayWithObjects:@"publish_actions", nil]];
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            //[m_loadingView setHidden: YES];
            
            if (status == FBSessionStateOpen) {
                dataKeeper.m_bFacebookLink = YES;
                [self onTouchSkipBtn: nil];
            }
        }];
        
    }

}


@end
