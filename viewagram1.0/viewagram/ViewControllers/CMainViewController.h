//
//  CMainViewController.h
//  viewagram
//
//  Created by wonymini on 6/28/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "MBProgressHUD.h"
#import "CTrendingLogosCell.h"
#import "CTrendingBarCell.h"
#import "CMainhashCell.h"
#import "CHashTagCell.h"
#import "FHSTwitterEngine.h"
#import "GADBannerView.h"
#import "GADInterstitial.h"


@interface CMainViewController : UIViewController <IGRequestDelegate, MBProgressHUDDelegate, FHSTwitterEngineAccessTokenDelegate> {
    
    NSMutableArray *m_arrayFeed;
    NSMutableArray *m_arrayPopular;
    NSMutableArray *m_arrayTrending;
    NSMutableArray *m_follows;
    NSMutableArray *m_linked;
    
    NSMutableArray *m_hashTagList;
    
    NSInteger m_nCurrentFeedIndex;
    NSInteger m_nCurrentPopularIndex;
    NSInteger m_nCurrentTrendingIndex;
    
    NSInteger m_nScreenType; // If type is 0 home page, type is 1 popular, type is 2 trending
    
    NSInteger m_nTotalShowCnt;
    
    IGRequest* m_currentRequest;
    
    MBProgressHUD *HUD;
    
    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;
}

@property (retain, nonatomic) MPMoviePlayerController *m_moviePlayer;

@property (retain, nonatomic) IBOutlet UIImageView *m_imageView;
@property (retain, nonatomic) IBOutlet UIImageView *m_imageViewHeartIcon;
@property (retain, nonatomic) IBOutlet UIImageView *m_avatarBack;
@property (retain, nonatomic) IBOutlet UIImageView *m_avatarView;
@property (retain, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (retain, nonatomic) IBOutlet UITableView *m_tableViewTrending;

@property (retain, nonatomic) IBOutlet UILabel *m_labelUserName;
@property (retain, nonatomic) IBOutlet UIButton *m_followingBtn;

@property (retain, nonatomic) IBOutlet CTrendingLogosCell *m_trendingLogoCell;
@property (retain, nonatomic) IBOutlet CTrendingBarCell *m_trendingBarCell;
@property (retain, nonatomic) IBOutlet CMainhashCell *m_mainhashCell;
@property (retain, nonatomic) IBOutlet CHashTagCell *m_hashtagCell;

@property (retain, nonatomic) NSString *m_strCurrentHashTagName;
@property (retain, nonatomic) NSString *m_strNextMaxTagID;
@property (retain, nonatomic) NSString *m_strFollowerID;
@property (retain, nonatomic) NSString *m_strCurrentMediaID;

- (IBAction)onTouchSettingBtn:(id)sender;
- (IBAction)onTouchMenuBtn:(id)sender;
- (IBAction)onTouchPassBtn:(id)sender;
- (IBAction)onTouchFollowBtn:(id)sender;
- (IBAction)onTouchLikeBtn:(id)sender;

- (IBAction)onTouchLogoBtn:(id)sender;
- (IBAction)onTouchHashTagBtn:(id)sender;



@end
