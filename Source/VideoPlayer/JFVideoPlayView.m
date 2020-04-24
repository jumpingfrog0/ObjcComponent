//
//  JFVideoPlayView.m
//  ObjcComponent
//
//  Created by jumpingfrog0 on 2018/06/02.
//
//
//  Copyright (c) 2017 Jumpingfrog0 LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].delegate.window;
    }
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
