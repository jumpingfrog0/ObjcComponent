//
//  JFImageClipperTestController.m
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

#import "JFImageClipperTestController.h"
#import "JFImageClipperController.h"

@interface JFImageClipperTestController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, JFImageClipperControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JFImageClipperTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)selectImage {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    UIAlertController       *alert       = [UIAlertController alertControllerWithTitle:nil message:@"添加头像" preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate   = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        imagePicker.sourceType          = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate            = self;
        imagePicker.showsCameraControls = YES;
        imagePicker.cameraDevice        = UIImagePickerControllerCameraDeviceRear;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    JFImageClipperController *clipper   = [[JFImageClipperController alloc] init];
    CGSize                    boundsSize = [UIScreen mainScreen].bounds.size;
    clipper.clipSize      = CGSizeMake(boundsSize.width, boundsSize.width);
    clipper.delegate      = self;
    clipper.originalImage = image;
    [picker pushViewController:clipper animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - JFImageClipperControllerDelegate
- (void)imageClipperController:(JFImageClipperController *)clipper didClipImage:(UIImage *)image {
    self.imageView.hidden = NO;
    self.imageView.image  = image;
}
@end
