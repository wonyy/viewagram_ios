//
//  CMainViewController.m
//  viewagram
//
//  Created by wonymini on 6/28/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import "CMainViewController.h"
#import "CSettingViewController.h"
#import "NavigationViewController.h"
#import "CAppDelegate.h"

@interface CMainViewController ()

@end

@implementation CMainViewController


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
    
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = ADMOV_PUBLISHER_ID;
    
    [interstitial_ loadRequest: [GADRequest request]];
    
    
    // Loading Indicator Initialize
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    

    // Show Loading for Initalize
    [self ShowLoading];

    // Initialize
    [self Initialize];
    
    // Twitter Setting
    [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:kTwitterOAuthConsumerKey andSecret:kTwitterOAuthConsumerSecret];
    [[FHSTwitterEngine sharedEngine] setDelegate:self];
    
    // Home Menu is selected
    [[NSNotificationCenter defaultCenter] addObserverForName:HOME_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         [self ShowLoading];
         [self GetMyFeed];
     }];
    
    // Popular Menu is selected
    [[NSNotificationCenter defaultCenter] addObserverForName:POPULAR_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         [self ShowLoading];
         [self GetPopular];
     }];
    
    // Trending Menu is selected
    [[NSNotificationCenter defaultCenter] addObserverForName:TRENDING_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         [self SwitchTrending];
     }];
    
    // Refresh Menu is selected
    [[NSNotificationCenter defaultCenter] addObserverForName:REFRESH_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         [self RefreshData];
     }];
    
    // Settings Menu is selected
    [[NSNotificationCenter defaultCenter] addObserverForName:SETTINGS_NOTIFICATION object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         [self GotoSettings];
     }];
    
    // Get Medias what I have liked from Instagram
    [self GetMyLikes];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [super dealloc];
    
    [bannerView_ release];

    [_m_trendingLogoCell release];
    [_m_trendingBarCell release];
    [_m_mainhashCell release];
    [_m_hashtagCell release];
    [_m_avatarBack release];

    [_m_avatarView release];
    [_m_scrollView release];
    [_m_followingBtn release];
    [_m_imageViewHeartIcon release];
    [_m_tableViewTrending release];
    [_m_strCurrentHashTagName release];
    [_m_strNextMaxTagID release];
    
    [_m_imageView release];
    [_m_labelUserName release];
    
    [HUD removeFromSuperview];
    [HUD release];
    
    if (m_arrayFeed != nil) {
        [m_arrayFeed release];
    }
    
    if (m_arrayPopular != nil) {
        [m_arrayPopular release];
    }
    
    if (m_arrayTrending != nil) {
        [m_arrayTrending release];
    }
    
    if (m_follows != nil) {
        [m_follows release];
    }
    
    if (m_linked != nil) {
        [m_linked release];
    }
    
    if (_m_moviePlayer != nil) {
        [_m_moviePlayer release];
    }
    
    if (m_hashTagList != nil) {
        [m_hashTagList release];
    }
    
    if (_m_strFollowerID != nil) {
        [_m_strFollowerID release];
    }
    
    if (_m_strCurrentMediaID != nil) {
        [_m_strCurrentMediaID release];
    }
    
}



- (void)viewDidUnload {
    [self setM_imageView:nil];
    [self setM_labelUserName:nil];
    [self setM_avatarView:nil];
    [self setM_scrollView:nil];
    [self setM_followingBtn:nil];
    [self setM_imageViewHeartIcon:nil];
    [self setM_tableViewTrending:nil];
    [self setM_trendingLogoCell:nil];
    [self setM_trendingBarCell:nil];
    [self setM_mainhashCell:nil];
    [self setM_hashtagCell:nil];
    [self setM_strCurrentHashTagName: nil];
    [self setM_strNextMaxTagID: nil];
    
    [self setM_avatarBack:nil];
    [super viewDidUnload];
}

#pragma mark - Loading Indicator Functions

- (void) ShowLoading {
    HUD.labelText = @"Loading";
    [HUD showUsingAnimation: YES];
}

- (void) ShowFollowing {
    HUD.labelText = @"Following";
    [HUD showUsingAnimation: YES];
}

- (void) ShowUnfollowing {
    HUD.labelText = @"Unfollowing";
    [HUD showUsingAnimation: YES];
}


- (void) ShowLiking {
    HUD.labelText = @"Liking";
    [HUD showUsingAnimation: YES];
}

#pragma mark - Run Instagram APIs

