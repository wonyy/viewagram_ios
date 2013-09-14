//
//  CPrivacyViewController.h
//  viewagram
//
//  Created by wonymini on 7/1/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"


@interface CPrivacyViewController : UIViewController {
    GADBannerView *bannerView_;
}

@property (retain, nonatomic) IBOutlet UIWebView *m_webView;

- (IBAction)onTouchNavBackBtn:(id)sender;



@end
