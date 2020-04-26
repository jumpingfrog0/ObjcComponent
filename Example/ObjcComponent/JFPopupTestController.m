//
//  JFPopupTestController.m
//  ObjcComponent
//
//  Created by huangdonghong on 2020/4/26.
//  Copyright © 2020 jumpingfrog0. All rights reserved.
//

#import "JFPopupTestController.h"
#import "JFPopupTemplate.h"
#import <JFUIKit/JFUIKit.h>

@interface JFPopupTestController ()

@end

@implementation JFPopupTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onClickPopupButton:(UIButton *)sender {
    JFPopupTemplate *popup = [[JFPopupTemplate alloc] init];
    popup.titleLabel.text = @"为你推荐新朋友";
    popup.subtitleLabel.text = @"Ta们都在线等着和你聊天喔！";
    [popup.confirmButton setTitle:@"关注并找Ta们玩" forState:UIControlStateNormal];
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 53 * 2, 46);
    [popup.confirmButton jf_setGradientLayer:[UIColor jf_colorFromHex:0x8668FF] endColor:[UIColor jf_colorFromHex:0x5A51FF] rect:rect isHorizontal:YES];
    [popup show];
}


@end