// Get Medias I've liked
- (void) GetMyLikes {
    NSLog(@"GetMyLikes: Prepare for getting my liked medias...");
    CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/media/liked", @"method", @"100000", @"count", nil];
    
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
}

// Get users who I am following
- (void) GetMyFollows {
    NSLog(@"GetMyFollow: Prepare for getting my followers...");
    
    CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@/follows", appDelegate.myID], @"method", nil];
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
}

// Get My Feed
- (void) GetMyFeed {
    NSLog(@"GetMyFeed: Prepare for getting my feed...");

    if ([m_arrayFeed count] == 0) {
        NSLog(@"GetMyFeed: Feed array is empty, so it's going to get feed from instagram...");

        CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;
        NSMutableDictionary* params = nil;
        
        if (_m_strCurrentMediaID != nil) {
            NSLog(@"GetMyFeed: it's not first page. getting feed with max_id. max_id = %@", _m_strCurrentMediaID);

            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/feed", @"method",_m_strCurrentMediaID, @"max_id", nil];
        } else {
            NSLog(@"GetMyFeed: it's first page. getting feed without max_id.");
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/feed", @"method", nil];
        }
        
        [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    } else {
        NSLog(@"GetMyFeed: Feed array is not empty, so it's going to get show current photo...");

        m_nScreenType = 0;
        
        [self ShowLoading];
        [NSThread detachNewThreadSelector:@selector(showCurrentPhoto) toTarget:self withObject:nil];
    }
}

// Get Popular Medias
- (void) GetPopular {
    NSLog(@"GetPopular: Prepare for getting popular medias...");

    if ([m_arrayPopular count] == 0) {
        NSLog(@"GetPopular: Popular array is empty, so it's going to get popular from instagram...");

        CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"media/popular", @"method", nil];
        [appDelegate.instagram requestWithParams:params
                                        delegate:self];
    } else {
        NSLog(@"GetPopular: it's first page. getting popular without max_id.");

        m_nScreenType = 1;
        
        [self ShowLoading];
        [NSThread detachNewThreadSelector:@selector(showCurrentPhoto) toTarget:self withObject:nil];
    }
}

// Get Medias with HashTag
- (void) GetTrending: (NSString *) strHashTag {
    NSLog(@"GetTrending: Prepare for getting trending medias... HashTag = %@", strHashTag);
    
    if ([strHashTag isEqualToString: _m_strCurrentHashTagName] == NO) {
        
        if (_m_strNextMaxTagID != nil) {
            [_m_strNextMaxTagID release];
        }
        
        _m_strNextMaxTagID = nil;
    }
    
    [self setM_strCurrentHashTagName: strHashTag];
    
    CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = nil;
    
    if (_m_strNextMaxTagID != nil) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"tags/%@/media/recent", strHashTag], @"method",_m_strNextMaxTagID, @"max_id", nil];
    } else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"tags/%@/media/recent", strHashTag], @"method", nil];
    }
    
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
}

// Like Current Media
- (void) LikeCurrentMedia {
    NSLog(@"LikeCurrentMedia: Prepare for liking current media...");

    CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *strMethod = [NSString stringWithFormat:@"media/%@/likes", _m_strCurrentMediaID];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:strMethod, @"method", nil];
    [appDelegate.instagram requestWithMethodName:strMethod params:params httpMethod:@"POST" delegate:self];
}

// Follow Current User
- (void) FollowCurrentUser {
    NSLog(@"FollowCurrentUser: Prepare for follow current user...");
    
    CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *strMethod = [NSString stringWithFormat:@"users/%@/relationship", _m_strFollowerID];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:strMethod, @"method", @"follow", @"action", nil];
    [appDelegate.instagram requestWithMethodName:strMethod params:params httpMethod:@"POST" delegate:self];

}

// UnFollow Current User
- (void) UnfollowCurrentUser {
    NSLog(@"UnfollowCurrentUser: Prepare for unfollow current user...");

    CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *strMethod = [NSString stringWithFormat:@"users/%@/relationship", _m_strFollowerID];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:strMethod, @"method", @"unfollow", @"action", nil];
    [appDelegate.instagram requestWithMethodName:strMethod params:params httpMethod:@"POST" delegate:self];

}

#pragma mark - Functions

