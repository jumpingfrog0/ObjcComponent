//
//  JFVideoPlayer.m
//  ObjcComponent
//
//  Created by jumpingfrog0 on 01/06/2018.
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

#import <CoreMedia/CoreMedia.h>
#import "JFVideoPlayer.h"
#import "AVAudioSession+JFConfiguration.h"

@interface JFVideoPlayer ()
@property(nonatomic, strong) AVPlayer     *player;
@property(nonatomic, strong) AVPlayerItem *playerItem;
@property(nonatomic, weak) AVPlayerLayer  *playerLayer;
@property(nonatomic, strong) NSURL        *url;

@property(nonatomic, assign) BOOL isPlayToEnd;
@property(nonatomic, assign) BOOL mute;
@property(nonatomic, assign) BOOL isFullScreen;
@property(nonatomic, assign) BOOL isPlaying;

@property(nonatomic, weak) NSTimer *timer;
@end

@implementation JFVideoPlayer

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        self.player                   = [[AVPlayer alloc] init];
        self.playerLayer              = [AVPlayerLayer playerLayerWithPlayer:_player];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;

        _preview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_preview.layer addSublayer:self.playerLayer];
        [self addObserverAndNotification];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"JFVideoPlayer -- dealloc");
}

#pragma mark - Show

- (void)showInWindowFullScreen {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.preview.frame        = window.bounds;
    self.isFullScreen = YES;
    [self addTapGesture];
    [window addSubview:self.preview];
}

#pragma mark - logic

- (void)setTimeRange:(CMTimeRange)timeRange {
    _timeRange = timeRange;

    if ([self isReadyToPlay]) {
        [self handleTimeRangeAction];
    }
}

- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [self.preview addGestureRecognizer:tapGesture];
}

- (void)handleTapAction:(UITapGestureRecognizer *)recognizer {
    if (self.isFullScreen) {
        self.isFullScreen = NO;
        [self reset];
        [self.preview removeFromSuperview];

        if ([self.delegate respondsToSelector:@selector(videoPlayerDidDestroy)]) {
            [self.delegate videoPlayerDidDestroy];
        }
    }
}

// 进入后台
- (void)resignActiveNotification {
    [self pause];
}

// 进入前台
- (void)becomeActiveNotification {
    [self play];
}

// 来电中断
- (void)handleAudioSessionInterruption:(NSNotification *)notification {

    NSNumber *interruptionType   = [notification userInfo][AVAudioSessionInterruptionTypeKey];
    NSNumber *interruptionOption = [notification userInfo][AVAudioSessionInterruptionOptionKey];

    switch (interruptionType.unsignedIntegerValue) {
        case AVAudioSessionInterruptionTypeBegan: {
            // 来电中断，暂停播放
            [self.playerItem seekToTime:kCMTimeZero];
            [self pause];
        }
            break;
        case AVAudioSessionInterruptionTypeEnded: {
            if (interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                // 来电结束, 开始播放
                [self play];
            }
        }
            break;
        default:
            break;
    }
}

// 声音输出设备改变通知
- (void)sessionRouteChanged:(NSNotification *)notification {
    [self changeAudioRoute];

    // 修复拔出耳机后视频暂停的问题
    if (!self.isPlayToEnd) {
        [self.player play];
    }
}

- (void)changeAudioRoute {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 短视频不插耳机的情况下，不受听筒模式影响
    // 扬声器模式: 没戴耳机使用扬声器播放, 戴了耳机使用听筒播放
    if ([session hasHeadset]) {
        [session changeAudioRouteToReceiver];
    } else {
        [session changeAudioRouteToSpeaker];
    }
}

- (void)resetAudioRoute {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session hasHeadset]) {
        [session changeAudioRouteToReceiver];
    }
}

- (void)initPlayer {
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:self.url options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    self.timeRange = CMTimeRangeMake(kCMTimeZero, self.playerItem.duration);
    self.isPlaying = NO;

    [self addTimer];
    [self addObserverForStatus];
    [[AVAudioSession sharedInstance] setMuteButtonEnabled:NO];
}

- (void)setFullScreen {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.preview.frame        = window.bounds;
    self.isFullScreen = YES;
    [self addTapGesture];
}

- (void)setURL:(NSURL *)url mute:(BOOL)mute {
    self.url  = url;
    self.mute = mute;

    [self initPlayer];
}

- (void)addObserverForStatus {
    [self.playerItem addObserver:self
                      forKeyPath:@"status"
                         options:NSKeyValueObservingOptionNew
                         context:@"JFVideoPlayer_playerItem_status_context"];
}

