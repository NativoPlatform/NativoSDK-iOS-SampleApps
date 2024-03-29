
#import "ArticleListViewController.h"
#import "ArticleCell.h"
#import "SponsoredLandingPageViewController.h"
#import "AppDelegate.h"
#import "ArticleViewController.h"
#import "NativoStandardDisplayView.h"
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
@import AppTrackingTransparency;


// Nativo Settings
static NSString * const ArticleCellIdentifier = @"articlecell";
static NSString * const VideoCellIdentifier = @"videocell";
static NSString * const NativoSectionUrl = @"http://www.publisher.com/test";

// Define the frequency of Ad cells for infinite scroll
#define AD_ROW_START 2
#define AD_ROW_INTERVAL 4

@interface ArticleListViewController () <UITableViewDataSource, UITableViewDelegate, NtvSectionDelegate>
@property (nonatomic) NSCache *feedImgCache;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *articlesDataSource;
@property (nonatomic) int numAdsReceived;
@property (nonatomic) int adInjectRow;
@end

@implementation ArticleListViewController


#pragma mark - Initialization methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    [self setupNavBar];
    [self startArticleFeed];
    
    // Make sure app is active before requestion advertiser tracking (IDFA)
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self requestTracking];
    } else {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self requestTracking];
        }];
    }
}

- (void)requestTracking {
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        // Tracking authorization completed. Start loading ads here.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startNativo];
        });
    }];
}

- (void)startNativo {
    self.adInjectRow = 1;
    
    // Enable Test Nativo Test & Debug mode
    [NativoSDK enableDevLogs];
    [NativoSDK enableTestAdvertisements];

    // Setup Section
    [NativoSDK setSectionDelegate:self forSection:NativoSectionUrl];
    
    // Register Nativo template types using Nib files
    [NativoSDK registerNib:[UINib nibWithNibName:@"ArticleNativeAdView" bundle:nil] forAdTemplateType:NtvAdTemplateTypeNative];
    [NativoSDK registerNib:[UINib nibWithNibName:@"ArticleVideoAdView" bundle:nil] forAdTemplateType:NtvAdTemplateTypeVideo];
    [NativoSDK registerNib:[UINib nibWithNibName:@"SponsoredLandingPageViewController" bundle:nil] forAdTemplateType:NtvAdTemplateTypeLandingPage];
    [NativoSDK registerClass:[NativoStandardDisplayView class] forAdTemplateType:NtvAdTemplateTypeStandardDisplay];
    
    // Cell used as nativo ad container
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"nativocell"];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check if this item should be a Nativo ad placement
    UITableViewCell *cell = nil;
    NSDictionary *itemForIndex = self.articlesDataSource[indexPath.row];
    if ([itemForIndex[@"title"] isEqual:@"Nativo"]) {
        // Use NativoSDK to create ad unit
        cell = [tableView dequeueReusableCellWithIdentifier:@"nativocell"];
        BOOL didPlaceAd = [NativoSDK placeAdInView:cell atLocationIdentifier:indexPath inContainer:tableView forSection:NativoSectionUrl options:nil];
        if (didPlaceAd) {
            [self unCollapseCell:cell];
        } else {
            [self collapseCell:cell];
        }
    } else {
        // Create article cell as normal
        cell = [tableView dequeueReusableCellWithIdentifier:ArticleCellIdentifier];
        NSDictionary *feedItem = self.articlesDataSource[indexPath.row];
        [self populateCell:(ArticleCell *)cell withData:feedItem];
    }
    
    // Load next set of rows if needed
    if (indexPath.row == self.articlesDataSource.count-1) {
        [self getNextFeedItems];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articlesDataSource.count;
}

- (void)collapseCell:(UITableViewCell *)cell {
    cell.hidden = YES;
    NSLayoutConstraint *height = [cell.contentView.heightAnchor constraintEqualToConstant:0];
    height.identifier = @"height";
    height.active = YES;
}

