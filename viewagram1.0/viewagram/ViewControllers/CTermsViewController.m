//
//  CTermsViewController.m
//  viewagram
//
//  Created by wonymini on 7/1/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import "CTermsViewController.h"

@interface CTermsViewController ()

@end

@implementation CTermsViewController


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

    
    _m_webView.backgroundColor = [UIColor colorWithRed:148.0/256.0 green:148.0/256.0 blue:148.0/256.0 alpha:0.0];
	_m_webView.opaque = YES;
    
	// get localized path for file from app bundle
	NSString *path;
	NSBundle *thisBundle = [NSBundle mainBundle];
	path = [thisBundle pathForResource:@"terms" ofType:@"htm"];
    
	// make a file: URL out of the path
	NSURL *instructionsURL = [NSURL fileURLWithPath:path];
	[_m_webView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_webView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setM_webView:nil];
    [super viewDidUnload];
}

#pragma mark - WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}

#pragma mark - Actions
- (IBAction)onTouchNavBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}
@end
