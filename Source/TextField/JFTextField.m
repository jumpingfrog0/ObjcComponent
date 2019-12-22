//
//  JFTextField.m
//  ObjcComponent
//
//  Created by jumpingfrog0 on 2019/12/18.
//
//
//  Copyright © 2019 jumpingfrog0. All rights reserved.
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


#import "JFTextField.h"
#import "JFGeometry.h"

@implementation JFTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect frame = [super textRectForBounds:bounds];
    return CGRectEdgeInset(frame, 0.0, self.textInset.left, 0, self.textInset.right);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect frame = [super editingRectForBounds:bounds];
    return CGRectEdgeInset(frame, 0.0, self.textInset.left, 0, -ceilf(self.textInset.right / 2));
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect frame = [super clearButtonRectForBounds:bounds];
    return CGRectEdgeInset(frame, 0.0, -self.textInset.left, 0, 0);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect frame = [super leftViewRectForBounds:bounds];
    frame.origin.x += self.leftViewInset.left;
    frame.origin.y += self.leftViewInset.top;
    return frame;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect frame = [super rightViewRectForBounds:bounds];
    frame.origin.x -= self.rightViewInset.right;
    frame.origin.y += self.rightViewInset.top;
    return frame;
}


- (void)limitMaxLength:(NSUInteger)maxLength {
    NSString *toBeString = self.text;
    NSString *lang = [[self textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 中文输入
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制，有高亮选择的字符串，则暂不对文字进行统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                self.text = [toBeString substringToIndex:maxLength];
            }
        }
    }
    else{
        if (toBeString.length > maxLength) { // 表情之类的，中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            self.text = [toBeString substringToIndex:maxLength];
        }
    }
}
@end