- (void)unCollapseCell:(UITableViewCell *)cell {
    cell.hidden = NO;
    for (NSLayoutConstraint *constraint in cell.contentView.constraints) {
        if ([constraint.identifier isEqualToString:@"height"]) {
            constraint.active = NO;
        }
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Ask the NativoSDK for adjusted indexpath in order to get the correct data for the row.
    NSIndexPath *adAdjustedIndexPath = [NativoSDK getAdjustedIndexPath:indexPath forAdsInjectedInSection:NativoSectionUrl inContainer:tableView];
    
    NSDictionary *feedItem = [self.articlesDataSource objectAtIndex:adAdjustedIndexPath.row];
    ArticleViewController *article = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil];
    NSString *articleUrlStr = [NSString stringWithFormat:@"https://www.nativo.com%@", feedItem[@"fullUrl"]];
    article.articleURL = [NSURL URLWithString:articleUrlStr];
    [self.navigationController pushViewController:article animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - NtvSectionDelegate Methods

- (void)section:(nonnull NSString *)sectionUrl didReceiveAd:(BOOL)didGetFill {
    if (didGetFill && self.articlesDataSource.count > self.adInjectRow) {
        [self.articlesDataSource insertObject:@{@"title": @"Nativo"} atIndex:self.adInjectRow];
        NSIndexPath *idx = [NSIndexPath indexPathForRow:self.adInjectRow inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.adInjectRow += AD_ROW_INTERVAL;
    }
}

- (void)section:(nonnull NSString *)sectionUrl didAssignAd:(nonnull NtvAdData *)adData toLocation:(nonnull id)location container:(nonnull UIView *)container {
    
}

- (void)section:(nonnull NSString *)sectionUrl didFailAdAtLocation:(nullable id)identifier inView:(nullable UIView *)view withError:(nullable NSString *)errMsg container:(nullable UIView *)container {
    if (identifier) {
        NSIndexPath *indexPath = (NSIndexPath *)identifier;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    // Initialize article feed if Nativo fails
    if (self.articlesDataSource.count == 0) {
        [self startArticleFeed];
    }
}


- (void)section:(NSString *)sectionUrl needsDisplayLandingPage:(nullable UIViewController *)sponsoredLandingPageViewController {
    //Push the sponsored landing page to the navigationController
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


#pragma mark - Feed Request

- (void)startArticleFeed {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"nativoblog" ofType:@"json"];
    NSData *feedData = [NSData dataWithContentsOfFile:filePath options:0 error:nil];
    NSDictionary *feed = [NSJSONSerialization JSONObjectWithData:feedData options:0 error:nil];
    NSArray *feedItems = feed[@"items"];
    [self.articlesDataSource addObjectsFromArray:feedItems];
    [self.tableView reloadData];
}

- (void)getNextFeedItems {
    [self.articlesDataSource addObjectsFromArray:[self.articlesDataSource copy]];
    [self.tableView reloadData];
}


#pragma mark - Misc

- (void)populateCell:(ArticleCell *)cell withData:(NSDictionary *)feedItem {
    cell.titleLabel.text = feedItem[@"title"];
    cell.dateLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    cell.authorNameLabel.text = feedItem[@"author"];
    cell.previewTextLabel.text = feedItem[@"excerpt"];
    
    // async fetch image
    NSString *imgStr = feedItem[@"assetUrl"];
    [self getAsyncImageForUrl:[NSURL URLWithString:imgStr] completion:^(UIImage *img) {
        if (img && [cell.titleLabel.text isEqualToString:feedItem[@"title"]]) {
            cell.adImageView.image = img;
        }
    }];
}

- (void)setupNavBar {
    UIImageView *ntvLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [ntvLogoView setContentMode:UIViewContentModeScaleAspectFit];
    [ntvLogoView setImage:[UIImage imageNamed:@"AppIcon"]];
    self.navigationItem.titleView = ntvLogoView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)]];

    UIMenu *privacyMenu = [UIMenu menuWithTitle:@"Privacy Consent" children:@[
        [UIAction actionWithTitle:@"Give Consent" image:[UIImage systemImageNamed:@"plus"] identifier:@"give" handler:^(__kindof UIAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setObject:@"BOXjEnFOXjEnFAKALBENB5-AAAAid7_______9______9uz_Gv_v_f__33e8__9v_l_7_-___u_-33d4-_1vf99yfm1-7ftr3tp_87ues2_Xur_959__3z3_EA" forKey:@"IABTCF_TCString"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1YNY" forKey:@"IABUSPrivacy_String"];
        }],
        [UIAction actionWithTitle:@"Remove Consent" image:[UIImage systemImageNamed:@"minus"] identifier:@"remove" handler:^(__kindof UIAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"IABTCF_TCString"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1NNN" forKey:@"IABUSPrivacy_String"];
        }]
    ]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"hand.raised"] menu:privacyMenu];
}

- (void)getAsyncImageForUrl:(NSURL *)url completion:(void (^)(UIImage *img))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (!self.feedImgCache) {
            self.feedImgCache = [[NSCache alloc] init];
        }
        UIImage *img = [self.feedImgCache objectForKey:url];
        if (img) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(img);
            });
            return;
        }
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imgData];
        if (image) {
            [self.feedImgCache setObject:image forKey:url]; // Set image on cache
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            block(image);
        });
    });
}

- (void) setupView {
    self.articlesDataSource = [NSMutableArray array];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50.0f)];
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    loadingIndicator.center = footerView.center;
    [footerView addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    [self.tableView setTableFooterView:footerView];
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        // Create date formatter for later
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return _dateFormatter;
}

@end
