// JFVideoPlayView.h
// ObjcComponent
//
// Created by sheldon on 02/06/2018.
// Copyright (c) 2018 jumpingfrog0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JFVideoPlayer;

@interface JFVideoPlayView : UIView
- (void)setURL:(NSURL *)url mute:(BOOL)mute;
- (void)showInWindowFullScreen;
@end