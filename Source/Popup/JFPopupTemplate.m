//
//  JFPopupTemplate.m
//  ObjcComponent
//
//  Created by jumpingfrog0 on 2020/04/26.
//
//
//  Copyright (c) 2020 Jumpingfrog0 LLC
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

#import "JFPopupTemplate.h"
#import <Masonry/Masonry.h>
#import <JFUIKit/JFUIKit.h>

@interface JFPopupTemplate ()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *whiteCardView;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation JFPopupTemplate

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _allowDismissOnTapMask = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)dealloc {
    
}

+ (void)show {
    JFPopupTemplate *popup = [[JFPopupTemplate alloc] init];
    [popup show];
}

- (void)show {
    UIView *superview = [UIView jf_getCurrentWindow];
    [superview addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview).insets(UIEdgeInsetsZero);
    }];
    
    self.whiteCardView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.whiteCardView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}

- (void)close {
    [self dismiss];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)onConfirm:(UIButton *)sender {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (void)onTapMask:(UITapGestureRecognizer *)recognizer {
    if (self.allowDismissOnTapMask) {
        [self close];
    }
}

#pragma mark - UI

- (void)setupSubviews {
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];

    [self addSubview:self.whiteCardView];
    [self.whiteCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(38);
        make.right.equalTo(self).offset(-38);
        make.height.mas_equalTo(417);
        make.centerY.equalTo(self);
    }];
    
    [self.whiteCardView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteCardView).offset(15);
        make.right.equalTo(self.whiteCardView).offset(-15);
        make.height.mas_equalTo(46);
        make.bottom.equalTo(self.whiteCardView).offset(-18);
    }];
    
    [self.whiteCardView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteCardView).offset(13);
        make.centerX.equalTo(self.whiteCardView);
    }];
    
    [self.whiteCardView addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.whiteCardView);
    }];
    
    [self.whiteCardView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
        make.top.equalTo(self.whiteCardView).offset(8);
        make.right.equalTo(self.whiteCardView).offset(-8);
    }];
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor jf_colorFromHex:0x000000 alpha:0.6];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMask:)];
        [_maskView addGestureRecognizer:tapGesture];
    }
    return _maskView;
}

- (UIView *)whiteCardView {
    if (!_whiteCardView) {
        _whiteCardView = [[UIView alloc] init];
        _whiteCardView.backgroundColor = [UIColor whiteColor];
        _whiteCardView.layer.masksToBounds = YES;
        _whiteCardView.layer.cornerRadius = 12;
    }
    return _whiteCardView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor jf_colorFromHex:0x333333];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.textColor = [UIColor jf_colorFromHex:0x999999];
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _subtitleLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius  = 23;
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightBold]];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self
                           action:@selector(onConfirm:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"ObjcComponent.bundle/close_icon_gray"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
