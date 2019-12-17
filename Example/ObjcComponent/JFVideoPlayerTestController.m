//
//  JFVideoPlayerTestController.m
//  ObjcComponent
//
//  Created by sheldon on 01/06/2018.
//  Copyright © 2018 jumpingfrog0. All rights reserved.
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
