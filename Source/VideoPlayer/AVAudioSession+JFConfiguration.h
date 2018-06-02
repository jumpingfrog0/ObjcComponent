//
//  AVAudioSession+JFConfiguration.h
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

#import <AVFoundation/AVFoundation.h>

@interface AVAudioSession (MZDConfiguration)

// runtime 属性, 用来保存每次插拔音频输出设备时, 当前的 port override (外放还是听筒)
- (void)setPortOverride:(AVAudioSessionPortOverride)portOverride ;
- (AVAudioSessionPortOverride)portOverride;

- (BOOL)isMuteButtonEnabled;
- (void)setMuteButtonEnabled:(BOOL)enabled;

- (void)initSession;
- (void)resetConfig;
- (void)changeConfig;

- (void)changeAudioRouteToSpeaker;
- (void)changeAudioRouteToReceiver;

- (BOOL)isReceiverAvailable;
- (BOOL)hasHeadset;

@end
