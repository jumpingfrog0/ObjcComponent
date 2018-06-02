// JFVideoPlayView.m
// ObjcComponent
//
// Created by sheldon on 02/06/2018.
// Copyright (c) 2018 jumpingfrog0. All rights reserved.
//

#import "JFVideoPlayView.h"
#import "JFVideoPlayer.h"

@interface JFVideoPlayView () <JFVideoPlayerDelegate>
@property (nonatomic, strong) JFVideoPlayer *player;
@property(nonatomic, strong) UIButton     *replayButton;
@end

@implementation JFVideoPlayView
- (instancetype)initWithFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = [UIScreen mainScreen].bounds;
    }
    if (self = [super initWithFrame:frame]) {
        _player = [[JFVideoPlayer alloc] init];
        _player.delegate = self;
        [self addSubview:self.player.preview];
        [self sendSubviewToBack:self.player.preview];
        [self addSubview:self.replayButton];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ -- dealloc", [self class]);
}

- (void)setURL:(NSURL *)url mute:(BOOL)mute {
    [self.player setURL:url mute:mute];
}

- (void)showInWindowFullScreen {
    [self.player setFullScreen];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.replayButton.center = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height * 0.5f);
}

#pragma mark - action

- (void)replayButtonOnClicked {
    [self.player play];
}

#pragma mark - JFVideoPlayerDelegate
- (void)videoPlayerDidStartToPlay:(JFVideoPlayer *)player {
    self.replayButton.hidden = YES;
}

- (void)videoPlayerDidPlayToEnd:(JFVideoPlayer *)player {
    self.replayButton.hidden = NO;
}

- (void)videoPlayerDidDestroy {
    [self removeFromSuperview];
}

#pragma mark - UI

- (UIButton *)replayButton {
    if (!_replayButton) {
        _replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replayButton setImage:[UIImage imageNamed:@"JFVideoPlayer.bundle/video_replay_button"] forState:UIControlStateNormal];
        [_replayButton addTarget:self
                          action:@selector(replayButtonOnClicked)
                forControlEvents:UIControlEventTouchUpInside];
        _replayButton.frame  = CGRectMake(0, 0, 61, 61);
        _replayButton.hidden = YES;
    }
    return _replayButton;
}
@end
