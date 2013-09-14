//
//  CLinkAccountViewController.h
//  viewagram
//
//  Created by wonymini on 7/3/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLinkAccountViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIScrollView *m_scrollView;

- (IBAction)onTouchSkipBtn:(id)sender;
- (IBAction)onTouchLinkFBAccount:(id)sender;

@end
