//
//  JFVideoPlayerTestController.m
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

#import "JFVideoPlayerTestController.h"
#import "JFVideoPlayer.h"
#import "JFVideoPlayView.h"

@interface JFVideoPlayerTestController ()
@property (weak, nonatomic) IBOutlet UIView *videoPreview;
@property (nonatomic, strong) JFVideoPlayer *player;
@end

@implementation JFVideoPlayerTestController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player reset];
}

- (IBAction)playNoUI:(id)sender {
    JFVideoPlayer *player = [[JFVideoPlayer alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://v3-dy-x.ixigua.com/30d4b71dbdfee4692aa2131c3d22524f/5df8ed39/video/n/tosedge-tos-agsy-ve-0015/9f7ad81060a045e1925d9de915896ed4/"];
    [player setURL:url mute:NO];
    player.looping = YES;
    [player showInWindowFullScreen];
}

- (IBAction)playWithUI:(id)sender {
    JFVideoPlayView *playView = [[JFVideoPlayView alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://v3-dy-x.ixigua.com/30d4b71dbdfee4692aa2131c3d22524f/5df8ed39/video/n/tosedge-tos-agsy-ve-0015/9f7ad81060a045e1925d9de915896ed4/"];
    [playView setURL:url mute:NO];
    [playView showInWindowFullScreen];
}

- (IBAction)playNoFullScreen:(id)sender {
    JFVideoPlayer *player = [[JFVideoPlayer alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://v3-dy-x.ixigua.com/30d4b71dbdfee4692aa2131c3d22524f/5df8ed39/video/n/tosedge-tos-agsy-ve-0015/9f7ad81060a045e1925d9de915896ed4/"];
    [player setURL:url mute:NO];
    player.looping = YES;
    player.preview.frame = self.videoPreview.frame;
    [self.view addSubview:player.preview];
    [player play];
    self.player = player;
}

@end
