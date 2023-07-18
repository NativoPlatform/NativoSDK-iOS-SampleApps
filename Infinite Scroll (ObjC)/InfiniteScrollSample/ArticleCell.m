
#import "ArticleCell.h"
#import <QuartzCore/QuartzCore.h>


@interface ArticleCell()
@end

@implementation ArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self setAlphaAll:self];
}

- (void)setAlphaAll:(UIView *)view {
    for (UIView *subview in view.subviews) {
        subview.alpha = 0.90f;
        [self setAlphaAll:subview];
    }
}

- (void)prepareForReuse {
    self.adImageView.image = nil;
    [super prepareForReuse];
}

@end
