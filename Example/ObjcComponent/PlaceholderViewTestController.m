//
//  PlaceholderViewTestController.m
//  ObjcComponent
//
//  Created by sheldon on 31/07/2017.
//  Copyright © 2017 jumpingfrog0. All rights reserved.
//

#import "PlaceholderViewTestController.h"
#import "JFPlaceholderView.h"

@interface PlaceholderViewTestController ()

@end

@implementation PlaceholderViewTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickAtPlaceholderView {
    NSLog(@"点击了 JFPlaceholderView");
}

- (void)clickAtCustomButton {
    NSLog(@"点击了自定义按钮");
}

- (IBAction)clickAction0:(UIButton *)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    [self presentViewController:navVc animated:YES completion:nil];
    
    [JFPlaceholderView showWithImage:[UIImage imageNamed:@"no_order"] tip:@"没有任何消息哦~" inView:vc.view];
}

- (IBAction)clickAction1:(UIButton *)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    [self presentViewController:navVc animated:YES completion:nil];
    
    [JFPlaceholderView showWithImage:nil tip:@"没有任何消息哦~" inView:vc.view];
}

- (IBAction)clickAction2:(UIButton *)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    [self presentViewController:navVc animated:YES completion:nil];
    
    [JFPlaceholderView showWithImage:nil tip:@"没有任何消息哦~" inView:vc.view target:self action:@selector(clickAtPlaceholderView)];
}

- (IBAction)clickAction3:(UIButton *)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    [self presentViewController:navVc animated:YES completion:nil];
    
    [JFPlaceholderView showWithImage:nil tip:@"没有任何消息哦~" offsetY:200 inView:vc.view];
}

- (IBAction)clickAction4:(UIButton *)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    [self presentViewController:navVc animated:YES completion:nil];
    
    [JFPlaceholderView showWithImage:nil tip:@"没有任何消息哦~" offsetY: 100 inView:vc.view target: self action:@selector(clickAtPlaceholderView)];
}

- (IBAction)clickAction5:(UIButton *)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    [self presentViewController:navVc animated:YES completion:nil];
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor cyanColor];
    [JFPlaceholderView showWithImage:nil tip:@"没有任何消息哦~" button:button inView:vc.view target:self action:@selector(clickAtCustomButton)];
}

- (IBAction)clickAction6:(UIButton *)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    [self presentViewController:navVc animated:YES completion:nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button setTitle:@"添加图片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [JFPlaceholderView showWithCustomImageView:imageView tip:@"相册还没有图片哦~" button:button offsetY:0 backgroundColor:[UIColor whiteColor] inView:vc.view target:self action:@selector(clickAtCustomButton)];
}

@end
