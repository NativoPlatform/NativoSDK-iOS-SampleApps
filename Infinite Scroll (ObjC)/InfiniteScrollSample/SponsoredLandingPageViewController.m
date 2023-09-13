
#import "SponsoredLandingPageViewController.h"


@interface SponsoredLandingPageViewController ()
@property (nonatomic) UIBarButtonItem *shareButton;
@property (nonatomic) NtvAdData *adData;
@end

@implementation SponsoredLandingPageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Sponsored Article";
    
    //Create the share button
    self.shareButton = [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                        target:self
                        action:@selector(shareButtonTouched)];
    self.navigationItem.rightBarButtonItem = self.shareButton;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nativoWebView stopLoadingNativo];
}

-(void)shareButtonTouched {
    NSString *socialUrl = self.shareUrl;
    
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[socialUrl] applicationActivities:nil];
    avc.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        
        NtvSharePlatform sharePlatform = NtvSharePlatformOther;
        if ([activityType isEqualToString:UIActivityTypePostToFacebook] ) {
            sharePlatform = NtvSharePlatformFacebook;
        } else if ([activityType isEqualToString: UIActivityTypePostToTwitter]) {
            sharePlatform = NtvSharePlatformTwitter;
        }
        self.trackDidShare(sharePlatform);
    };
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    [rootVC presentViewController:avc animated:YES completion:nil];
}


#pragma mark - NtvLandingPageInterface

- (void)didLoadContentWithAd:(NtvAdData *)adData {
    self.adData = adData;
}

- (NtvContentWebView *)contentWKWebView {
    return self.nativoWebView;
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    return [dateFormatter stringFromDate:date];
}

- (void)handleExternalLink:(NSURL *)link {
    // Load click-out url in WKWebView
    UIViewController *clickoutAdVC = [[UIViewController alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:clickoutAdVC.view.frame];
    [clickoutAdVC.view addSubview:webView];
    NSURLRequest *clickoutReq = [NSURLRequest requestWithURL:link];
    [webView loadRequest: clickoutReq];
    [self.navigationController pushViewController:clickoutAdVC animated:YES];
}


@end
