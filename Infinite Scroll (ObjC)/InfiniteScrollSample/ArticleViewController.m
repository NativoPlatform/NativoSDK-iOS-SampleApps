
#import "ArticleViewController.h"

@import NativoSDK;

@interface ArticleViewController () <WKNavigationDelegate, NtvSectionDelegate>
@property (nonatomic) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *nativoAdView;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

NSString * const SECTION_URL = @"nativo.net/bottomofarticle";


@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.articleURL) {
        self.webView.navigationDelegate = self;
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.articleURL]];
        self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loadingView.center = self.webView.center;
        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimating];
    }
}

- (void)dealloc {
    [self.webView stopLoading];
}

#pragma mark - WKWebViewNavigation

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.loadingView stopAnimating];
    [self.webView expandWebViewToFitContents];
    
    // Wait for webview to finish load before requesting ad
    if (self.nativoAdView.subviews.count == 0) {
        [NativoSDK setSectionDelegate:self forSection:SECTION_URL];
    }
}

#pragma mark - NtvSectionDelegate Methods

- (NSString *)section:(NSString *)sectionUrl registerNibNameForAdTemplateType:(NtvAdTemplateType)templateType atLocationIdentifier:(id)locationIdentifier {
    switch (templateType) {
        case NtvAdTemplateTypeNative:
            return @"ArticleNativeAdView";
            
        case NtvAdTemplateTypeVideo:
            return @"ArticleVideoAdView";
            
        default:
            return nil;
    }
}

- (void)section:(NSString *)sectionUrl needsRemoveAdViewAtLocation:(id)identifier {
    // Set height to 0 instead of remove (If removed from parent view you will need to reapply autolayout constraints)
    [self.nativoAdView.heightAnchor constraintEqualToConstant:0].active = YES;
    NSLog(@"Removing Nativo ad view");
}


- (void)section:(NSString *)sectionUrl needsDisplayLandingPage:(UIViewController<NtvLandingPageInterface> *)sponsoredLandingPageViewController {
    [self.navigationController pushViewController:sponsoredLandingPageViewController animated:YES];
}

- (void)section:(NSString *)sectionUrl needsDisplayClickoutURL:(NSURL *)url {
    // Load click-out url in WKWebView
    UIViewController *clickoutAdVC = [[UIViewController alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:clickoutAdVC.view.frame];
    [clickoutAdVC.view addSubview:webView];
    NSURLRequest *clickoutReq = [NSURLRequest requestWithURL:url];
    [webView loadRequest: clickoutReq];
    [self.navigationController pushViewController:clickoutAdVC animated:YES];
}

- (void)section:(nonnull NSString *)sectionUrl didAssignAd:(nonnull NtvAdData *)adData toLocation:(nonnull id)identifier container:(nonnull UIView *)container {
    
}


- (void)section:(nonnull NSString *)sectionUrl didFailAdAtLocation:(nullable id)identifier inView:(nullable UIView *)view withError:(nullable NSString *)errMsg container:(nullable UIView *)container {
    [self.nativoAdView.heightAnchor constraintEqualToConstant:0].active = YES;
    NSLog(@"Removing Nativo ad view");
}

- (void)section:(nonnull NSString *)sectionUrl didReceiveAd:(BOOL)didGetFill {
    if (didGetFill) {
        [NativoSDK placeAdInView:self.nativoAdView atLocationIdentifier:self.articleURL inContainer:self.scrollView forSection:sectionUrl options:nil];
    }
}




@end
