//
//  JFImageClipperController.h
//  iLoving
//
//  Created by sheldon on 23/09/2017.
//  Copyright © 2017 jumpingfrog0. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFImageClipperController;

@protocol JFImageClipperControllerDelegate<NSObject>

- (void)imageClipperController:(JFImageClipperController *)clipper didClipImage:(UIImage *)image;

@end

@interface JFImageClipperController : UIViewController
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, assign) BOOL masksToCircleClip;
@property (nonatomic, assign) CGSize clipSize;
@property (nonatomic, assign) CGFloat circleclipRadius;
@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat maxScale;

@property (nonatomic, weak) id<JFImageClipperControllerDelegate> delegate;
@end
