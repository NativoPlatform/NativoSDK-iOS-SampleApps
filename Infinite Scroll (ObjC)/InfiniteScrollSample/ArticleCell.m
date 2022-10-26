
#import "ArticleCell.h"
#import <QuartzCore/QuartzCore.h>


@interface ArticleCell()
@end

@implementation ArticleCell

- (void)prepareForReuse {
    self.adImageView.image = nil;
    [super prepareForReuse];
}

@end
