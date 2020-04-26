//
//  JFTextViewCell.m
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

#import "JFTextViewCell.h"
#import "JFPlaceholderTextView.h"

NSString *const JFTextViewCellBecomeFirstResponderNotification = @"JFTextViewCellBecomeFirstResponderNotification";

@implementation JFTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textView = [[JFPlaceholderTextView alloc] init];
        self.textView.delegate = self;
        [self.contentView addSubview:self.textView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textView.frame = self.bounds;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] postNotificationName:JFTextViewCellBecomeFirstResponderNotification object:nil];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textChangedBlock) {
        self.textChangedBlock(textView.text);
    }
}

@end