// Initialize Function
- (void) Initialize {
    
    NSLog(@"Initializing...");
    
    m_nCurrentFeedIndex = 0;
    m_nCurrentPopularIndex = 0;
    m_nCurrentTrendingIndex = 0;
    m_nScreenType = 0;
    
    _m_strCurrentMediaID = nil;
    
    m_arrayFeed = [[NSMutableArray alloc] init];
    m_arrayPopular = [[NSMutableArray alloc] init];
    m_arrayTrending = [[NSMutableArray alloc] init];
    
    m_follows = [[NSMutableArray alloc] init];
    m_linked = [[NSMutableArray alloc] init];
    
    m_hashTagList = [[NSMutableArray alloc] initWithObjects:@"instavid", @"love", @"instagood", @"me", @"cute", @"photooftheday", @"follow", @"tbt", @"like", @"girl", @"picoftheday", @"followme", @"beautiful", @"instadaily", @"tagsforlikes", @"happy", @"igers", @"instamood", @"summer", @"bestoftheday", @"fun", nil];
    
    [_m_scrollView setContentSize:CGSizeMake(320, 439)];
}

// Open Switch Hash Tag Screen
- (void) SwitchTrending {
    [_m_tableViewTrending setHidden: NO];
}

// Goto Settings Page
- (void) GotoSettings {    
    CSettingViewController *settingVC = [[CSettingViewController alloc] initWithNibName:@"CSettingViewController" bundle: nil];
    
    [self.navigationController pushViewController: settingVC animated: YES];
    [settingVC release];

}

- (void) RefreshData {
    if (m_nScreenType == 0) {
        
        if (_m_strCurrentMediaID != nil) {
            [_m_strCurrentMediaID release];
            _m_strCurrentMediaID = nil;
        }

        [m_arrayFeed removeAllObjects];
        m_nCurrentFeedIndex = 0;
        
        [self ShowLoading];
        [self GetMyFeed];
        
    } else if (m_nScreenType == 1) {
        
        [m_arrayPopular removeAllObjects];
        m_nCurrentPopularIndex = 0;
        
        [self ShowLoading];
        [self GetPopular];
        
    } else if (m_nScreenType == 2) {
        
        NSString *strTempHasTagName = [NSString stringWithString: _m_strCurrentHashTagName];
        
        if (_m_strCurrentHashTagName != nil) {
            [_m_strCurrentHashTagName release];
            _m_strCurrentHashTagName = nil;
        }
        
        [m_arrayTrending removeAllObjects];
        m_nCurrentTrendingIndex = 0;
        
        [self ShowLoading];
        [self GetTrending: strTempHasTagName];
        
    }
}

