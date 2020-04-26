//
//  JFPlaceholderTextView.m
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

#import "JFPlaceholderTextView.h"
#import <JFUIKit/JFUIKit.h>

@interface JFPlaceholderTextView ()
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *limitLabel;
@end

@implementation JFPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // set up placeholder
        self.placeholderLabel = [[UILabel alloc] init];
        self.placeholderLabel.font = [UIFont systemFontOfSize:15];
        self.placeholderLabel.textColor = [UIColor jf_colorWithHex:@"0xcccccc"];
        self.placeholderLabel.enabled = NO;

        [self addSubview:self.placeholderLabel];
        [self addSubview:self.limitLabel];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];

        // set up text
        [self setTextContainerInset:UIEdgeInsetsMake(12, 12, 12, 12)];
        self.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChanged:(NSNotification *)notification {
    self.placeholderLabel.hidden = self.text.length > 0;

    if (self.maxLimitNumber <= 0) {
        return;
    }

    // 限制输入的字符数
    [self handleLimitNumberOfText];
    self.limitLabel.text = [NSString stringWithFormat:@"%lu", self.maxLimitNumber - self.text.length];
}

- (void)handleLimitNumberOfText {
    NSUInteger kMaxLength = (NSUInteger) self.maxLimitNumber;
    NSString *toBeString = self.text;
    NSString *lang = [[self textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 中文输入
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制，有高亮选择的字符串，则暂不对文字进行统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                self.text = [toBeString substringToIndex:kMaxLength];
            }
        }
    }
    else{
        if (toBeString.length > kMaxLength) { // 表情之类的，中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            self.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}

- (void)setMaxLimitNumber:(NSInteger)limitNumber {
    _maxLimitNumber = limitNumber;

    if (limitNumber > 0) {
        self.limitLabel.hidden = NO;
        self.limitLabel.text = [NSString stringWithFormat:@"%ld", (long)self.maxLimitNumber];
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font {
    self.placeholderLabel.font = font;
    [super setFont:font];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    // trigger text change event manually
    [self textChanged:nil];
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderLabel.frame = CGRectMake(15, 12, self.bounds.size.width - 15 * 2, 15);

    self.limitLabel.jf_size = CGSizeMake(50, 13);
    self.limitLabel.jf_right = self.bounds.size.width - 9;
    self.limitLabel.jf_bottom = self.bounds.size.height - 4;
}

- (UILabel *)limitLabel {
    if (!_limitLabel) {
        _limitLabel = [[UILabel alloc] init];
        _limitLabel.textColor = [UIColor jf_colorWithHex:@"0x999999"];
        _limitLabel.font = [UIFont systemFontOfSize:13.0f];
        _limitLabel.textAlignment = NSTextAlignmentRight;
        _limitLabel.hidden = YES;
    }
    return _limitLabel;
}
@end
