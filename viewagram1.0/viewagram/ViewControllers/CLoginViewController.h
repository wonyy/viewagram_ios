//
//  CLoginViewController.h
//  viewagram
//
//  Created by wonymini on 6/28/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovingBlockContainer.h"


@interface CLoginViewController : UIViewController <IGSessionDelegate, UIScrollViewDelegate> {
    CCDirectorIOS* director_;
    MovingBlockContainer *movingBlockVC;

}

@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) NSMutableArray* slideImages;
@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic, assign) CAGradientLayer *gradient;

@property (retain, nonatomic) IBOutlet UIButton *m_btnLogin;

- (void)makePerspective;
- (IBAction)onTouchSigninBtn:(id)sender;

@end
