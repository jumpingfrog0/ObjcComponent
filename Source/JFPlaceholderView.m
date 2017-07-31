//
//  JFPlaceholderView.h
//  ObjcComponent
//
//  Created by jumpingfrog0 on 27/07/2017.
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

#import "JFPlaceholderView.h"
#import "Colours.h"

@interface JFPlaceholderView ()
@property (strong, nonatomic, nullable) UIImageView *customImageView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) id target;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) CGFloat offsetY;
@property (strong, nonatomic) UIColor *tipColor;
@end

@implementation JFPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.tipColor = [UIColor colorFromHexString:@"9e9e9e"];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame) - 100, 120)];
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.textColor = self.tipColor;
        self.tipLabel.font = [UIFont systemFontOfSize:14];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.imageView];
        [self addSubview:self.tipLabel];
    }
    return self;
}

+ (CGRect)__frameFromView:(UIView *)view
{
    CGRect frame = CGRectZero;
    if ([view respondsToSelector:@selector(contentSize)]) {
        CGSize size = CGSizeMake([(id)view contentSize].width, MAX([(id)view contentSize].height, CGRectGetHeight(view.bounds)));
        frame = CGRectMake(0, 0, size.width, size.height);
    } else {
        frame = view.bounds;
    }
    return frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.center = CGPointMake(CGRectGetWidth(self.superview.bounds)/2, CGRectGetHeight(self.superview.bounds)/2 - CGRectGetHeight(self.imageView.bounds)/2 - 30 + self.offsetY);
    
    if (self.customImageView != nil) {
        self.customImageView.center = CGPointMake(CGRectGetWidth(self.superview.bounds)/2, CGRectGetHeight(self.superview.bounds)/2 - CGRectGetHeight(self.customImageView.bounds)/2 - 30 + self.offsetY);
    }
    
    self.tipLabel.center = CGPointMake(CGRectGetWidth(self.superview.bounds)/2, CGRectGetMaxY(self.imageView.frame) + 12);
    
    self.button.center = CGPointMake(CGRectGetWidth(self.superview.bounds)/2, CGRectGetMaxY(self.tipLabel.frame) + 12);
}

+ (void)showWithImage:(UIImage *)image
                  tip:(NSString *)tip
               inView:(UIView *)view
{
    return [self showWithImage:image tip:tip offsetY:0 inView:view];
}

+ (void)showWithImage:(UIImage *)image
                  tip:(NSString *)tip
               inView:(UIView *)view
               target:(id)target
               action:(SEL)action
{
    return [self showWithImage:image tip:tip offsetY:0 inView:view target:target action:action];
}


+ (void)showWithImage:(UIImage *)image
                  tip:(NSString *)tip
              offsetY:(CGFloat)offsetY
               inView:(UIView *)view
{
    JFPlaceholderView *v = [[JFPlaceholderView alloc] initWithFrame:[self __frameFromView:view]];
    v.userInteractionEnabled = NO;
    v.imageView.image = image;
    v.tipLabel.text = tip;
    v.offsetY = offsetY;
    v.backgroundColor = [UIColor colorFromHexString:@"EEEEEE"];
    [v showInView:view];
}

+ (void)showWithImage:(UIImage *)image
                  tip:(NSString *)tip
              offsetY:(CGFloat)offsetY
               inView:(UIView *)view
               target:(id)target
               action:(SEL)action
{
    JFPlaceholderView *v = [[JFPlaceholderView alloc] initWithFrame:[self __frameFromView:view]];
    v.userInteractionEnabled = YES;
    
    [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:v action:@selector(__tapOnSelf:)]];
    v.imageView.image = image;
    v.tipLabel.text = tip;
    v.offsetY = offsetY;
    v.target = target;
    v.action = action;
    
    v.tipLabel.textColor = v.tipColor;
    v.backgroundColor = [UIColor colorFromHexString:@"EEEEEE"];
    
    [v showInView:view];
}

+ (void)showWithImage:(UIImage *)image
                  tip:(NSString *)tip
              button:(UIButton *)button
               inView:(UIView *)view
               target:(id)target
               action:(SEL)action
{
    JFPlaceholderView *v = [[JFPlaceholderView alloc] initWithFrame:[self __frameFromView:view]];
    v.userInteractionEnabled = YES;
    
    [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:v action:@selector(__tapOnSelf:)]];
    v.imageView.image = image;
    v.tipLabel.text = tip;
    
    v.button = button;
    [v addSubview:v.button];
    [v.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    v.tipLabel.textColor = v.tipColor;
    v.backgroundColor = [UIColor colorFromHexString:@"EEEEEE"];
    
    [v showInView:view];
}

+ (void)showWithCustomImageView:(UIImageView *)imageview
                  tip:(NSString *)tip
               button:(UIButton *)button
              offsetY:(CGFloat)offsetY
      backgroundColor:(UIColor *)backgroundColor
               inView:(UIView *)view
               target:(id)target
               action:(SEL)action
{
    JFPlaceholderView *v = [[JFPlaceholderView alloc] initWithFrame:[self __frameFromView:view]];
    v.userInteractionEnabled = YES;
    
    [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:v action:@selector(__tapOnSelf:)]];
    v.tipLabel.text = tip;
    v.offsetY = offsetY;
    
    v.customImageView = imageview;
    [v addSubview:v.customImageView];
    
    v.button = button;
    [v addSubview:v.button];
    [v.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    v.tipLabel.textColor = v.tipColor;
    v.backgroundColor = backgroundColor;
    
    [v showInView:view];
}

+ (void)hideInView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)hideInView:(UIView *)view {
    
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
}

- (void)__tapOnSelf:(UIGestureRecognizer *)gesture
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action];
    }
#pragma clang diagnostic pop
}

- (void)dealloc {
    NSLog(@"JFPlaceholderView -- dealloc");
}
@end