- (void) showCurrentPhoto {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"Show Current Photo: Start!!!");
    
    if (_m_moviePlayer != nil && _m_moviePlayer.view != nil) {
        [_m_moviePlayer.view removeFromSuperview];        
    }

    
    if (_m_moviePlayer != nil) {
        [_m_moviePlayer release];
        _m_moviePlayer = nil;
    }

    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    if (m_nScreenType == 0) {
        NSDictionary *dictItem = [m_arrayFeed objectAtIndex: m_nCurrentFeedIndex];
        
        if ([[dictItem objectForKey:@"type"] isEqualToString:@"image"]) {
            NSDictionary *dictImages = [dictItem objectForKey:@"images"];
            
            NSString *strImageURL = [[dictImages objectForKey:@"standard_resolution"] objectForKey:@"url"];
            
            [_m_imageView setImage: [dataKeeper getImage: strImageURL]];
                 
        } else if ([[dictItem objectForKey:@"type"] isEqualToString:@"video"]) {
            
            [self performSelectorOnMainThread:@selector(playCurrentVideo) withObject:nil waitUntilDone:YES];
        }

        // Get Profile Picture
        NSString *strAvatarURL = [[dictItem objectForKey:@"user"] objectForKey:@"profile_picture"];
        [_m_avatarView setImage: [dataKeeper getImage: strAvatarURL]];
        [_m_avatarBack setHidden: NO];

        // Get User Name
        [_m_labelUserName setText: [[dictItem objectForKey:@"user"] objectForKey:@"username"]];
        [_m_labelUserName setHidden: NO];
        
        // Show Follows Button
        NSString *strID = [[dictItem objectForKey:@"user"] objectForKey:@"id"];
        
        [self setM_strFollowerID: strID];
        
        BOOL bFollowed = NO;
        for (NSInteger nIndex = 0; nIndex < [m_follows count]; nIndex++) {
            
            NSString *strFollowerID = [m_follows objectAtIndex: nIndex];
            
            if ([strID isEqualToString: strFollowerID]) {
                bFollowed = YES;
                break;
            }
            
        }
        
        if (bFollowed == YES) {
            [_m_followingBtn setSelected: YES];
        } else {
            [_m_followingBtn setSelected: NO];
        }
        
        [_m_followingBtn setHidden: NO];
        
        // Set Current Media ID
        [self setM_strCurrentMediaID: [dictItem objectForKey:@"id"]];
        
    //    NSLog(@"Current Media ID = %@", _m_strCurrentMediaID);
        
        // Hide Loading Animation
        [HUD hideUsingAnimation: YES];
        
        [dataKeeper saveDataToFile];
        
    } else if (m_nScreenType == 1) {
        NSDictionary *dictItem = [m_arrayPopular objectAtIndex: m_nCurrentPopularIndex];
        
        if ([[dictItem objectForKey:@"type"] isEqualToString:@"image"]) {
            NSDictionary *dictImages = [dictItem objectForKey:@"images"];
            
            NSString *strImageURL = [[dictImages objectForKey:@"standard_resolution"] objectForKey:@"url"];
            
            [_m_imageView setImage: [dataKeeper getImage: strImageURL]];
        
        } else if ([[dictItem objectForKey:@"type"] isEqualToString:@"video"]) {
                         
            [self performSelectorOnMainThread:@selector(playCurrentVideo) withObject:nil waitUntilDone:YES];
            
        }
        
        // Get Profile Picture
        NSString *strAvatarURL = [[dictItem objectForKey:@"user"] objectForKey:@"profile_picture"];
        [_m_avatarView setImage: [dataKeeper getImage: strAvatarURL]];
        [_m_avatarBack setHidden: NO];
        
        // Get User Name
        [_m_labelUserName setText: [[dictItem objectForKey:@"user"] objectForKey:@"username"]];
        [HUD hideUsingAnimation: YES];
        
        // Show Follows Button
        NSString *strID = [[dictItem objectForKey:@"user"] objectForKey:@"id"];
        
        [self setM_strFollowerID: strID];
        
        BOOL bFollowed = NO;
        for (NSInteger nIndex = 0; nIndex < [m_follows count]; nIndex++) {
            
            NSString *strFollowerID = [m_follows objectAtIndex: nIndex];
            
            if ([strID isEqualToString: strFollowerID]) {
                bFollowed = YES;
                break;
            }
            
        }
        
        if (bFollowed == YES) {
            [_m_followingBtn setSelected: YES];
        } else {
            [_m_followingBtn setSelected: NO];
        }
        
        [_m_followingBtn setHidden: NO];
        
        // Set Current Media ID
        [self setM_strCurrentMediaID: [dictItem objectForKey:@"id"]];
        
        [dataKeeper saveDataToFile];
        
    }  else if (m_nScreenType == 2) {
        NSDictionary *dictItem = [m_arrayTrending objectAtIndex: m_nCurrentTrendingIndex];
        
        if ([[dictItem objectForKey:@"type"] isEqualToString:@"image"]) {
            NSDictionary *dictImages = [dictItem objectForKey:@"images"];
            
            NSString *strImageURL = [[dictImages objectForKey:@"standard_resolution"] objectForKey:@"url"];
            
            [_m_imageView setImage: [dataKeeper getImage: strImageURL]];
            
        } else if ([[dictItem objectForKey:@"type"] isEqualToString:@"video"]) {

            [self performSelectorOnMainThread:@selector(playCurrentVideo) withObject:nil waitUntilDone:YES];
            
        }
        
        // Get Profile Picture
        NSString *strAvatarURL = [[dictItem objectForKey:@"user"] objectForKey:@"profile_picture"];
        [_m_avatarView setImage: [dataKeeper getImage: strAvatarURL]];
        [_m_avatarBack setHidden: NO];
        
        // Get User Name
        [_m_labelUserName setText: [[dictItem objectForKey:@"user"] objectForKey:@"username"]];
        [HUD hideUsingAnimation: YES];
        
        // Show Follows Button
        NSString *strID = [[dictItem objectForKey:@"user"] objectForKey:@"id"];
        
        [self setM_strFollowerID: strID];
        
        BOOL bFollowed = NO;
        for (NSInteger nIndex = 0; nIndex < [m_follows count]; nIndex++) {
            NSString *strFollowerID = [m_follows objectAtIndex: nIndex];
            
            if ([strID isEqualToString: strFollowerID]) {
                bFollowed = YES;
                break;
            }
            
        }
        
        if (bFollowed == YES) {
            [_m_followingBtn setSelected: YES];
        } else {
            [_m_followingBtn setSelected: NO];
        }
        
        [_m_followingBtn setHidden: NO];
        
        // Set Current Media ID
        [self setM_strCurrentMediaID: [dictItem objectForKey:@"id"]];
        
        [dataKeeper saveDataToFile];
    }
    
    [_m_tableViewTrending setHidden: YES];
    
    m_nTotalShowCnt++;
    
    if (m_nTotalShowCnt % 10 == 0) {
        [self performSelectorOnMainThread:@selector(ShowFullScreenAD) withObject:nil waitUntilDone: YES];
    }

    NSLog(@"Show Current Photo: End!!!");
    [pool release];
}

