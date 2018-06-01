//
//  UIImage+Clip.m
//  ObjcComponent
//
//  Created by sheldon on 01/06/2018.
//  Copyright © 2018 jumpingfrog0. All rights reserved.
//

#import "UIImage+Clip.h"

@implementation UIImage (Clip)
- (UIImage *)clippedImageInRect:(CGRect)rect
{
    //修改图片方向
    UIImage *normalizedImage = self;
    if (self.imageOrientation != UIImageOrientationUp) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        [self drawInRect:(CGRect){0, 0, self.size}];
        normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    };
    
    CGFloat scale = MAX(self.scale, 1.0);
    CGRect scaleRect =
    CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(normalizedImage.CGImage, scaleRect);
    return [[UIImage alloc] initWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
}
@end
