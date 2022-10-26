//
//  ArticleCell.h
//  NativoInfiniteScrollSample
//
//  Copyright (c) 2019 Nativo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@import NativoSDK;

@interface ArticleCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *previewTextLabel;
@property (nonatomic, weak) IBOutlet UIImageView *adImageView;
@property (nonatomic, weak) IBOutlet UILabel *sponsoredLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sponsoredIndicator;

@end
