//
//  CSettingViewController.m
//  viewagram
//
//  Created by wonymini on 6/28/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import "CSettingViewController.h"
#import "CAppDelegate.h"
#import "CPrivacyViewController.h"
#import "CTermsViewController.h"
#import "Appirater.h"

@interface CSettingViewController ()

@end

@implementation CSettingViewController


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

    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    [bannerView_ setFrame: CGRectMake(0, 48, 320, bannerView_.frame.size.height)];
    bannerView_.adUnitID = ADMOV_PUBLISHER_ID;
    
    bannerView_.rootViewController = self;
    [self.view addSubview: bannerView_];
    
    [bannerView_ loadRequest: [GADRequest request]];
    
    [self AddSwitchViews];

    // Do any additional setup after loading the view from its nib.
}

- (void) AddSwitchViews {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    switchViewFB = [[RESwitch alloc] initWithFrame:CGRectMake(223, 169, 78, 27)];
    switchViewFB.on = dataKeeper.m_bFacebookLink;
    [switchViewFB setBackgroundImage:[UIImage imageNamed:@"switch_background"]];
    [switchViewFB setKnobImage:[UIImage imageNamed:@"switch_knob"]];
    [switchViewFB setOverlayImage:nil];
    [switchViewFB setHighlightedKnobImage:nil];
    [switchViewFB setCornerRadius:0];
    [switchViewFB setKnobOffset:CGSizeMake(0, 0)];
    [switchViewFB setTextShadowOffset:CGSizeMake(0, 0)];
    [switchViewFB setFont:[UIFont boldSystemFontOfSize:14]];
    [switchViewFB setTextOffset:CGSizeMake(-1, 2) forLabel:RESwitchLabelOn];
    [switchViewFB setTextOffset:CGSizeMake(6, 2) forLabel:RESwitchLabelOff];
    [switchViewFB setTextColor:[UIColor colorWithRed:85/255.0 green:102/255.0 blue:76/255.0 alpha:1] forLabel:RESwitchLabelOn];
    [switchViewFB setTextColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1] forLabel:RESwitchLabelOff];
    switchViewFB.layer.cornerRadius = 4;
    switchViewFB.layer.borderColor = [UIColor colorWithRed:224/255.0 green:36/255.0 blue:24/255.0 alpha:1].CGColor;
    switchViewFB.layer.borderWidth = 0;
    switchViewFB.layer.masksToBounds = YES;
    [switchViewFB addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchViewFB];
    
    switchViewTwitter = [[RESwitch alloc] initWithFrame:CGRectMake(223, 207, 78, 27)];
    switchViewTwitter.on = dataKeeper.m_bTwitterLink;
    [switchViewTwitter setBackgroundImage:[UIImage imageNamed:@"switch_background"]];
    [switchViewTwitter setKnobImage:[UIImage imageNamed:@"switch_knob"]];
    [switchViewTwitter setOverlayImage:nil];
    [switchViewTwitter setHighlightedKnobImage:nil];
    [switchViewTwitter setCornerRadius:0];
    [switchViewTwitter setKnobOffset:CGSizeMake(0, 0)];
    [switchViewTwitter setTextShadowOffset:CGSizeMake(0, 0)];
    [switchViewTwitter setFont:[UIFont boldSystemFontOfSize:14]];
    [switchViewTwitter setTextOffset:CGSizeMake(-1, 2) forLabel:RESwitchLabelOn];
    [switchViewTwitter setTextOffset:CGSizeMake(6, 2) forLabel:RESwitchLabelOff];
    [switchViewTwitter setTextColor:[UIColor colorWithRed:85/255.0 green:102/255.0 blue:76/255.0 alpha:1] forLabel:RESwitchLabelOn];
    [switchViewTwitter setTextColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:1] forLabel:RESwitchLabelOff];
    switchViewTwitter.layer.cornerRadius = 4;
    switchViewTwitter.layer.borderColor = [UIColor colorWithRed:224/255.0 green:36/255.0 blue:24/255.0 alpha:1].CGColor;
    switchViewTwitter.layer.borderWidth = 0;
    switchViewTwitter.layer.masksToBounds = YES;
    [switchViewTwitter addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchViewTwitter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [super dealloc];
    
    [switchViewFB release];
    [switchViewTwitter release];
}

#pragma mark - Actions

- (IBAction)onTouchNavBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)onTouchLogoutBtn:(id)sender {
    CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.instagram logout];
    [self.navigationController popToRootViewControllerAnimated: YES];
}

- (IBAction)onTouchPrivacy:(id)sender {
    CPrivacyViewController *privacyVC = [[CPrivacyViewController alloc] initWithNibName:@"CPrivacyViewController" bundle: nil];
    
    [self.navigationController pushViewController:privacyVC animated: YES];
    [privacyVC release];
}

- (IBAction)onTouchTerms:(id)sender {
    CTermsViewController *termsVC = [[CTermsViewController alloc] initWithNibName:@"CTermsViewController" bundle: nil];
    [self.navigationController pushViewController:termsVC animated: YES];
    [termsVC release];
}

- (IBAction)onTouchRateourApp:(id)sender {
    [Appirater userDidSignificantEvent:YES];
}

- (void)switchViewChanged:(RESwitch *)switchView
{
    CAppDelegate *appDelegate = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    if (switchView == switchViewFB) {
        if (switchView.on == YES) {
            
            if (appDelegate.session.isOpen) {
                // if a user logs out explicitly, we delete any cached token information, and next
                // time they run the applicaiton they will be presented with log in UX again; most
                // users will simply close the app or switch away, without logging out; this will
                // cause the implicit cached-token login to occur on next launch of the application
                dataKeeper.m_bFacebookLink = YES;
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
                    } else {
                        [switchView setOn:NO animated: YES];
                    }
                }];
                
            }

        } else {
            
            dataKeeper.m_bFacebookLink = NO;
        }
        

    } else {
        
        if (switchView.on == YES) {
            
            NSString *username = [[FHSTwitterEngine sharedEngine]loggedInUsername];// self.engine.loggedInUsername;
            if (username.length > 0) {
                dataKeeper.m_bTwitterLink = YES;
            } else {
                [[FHSTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:self withCompletion:^(BOOL success) {
                    if (success) {
                        dataKeeper.m_bTwitterLink = YES;
                    } else {
                        [switchView setOn:NO animated: YES];
                    }
                }];
                
            }

        } else {
            dataKeeper.m_bTwitterLink = NO;
        }
    }
    
    [dataKeeper saveDataToFile];
    
    NSLog(@"Value: %i", switchView.on);
}
@end
