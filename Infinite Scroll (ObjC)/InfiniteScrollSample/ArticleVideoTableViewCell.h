//
//  ArticleVideoTableViewCell.h
//  NativoInfiniteScrollSample
//
//  Created by Matthew Murray on 8/19/19.
//  Copyright © 2019 Nativo. All rights reserved.
//

#import <UIKit/UIKit.h>

@import NativoSDK;

NS_ASSUME_NONNULL_BEGIN

@interface ArticleVideoTableViewCell : UITableViewCell <NtvVideoAdInterface, NtvVideoEventListener>

@property (nonatomic, weak) IBOutlet UIView *videoView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *authorImageView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIView *adChoicesIconView;

@end

NS_ASSUME_NONNULL_END
