//
//  JFImageClipperTestController.m
//  ObjcComponent
//
//  Created by sheldon on 01/06/2018.
//  Copyright © 2018 jumpingfrog0. All rights reserved.
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