- (void) ShowFullScreenAD {
    [interstitial_ presentFromRootViewController: self];
}

- (void) playCurrentVideo {
    NSDictionary *dictItem = nil;
    
    if (m_nScreenType == 0) {
        dictItem = [m_arrayFeed objectAtIndex: m_nCurrentFeedIndex];;
    } else if (m_nScreenType == 1){
        dictItem = [m_arrayPopular objectAtIndex: m_nCurrentPopularIndex];
    } else if (m_nScreenType == 2) {
        dictItem = [m_arrayTrending objectAtIndex: m_nCurrentTrendingIndex];
    }
    
    NSString *strURL = [[[dictItem objectForKey: @"videos"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
    
    _m_moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString: strURL]];
    _m_moviePlayer.shouldAutoplay = NO;
    [_m_moviePlayer prepareToPlay];
    [_m_moviePlayer.view setFrame: _m_imageView.frame];  // player's frame must match parent's
    
    [_m_scrollView addSubview: _m_moviePlayer.view];
}

- (void) GotoNextPhotoThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    sleep(1);
    
    [self performSelectorOnMainThread:@selector(GotoNextPhoto) withObject:nil waitUntilDone: YES];
    
    [pool release];
}

- (void) GotoNextPhoto {
    [_m_imageViewHeartIcon setHidden: YES];
    
    if (m_nScreenType == 0) {
        
        if ([m_arrayFeed count] == 0) {
            return;
        }
        
        if (m_nCurrentFeedIndex < [m_arrayFeed count] - 1)
        {
            m_nCurrentFeedIndex++;
            
            [self ShowLoading];
            [NSThread detachNewThreadSelector:@selector(showCurrentPhoto) toTarget:self withObject:nil];
            
        } else {
            
            [m_arrayFeed removeAllObjects];
            m_nCurrentFeedIndex = 0;
            [self ShowLoading];
            [self GetMyFeed];
        }
    } else if (m_nScreenType == 1) {
        
        if ([m_arrayPopular count] == 0) {
            return;
        }
        
        if (m_nCurrentPopularIndex < [m_arrayPopular count] - 1)
        {
            m_nCurrentPopularIndex++;
            [self ShowLoading];
            [NSThread detachNewThreadSelector:@selector(showCurrentPhoto) toTarget:self withObject:nil];
            
        } else {
            [m_arrayPopular removeAllObjects];
            m_nCurrentPopularIndex = 0;
            [self ShowLoading];
            [self GetPopular];
            
        }
    }  else if (m_nScreenType == 2) {
        
        if ([m_arrayTrending count] == 0) {
            return;
        }
        
        if (m_nCurrentTrendingIndex < [m_arrayTrending count] - 1)
        {
            m_nCurrentTrendingIndex++;
            [self ShowLoading];
            [NSThread detachNewThreadSelector:@selector(showCurrentPhoto) toTarget:self withObject:nil];
            
        } else {
            [m_arrayTrending removeAllObjects];
            m_nCurrentTrendingIndex = 0;
            
            [self ShowLoading];
            [self GetTrending: _m_strCurrentHashTagName];
            
        }
    }

}

#pragma mark - Touch Actions

- (IBAction)onTouchSettingBtn:(id)sender {
    NavigationViewController *navCtrl = (NavigationViewController *) self.navigationController;
    
    [navCtrl toggleFilterMenu];
}

- (IBAction)onTouchMenuBtn:(id)sender {
    NavigationViewController *navCtrl = (NavigationViewController *) self.navigationController;
    
    [navCtrl toggleMenu];
}

- (IBAction)onTouchPassBtn:(id)sender {
    [self GotoNextPhoto];
}

- (IBAction)onTouchFollowBtn:(id)sender {
    if (_m_followingBtn.selected == NO) {
        
        [self ShowFollowing];
        
        [self FollowCurrentUser];
        
    } else {
        
        [self ShowUnfollowing];
        
        [self UnfollowCurrentUser];
    }
}

- (IBAction)onTouchLikeBtn:(id)sender {
    [self ShowLiking];
    
    [self LikeCurrentMedia];
}

