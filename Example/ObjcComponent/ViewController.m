//
//  ViewController.m
//  ObjcComponent
//
//  Created by jumpingfrog0 on 2017/07/27.
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

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, copy) NSArray *components;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.components = @[
                        @"JFPlaceholderView",
                        @"UIView+JFToast",
                        @"JFImageClipperController",
                        @"JFVideoPlayer",
                        @"JFTableView",
                        @"JFPopup",
                        ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.components.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComponentCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ComponentCell"];
    }
    cell.textLabel.text = self.components[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *component = self.components[indexPath.row];
    
    if ([component isEqualToString:@"JFPlaceholderView"]) {
        [self performSegueWithIdentifier:@"Main2PlaceholderViewTestController" sender:self];
    } else if ([component isEqualToString:@"UIView+JFToast"]) {
        [self performSegueWithIdentifier:@"Main2JFToastTestController" sender:self];
    } else if ([component isEqualToString:@"JFImageClipperController"]) {
        [self performSegueWithIdentifier:@"Main2JFImageClipperTestController" sender:self];
    } else if ([component isEqualToString:@"JFVideoPlayer"]) {
        [self performSegueWithIdentifier:@"Main2JFVideoPlayerTestController" sender:self];
    } else if ([component isEqualToString:@"JFTableView"]) {
        [self performSegueWithIdentifier:@"Main2JFTableViewTestController" sender:self];
    } else if ([component isEqualToString:@"JFPopup"]) {
        [self performSegueWithIdentifier:@"Main2JFPopupTestController" sender:self];
    }
}


@end
