//
//  CSettingViewController.h
//  viewagram
//
//  Created by wonymini on 6/28/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESwitch.h"
#import "FHSTwitterEngine.h"
#import "GADBannerView.h"

@interface CSettingViewController : UIViewController {
    RESwitch *switchViewFB;
    RESwitch *switchViewTwitter;
    
    GADBannerView *bannerView_;

}

- (IBAction)onTouchNavBackBtn:(id)sender;
- (IBAction)onTouchLogoutBtn:(id)sender;
- (IBAction)onTouchPrivacy:(id)sender;
- (IBAction)onTouchTerms:(id)sender;
- (IBAction)onTouchRateourApp:(id)sender;


@end