- (IBAction)onTouchLogoBtn:(id)sender {
    NSInteger nIndex = [sender tag] - 1000;
    
    NSString *strHashTag = nil;
    
    switch (nIndex) {
        case 1:
            strHashTag = @"selfie";
            break;
        case 2:
            strHashTag = @"music";
            break;
        case 3:
            strHashTag = @"love";
            break;
        case 4:
            strHashTag = @"loop";
            break;
        case 5:
            strHashTag = @"food";
            break;
        case 6:
            strHashTag = @"howto";
            break;
        default:
            return;
            break;
    }
    
    m_nCurrentTrendingIndex = 0;
    
    [self ShowLoading];
    [self GetTrending: strHashTag];
}

- (IBAction)onTouchHashTagBtn:(id)sender {
    NSInteger nIndex = [sender tag] - 2000;
    
    m_nCurrentTrendingIndex = 0;
    
    [self ShowLoading];
    [self GetTrending: [m_hashTagList objectAtIndex:nIndex]];
}

#pragma mark - IGRequestDelegate

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    
    [HUD hideUsingAnimation: YES];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    CAppDelegate* appDelegate = (CAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSString *method = [[request params] objectForKey:@"method"];

    NSLog(@"Instagram Did Load: request: %@", method);

    // My Feed
    if ([method isEqualToString:@"users/self/feed"]) {

        NSArray *array = (NSArray*)[result objectForKey:@"data"];
                
        [m_arrayFeed removeAllObjects];
        
        for (NSInteger nIndex = 0; nIndex < [array count]; nIndex++) {
            NSDictionary *dictItem = [array objectAtIndex: nIndex];
            
            NSString *strID = [dictItem objectForKey:@"id"];
            NSString *strType = [dictItem objectForKey:@"type"];
            
            if ([strType isEqualToString:@"image"] && dataKeeper.m_bImageFilter == NO) {
                continue;
            } else if ([strType isEqualToString:@"video"] && dataKeeper.m_bVideoFilter == NO) {
                continue;
            }
            
            BOOL bLiked = NO;

            for (NSInteger nLikeIndex = 0; nLikeIndex < [m_linked count]; nLikeIndex++) {
                NSString *strLikerID = [m_linked objectAtIndex: nLikeIndex];
                
                if ([strLikerID isEqualToString:strID]) {
                    bLiked = YES;
                    break;
                }
            }
            
            if (bLiked == YES) {
                continue;
            }
            
            [m_arrayFeed addObject: dictItem];

        }
        
        m_nScreenType = 0;
        
        if ([m_arrayFeed count] > 0) {
            [NSThread detachNewThreadSelector:@selector(showCurrentPhoto) toTarget:self withObject:nil];
        } else {
            [HUD hideUsingAnimation: YES];
        }
    }
    // Popular
    else if ([method isEqualToString:@"media/popular"]) {
        
        NSArray *array = (NSArray*)[result objectForKey:@"data"];
        
        [m_arrayPopular removeAllObjects];
        for (NSInteger nIndex = 0; nIndex < [array count]; nIndex++) {
            NSDictionary *dictItem = [array objectAtIndex: nIndex];
            
            NSString *strID = [dictItem objectForKey:@"id"];
            NSString *strType = [dictItem objectForKey:@"type"];
            
            if ([strType isEqualToString:@"image"] && dataKeeper.m_bImageFilter == NO) {
                continue;
            } else if ([strType isEqualToString:@"video"] && dataKeeper.m_bVideoFilter == NO) {
                continue;
            }
            
            BOOL bLiked = NO;
            
            for (NSInteger nLikeIndex = 0; nLikeIndex < [m_linked count]; nLikeIndex++) {
                NSString *strLikerID = [m_linked objectAtIndex: nLikeIndex];
                
                if ([strLikerID isEqualToString:strID]) {
                    bLiked = YES;
                    break;
                }
            }
            
            if (bLiked == YES) {
                continue;
            }
            
            [m_arrayPopular addObject: dictItem];
        }
        
        m_nScreenType = 1;
        
        if ([m_arrayPopular count] > 0) {
            [NSThread detachNewThreadSelector:@selector(showCurrentPhoto) toTarget:self withObject:nil];
        } else {
            [HUD hideUsingAnimation: YES];
        }

    }
    // My Liked
    else if ([method isEqualToString:@"users/self/media/liked"]) {
        NSArray *array = (NSArray*)[result objectForKey:@"data"];
        
        [m_linked removeAllObjects];
        
        for (NSInteger nIndex = 0; nIndex < [array count]; nIndex++) {
            NSDictionary *dictItem = [array objectAtIndex: nIndex];
            NSString *strMediaID = [dictItem objectForKey:@"id"];
            
            [m_linked addObject: strMediaID];
        }
        
        [self GetMyFollows];

    }
    // My Followings
    else if ([method isEqualToString: [NSString stringWithFormat:@"users/%@/follows", appDelegate.myID]]) {
        NSArray *array = (NSArray*)[result objectForKey:@"data"];

        [m_follows removeAllObjects];
        
        for (NSInteger nIndex = 0; nIndex < [array count]; nIndex++) {
            NSDictionary *dictItem = [array objectAtIndex: nIndex];
            [m_follows addObject: [dictItem objectForKey:@"id"]];
        }
        
        [self GetMyFeed];
        
    }
    // Follow someone
    else if ([method isEqualToString: [NSString stringWithFormat:@"users/%@/relationship", _m_strFollowerID]]) {
       // [_m_imageViewHeartIcon setHidden: NO];
        if (_m_followingBtn.selected == NO) {
            [m_follows addObject:_m_strFollowerID];
            [_m_followingBtn setSelected: YES];
        } else {
            [m_follows removeObject: _m_strFollowerID];
            [_m_followingBtn setSelected: NO];
        }
        
        [HUD hideUsingAnimation: YES];
    }
    // Like a media
    else if ([method isEqualToString: [NSString stringWithFormat:@"media/%@/likes", _m_strCurrentMediaID]]) {
        [HUD hideUsingAnimation: YES];

        [_m_imageViewHeartIcon setHidden: NO];
        
        DataKeeper *dataKeeper = [DataKeeper sharedInstance];
        
        if (dataKeeper.m_bFacebookLink == YES) {
            [self shareToFacebook];
        }
        
        if (dataKeeper.m_bTwitterLink == YES) {
            [self shareToTwitter];
        }
        
        [NSThread detachNewThreadSelector:@selector(GotoNextPhotoThread) toTarget:self withObject:nil];
    }
    // HashTag
    else if ([method isEqualToString: [NSString stringWithFormat:@"tags/%@/media/recent", _m_strCurrentHashTagName]]) {

        // Set Next Max Tag ID
        NSDictionary *dictPagination = (NSDictionary*)[result objectForKey:@"pagination"];
        [self setM_strNextMaxTagID: [dictPagination objectForKey:@"next_max_tag_id"]];

        NSArray *array = (NSArray*)[result objectForKey:@"data"];
        
        [m_arrayTrending removeAllObjects];
        
        for (NSInteger nIndex = 0; nIndex < [array count]; nIndex++) {
            NSDictionary *dictItem = [array objectAtIndex: nIndex];
             
            NSString *strID = [dictItem objectForKey:@"id"];
            NSString *strType = [dictItem objectForKey:@"type"];
            
            if ([strType isEqualToString:@"image"] && dataKeeper.m_bImageFilter == NO) {
                continue;
            } else if ([strType isEqualToString:@"video"] && dataKeeper.m_bVideoFilter == NO) {
                continue;
            }
            
            BOOL bLiked = NO;
             
             for (NSInteger nLikeIndex = 0; nLikeIndex < [m_linked count]; nLikeIndex++) {
                 NSString *strLikerID = [m_linked objectAtIndex: nLikeIndex];
                 
                 if ([strLikerID isEqualToString:strID]) {
                     bLiked = YES;
                     break;
                 }
             }
             
             if (bLiked == YES) {
                 continue;
             }
            
             [m_arrayTrending addObject: dictItem];
         }
         
         m_nScreenType = 2;
         
         if ([m_arrayTrending count] > 0) {
             NSLog(@"m_arrayTrending = %@", m_arrayTrending);
             [NSThread detachNewThreadSelector:@selector(showCurrentPhoto) toTarget:self withObject:nil];
         } else {
             [HUD hideUsingAnimation: YES];
         }
    }
    
}

