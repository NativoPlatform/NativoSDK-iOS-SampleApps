
#import "ArticleVideoAdView.h"
#import <AVFoundation/AVFoundation.h>

@implementation ArticleVideoAdView

- (void)videoPlayer:(nonnull id<NtvVideoPlayer>)player stateChanged:(NtvVideoState)state {
    
}

- (void)videoPlayer:(nonnull id<NtvVideoPlayer>)player didExitFullScreenWithAd:(nonnull NtvAdData *)adData {
    
}

- (void)videoPlayer:(nonnull id<NtvVideoPlayer>)player didFailWithError:(nullable NSError *)error withAd:(nonnull NtvAdData *)adData {
    
}

- (void)videoPlayer:(nonnull id<NtvVideoPlayer>)player didGoFullScreenWithAd:(nonnull NtvAdData *)adData {
    
}

- (void)videoPlayer:(nonnull id<NtvVideoPlayer>)player learnMoreClicked:(nonnull NtvAdData *)adData {
    
}

- (void)videoPlayer:(nonnull id<NtvVideoPlayer>)player progressChanged:(long)progress withAd:(nonnull NtvAdData *)adData {
    
}

- (BOOL)videoPlayer:(nonnull id<NtvVideoPlayer>)player shouldDeactiveAudioSessionWithReason:(nonnull NSString *)reason {
    return YES;
}

- (BOOL)videoPlayer:(nonnull id<NtvVideoPlayer>)player shouldModifyAudioSessionCategory:(nonnull NSString *)category withReason:(nonnull NSString *)reason {
    return YES;
}

@end
