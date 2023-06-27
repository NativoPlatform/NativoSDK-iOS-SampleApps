//
//  ArticleVideoAdView.h
//  NativoInfiniteScrollSample
//
//  Copyright (c) 2019 Nativo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@import NativoSDK;

@interface ArticleVideoAdView : UIView <NtvVideoAdInterface, NtvVideoEventListener>

@property (nonatomic, weak) IBOutlet UIView *videoView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *authorImageView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIView *adChoicesIconView;

@end