#pragma mark - Social Share functions

- (void) shareToFacebook {
    CAppDelegate *appDelegate = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [FBSession setActiveSession: appDelegate.session];
    
    NSDictionary *dictItem = nil;
    
    if (m_nScreenType == 0) {
        dictItem = [m_arrayFeed objectAtIndex: m_nCurrentFeedIndex];;
    } else if (m_nScreenType == 1){
        dictItem = [m_arrayPopular objectAtIndex: m_nCurrentPopularIndex];
    } else if (m_nScreenType == 2) {
        dictItem = [m_arrayTrending objectAtIndex: m_nCurrentTrendingIndex];
    }
    
    NSString *strURL = [dictItem objectForKey: @"link"];
    
    NSLog(@"CAPTION = %@", [dictItem objectForKey:@"caption"]);
    NSDictionary *dictMsg = [dictItem objectForKey:@"caption"];
    

    NSMutableDictionary *postParams = nil;
    
    if (dictMsg == nil || [dictMsg isKindOfClass:[NSNull class]]) {
        postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:strURL, @"link", nil];
    } else {
        postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:strURL, @"link", [dictMsg objectForKey:@"text"], @"message", nil];
    }
    
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:postParams
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
        NSLog(@"Success!");
                          }];
    [postParams release];
}