- (void)addObserverAndNotification {
    [self.preview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:"JFVideoPlayer_preview_frame_context"];
    [self addNotification];
}

- (void)addNotification {
    // 给 AVPlayerItem 添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    // 后台&前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActiveNotification)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    // 来电通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioSessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    // 声音输出设备改变通知（插入、拔出耳机）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionRouteChanged:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reset {
    [[AVAudioSession sharedInstance] resetConfig];
    [self resetAudioRoute];
    [self pause];
    [self removeNotification];
    [self removeTimer];

    [self.playerItem removeObserver:self forKeyPath:@"status" context:@"JFVideoPlayer_playerItem_status_context"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.playerItem = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.player      = nil;
}

- (void)playFinished:(NSNotification *)notification {
    self.playerItem = notification.object;

    [self.playerItem seekToTime:kCMTimeZero];
    self.isPlayToEnd = YES;
    self.isPlaying   = NO;

    if (!self.isLooping) {
        [self pause];
        if ([self.delegate respondsToSelector:@selector(videoPlayerDidPlayToEnd:)]) {
            [self.delegate videoPlayerDidPlayToEnd:self];
        }
    } else {
        // 在前台时循环播放
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            [self handleTimeRangeAction];
        }
    }
}

- (void)play {
    if (self.isPlaying) {
        return;
    }

    self.isPlaying      = YES;
    if ([self.delegate respondsToSelector:@selector(videoPlayerDidStartToPlay:)]) {
        [self.delegate videoPlayerDidStartToPlay:self];
    }

    [[AVAudioSession sharedInstance] changeConfig];
    [self changeAudioRoute];

    self.player.muted = self.mute;
    self.isPlayToEnd  = NO;

    [self.player play];
    self.timer.fireDate = [NSDate date];
}

- (void)playVideoWithURL:(NSURL *)url looping:(BOOL)looping {
    [self setURL:url mute:NO];
    self.looping = looping;
}

- (void)pause {
    [self.player pause];
    self.timer.fireDate = [NSDate distantFuture];
    self.isPlaying      = NO;
}

- (void)handleTimeRangeAction {
    [self pause];
    if (self.looping) {
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:self.timeRange.start toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            if ([weakSelf.delegate respondsToSelector:@selector(videoPlayerDidStartToPlay:)]) {
                [weakSelf.delegate videoPlayerDidStartToPlay:weakSelf];
            }
            if ([weakSelf.delegate respondsToSelector:@selector(videoPlayer:traceToCurrentTime:totalTime:)]) {
                [weakSelf.delegate videoPlayer:weakSelf traceToCurrentTime:CMTimeGetSeconds(weakSelf.timeRange.start) totalTime:weakSelf.playerItem.duration.value];
            }
            [weakSelf play];
        }];
    }
}

- (BOOL)isReadyToPlay {
    return self.playerItem.status == AVPlayerStatusReadyToPlay;
}

- (void)addTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(traceTimerAction:) userInfo:nil repeats:YES];
    }
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)traceTimerAction:(NSTimer *)timer {
    if ([self playerItem].duration.timescale != 0) {

        Float64 currentTime       = CMTimeGetSeconds(self.player.currentTime);
        Float64 totalTime         = self.playerItem.duration.value / self.playerItem.duration.timescale;
        Float64 timeRangeStart    = CMTimeGetSeconds(self.timeRange.start);
        Float64 timeRangeDuration = CMTimeGetSeconds(self.timeRange.duration);

//        NSLog(@"%f --%f -- %f", currentTime, timeRangeStart, timeRangeDuration);

        if (currentTime - timeRangeStart > timeRangeDuration) {
            [self handleTimeRangeAction];
        } else {
            if ([self.delegate respondsToSelector:@selector(videoPlayer:traceToCurrentTime:totalTime:)]) {
                [self.delegate videoPlayer:self traceToCurrentTime:currentTime totalTime:totalTime];
            }
        }
    }
}

#pragma mark - KVO - status

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *) object;
    if ([keyPath isEqualToString:@"status"]) {
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            // 视频可以播放后再设置背景为黑色
            self.preview.backgroundColor = [UIColor blackColor];

            [self play];
        } else if (item.status == AVPlayerItemStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        } else {
            NSLog(@"AVPlayerStatusUnknown");
        }
    } else if ([keyPath isEqualToString:@"frame"]) {
        self.playerLayer.frame = self.preview.bounds;
    }
}
@end
