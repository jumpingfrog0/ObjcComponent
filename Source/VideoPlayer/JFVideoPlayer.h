//
//  JFVideoPlayer.h
//  ObjcComponent
//
//  Created by jumpingfrog0 on 2018/06/01.
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

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class JFVideoPlayer;

@protocol JFVideoPlayerDelegate <NSObject>
@optional
- (void)videoPlayerDidStartToPlay:(JFVideoPlayer *)player;

- (void)videoPlayer:(JFVideoPlayer *)player traceToCurrentTime:(Float64)currentTime totalTime:(Float64)totalTime;

- (void)videoPlayerDidPlayToEnd:(JFVideoPlayer *)player;

- (void)videoPlayerDidDestroy;
@end

@interface JFVideoPlayer : NSObject
@property(nonatomic, strong, readonly) UIView         *preview;
@property(nonatomic, assign, getter = isLooping) BOOL looping;
@property(nonatomic, assign) CMTimeRange              timeRange;

@property(nonatomic, weak) id <JFVideoPlayerDelegate> delegate;

- (void)showInWindowFullScreen;

- (void)playVideoWithURL:(NSURL *)url looping:(BOOL)looping;

- (void)setURL:(NSURL *)url mute:(BOOL)mute;

- (void)setFullScreen;

/**
 * 播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

- (void)reset;

/**
 * 数据是否有效，是否可以开始播放
 */
- (BOOL)isReadyToPlay;

@end

