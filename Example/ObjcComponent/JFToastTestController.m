//
//  JFToastTestController.m
//  ObjcComponent
//
//  Created by sheldon on 02/08/2017.
//  Copyright © 2017 jumpingfrog0. All rights reserved.
//

#import "JFToastTestController.h"
#import "UIView+JFToast.h"

@interface JFToastTestController ()

@end

@implementation JFToastTestController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showToast:(id)sender {
    [self.view toast:@"我是toast，你打我啊~~"];
}

@end