- (void) shareToTwitter {
    
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            NSDictionary *dictItem = nil;
            
            if (m_nScreenType == 0) {
                dictItem = [m_arrayFeed objectAtIndex: m_nCurrentFeedIndex];;
            } else if (m_nScreenType == 1){
                dictItem = [m_arrayPopular objectAtIndex: m_nCurrentPopularIndex];
            } else if (m_nScreenType == 2) {
                dictItem = [m_arrayTrending objectAtIndex: m_nCurrentTrendingIndex];
            }
            
            NSString *strURL = [dictItem objectForKey: @"link"];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSError *returnCode = [[FHSTwitterEngine sharedEngine] postTweet:strURL];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSString *title = nil;
            NSString *message = nil;
            
            if (returnCode) {
                title = [NSString stringWithFormat:@"Error %d",returnCode.code];
                message = returnCode.domain;
            } else {
                title = @"Tweet Posted";
                message = strURL;
            }
            
            dispatch_sync(GCDMainThread, ^{
                @autoreleasepool {
                    if (returnCode) {
                        UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [av show];
                    } else {
                        NSLog(@"Twitter Post Success!!");
                    }
                }
            });
        }
    });
    
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 215;
    } else if (indexPath.row == 1) {
        return 23;
    }
    return 35;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

//UPDATE - to handle filtering
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return 4 + [m_hashTagList count] / 2;
}

//UPDATE - to handle filtering
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [[NSBundle mainBundle] loadNibNamed:@"CTrendingLogosCell" owner:self options:nil];
        return _m_trendingLogoCell;     
    } else if (indexPath.row == 1) {
        [[NSBundle mainBundle] loadNibNamed:@"CTrendingBarCell" owner:self options:nil];
        return _m_trendingBarCell;
    } else if (indexPath.row == 2) {
        [[NSBundle mainBundle] loadNibNamed:@"CMainhashCell" owner:self options:nil];
        [_m_mainhashCell.m_labelHashTag setText:@"#viewagram"];
        return _m_mainhashCell;

    } else if (indexPath.row == 3) {
        [[NSBundle mainBundle] loadNibNamed:@"CMainhashCell" owner:self options:nil];
        [_m_mainhashCell.m_labelHashTag setText:@"#viewavid"];
        return _m_mainhashCell;

    } else if (indexPath.row >= 4) {
        [[NSBundle mainBundle] loadNibNamed:@"CHashTagCell" owner:self options:nil];
        NSInteger nFirst = (indexPath.row - 4) * 2;
        NSInteger nSecond = nFirst + 1;
        
        [_m_hashtagCell.m_btnHashTag1 setTitle:[NSString stringWithFormat:@"#%@", [m_hashTagList objectAtIndex:nFirst]] forState:UIControlStateNormal];
        [_m_hashtagCell.m_btnHashTag1 setTag: nFirst + 2000];
        
        if (nSecond < [m_hashTagList count]) {
            [_m_hashtagCell.m_btnHashTag2 setTitle:[NSString stringWithFormat:@"#%@", [m_hashTagList objectAtIndex:nSecond]] forState:UIControlStateNormal];
            [_m_hashtagCell.m_btnHashTag2 setTag: nSecond + 2000];
        } else {
            [_m_hashtagCell.m_btnHashTag2 setHidden: YES];
        }
        return _m_hashtagCell;

    }

    // Get the object to display and set the value in the cell.
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        m_nCurrentTrendingIndex = 0;
        
        [self ShowLoading];
        [self GetTrending: @"viewagram"];
        
    } else if (indexPath.row == 3) {
        m_nCurrentTrendingIndex = 0;
        
        [self ShowLoading];
        [self GetTrending: @"viewavid"];
    }
    
    [_m_tableViewTrending deselectRowAtIndexPath:indexPath animated: NO];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
//    [HUD removeFromSuperview];
//    [HUD release];
}

#pragma mark -
#pragma mark Twitter Delegate
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

@end
