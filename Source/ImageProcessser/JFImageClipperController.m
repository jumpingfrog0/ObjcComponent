//
//  JFImageClipperController.m
//  iLoving
//
//  Created by sheldon on 23/09/2017.
//  Copyright © 2017 jumpingfrog0. All rights reserved.
//

#import "JFImageClipperController.h"
#import "JFDynamicItem.h"
#import <JFUIKit/JFUIKit.h>

static CGSize const  kButtonSize       = {40.0, 19.0};
static CGFloat const kHorizontalMargin = 14.0;
static CGFloat const kBottomBarHeight  = 216.0 / 3.0;

#define IS_IPHONE_X (([[UIScreen mainScreen] bounds].size.height == 812.0) || ([[UIScreen mainScreen] bounds].size.height == 667.0 && [UIScreen mainScreen].scale == 3.0))
#define JFCompatibilityBottom (IS_IPHONE_X ? 34.0 : 0.0)

@interface JFImageClipperController ()
@property(nonatomic, strong) UIImageView *targetImageView;
@property(nonatomic, strong) UIButton    *cancelButton;
@property(nonatomic, strong) UIButton    *confirmButton;
@property(nonatomic, strong) UIView      *overlay;
@property(nonatomic, strong) UIView      *bottomBar;

@property(nonatomic, assign) CGRect  clipRect;
@property(nonatomic, assign) CGFloat dampingFactor; // 阻尼系数

@property(nonatomic, strong) UIDynamicAnimator *animator;
@property(nonatomic, strong) JFDynamicItem    *dynamicItem;
@property(nonatomic, strong) UIDynamicBehavior *inertialBehavior; // 惯性效果
@property(nonatomic, strong) UIDynamicBehavior *bouncingBehavior; // 弹簧效果
@end

@implementation JFImageClipperController

- (instancetype)init {
    if (self = [super init]) {
        [self setupArguments];
    }
    return self;
}

- (void)loadView {
    [super loadView];

    self.view.clipsToBounds = YES;
    [self.view addSubview:self.targetImageView];
    [self.view addSubview:self.overlay];
    [self.view addSubview:self.bottomBar];
    [self.bottomBar addSubview:self.cancelButton];
    [self.bottomBar addSubview:self.confirmButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    [self setupGestures];
    [self setupSubviews];
    [self fitContentSize];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (![[UIApplication sharedApplication] jf_usesViewControllerBasedStatusBarAppearance]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (![[UIApplication sharedApplication] jf_usesViewControllerBasedStatusBarAppearance]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

- (void)setupArguments {
    self.clipSize          = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.masksToCircleClip = NO;
    self.circleclipRadius  = self.clipSize.width * 0.5;
    self.minScale          = 0.7;
    self.maxScale          = 3.0;
    self.dampingFactor     = 0.01;

    self.dynamicItem = [[JFDynamicItem alloc] init];
    self.animator    = [[UIDynamicAnimator alloc] init];
}

- (void)setupSubviews {
    if (self.masksToCircleClip) {
        [self.overlay jf_setCenterCircleHollowWithMaskColor:self.overlay.backgroundColor radius:self.circleclipRadius];
        [self.overlay jf_addCircleLayerWithColor:[UIColor whiteColor] width:1.0 radius:self.circleclipRadius];
    } else {
        [self.overlay jf_setHollowWithMaskColor:self.overlay.backgroundColor rect:self.clipRect];
        [self.overlay jf_addRectLayerWithColor:[UIColor whiteColor] width:1.0 inRect:self.clipRect];
    }

    if (self.originalImage != nil) {
        CGFloat ratio = self.originalImage.size.height / self.originalImage.size.width;
        self.targetImageView.frame  = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * ratio);
        self.targetImageView.center = self.view.center;
    }
}

- (void)setupGestures {
    UIPinchGestureRecognizer *pinchGesture =
                                     [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGesture];

    UIPanGestureRecognizer *panGesture =
                                   [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)pinchView:(UIPinchGestureRecognizer *)recognizer {
    UIView *targetView = self.targetImageView;
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {

        CGFloat scale = recognizer.scale;
        if (targetView.transform.a < self.minScale) {
            scale = 1.0 - self.dampingFactor;
        }
        if (targetView.transform.a > (self.maxScale + 0.3) && recognizer.scale > 1.0) {
            scale = 1.0 + self.dampingFactor;
        }

        targetView.transform = CGAffineTransformScale(targetView.transform, scale, scale);
        recognizer.scale     = 1.0;

    } else if (recognizer.state == UIGestureRecognizerStateEnded) {

        [UIView animateWithDuration:0.2
                         animations:^{

                             if (targetView.transform.a > self.maxScale) {
                                 targetView.transform = CGAffineTransformMakeScale(self.maxScale, self.maxScale);
                             }

                             if (targetView.frame.size.width < self.clipRect.size.width) {
                                 CGFloat scale = self.clipRect.size.width / targetView.frame.size.width;
                                 targetView.transform = CGAffineTransformScale(targetView.transform, scale, scale);
                             }
                             if (targetView.frame.size.height < self.clipRect.size.height) {
                                 CGFloat scale        = self.clipRect.size.height / targetView.frame.size.height;
                                 targetView.transform = CGAffineTransformScale(targetView.transform, scale, scale);
                             }

                             if (targetView.frame.origin.x > self.clipRect.origin.x) {
                                 CGRect frame = targetView.frame;
                                 frame.origin.x   = self.clipRect.origin.x;
                                 targetView.frame = frame;
                             }
                             if (targetView.frame.origin.y > self.clipRect.origin.y) {
                                 CGRect frame     = targetView.frame;
                                 frame.origin.y   = self.clipRect.origin.y;
                                 targetView.frame = frame;
                             }
                             if (targetView.frame.origin.x + targetView.frame.size.width <
                                     self.clipRect.origin.x + self.clipRect.size.width) {
                                 CGRect frame     = targetView.frame;
                                 frame.origin.x   = self.clipRect.origin.x + self.clipRect.size.width - targetView.frame.size.width;
                                 targetView.frame = frame;
                             }
                             if (targetView.frame.origin.y + targetView.frame.size.height <
                                     self.clipRect.origin.y + self.clipRect.size.height) {
                                 CGRect frame     = targetView.frame;
                                 frame.origin.y   = self.clipRect.origin.y + self.clipRect.size.height - targetView.frame.size.height;
                                 targetView.frame = frame;
                             }
                         }];
    }
}

- (void)panView:(UIPanGestureRecognizer *)recognizer {
    UIView *targetView = self.targetImageView;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self.animator removeAllBehaviors];
    }

    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:targetView.superview];
        [targetView setCenter:CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y)];
        [recognizer setTranslation:CGPointZero inView:targetView.superview];

    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:targetView.superview];
        self.dynamicItem.center = self.targetImageView.center;
        UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
        [inertialBehavior addLinearVelocity:velocity forItem:self.dynamicItem];
        inertialBehavior.resistance = 2.0;

        __weak typeof(self) weakSelf = self;
        inertialBehavior.action = ^{
            weakSelf.targetImageView.center = weakSelf.dynamicItem.center;
            [weakSelf bouncingEffect];
        };

        [self.animator addBehavior:inertialBehavior];
        self.inertialBehavior = inertialBehavior;
    }
}

- (void)bouncingEffect {
    UIView *targetView = self.targetImageView;
    if (targetView.frame.origin.x > self.clipRect.origin.x) {
        CGRect frame = targetView.frame;
        frame.origin.x   = self.clipRect.origin.x;
        targetView.frame = frame;
    }
    if (targetView.frame.origin.y > self.clipRect.origin.y) {
        CGRect frame     = targetView.frame;
        frame.origin.y   = self.clipRect.origin.y;
        targetView.frame = frame;
    }
    if (targetView.frame.origin.x + targetView.frame.size.width < self.clipRect.origin.x + self.clipRect.size.width) {
        CGRect frame     = targetView.frame;
        frame.origin.x   = self.clipRect.origin.x + self.clipRect.size.width - targetView.frame.size.width;
        targetView.frame = frame;
    }
    if (targetView.frame.origin.y + targetView.frame.size.height < self.clipRect.origin.y + self.clipRect.size.height) {
        CGRect frame     = targetView.frame;
        frame.origin.y   = self.clipRect.origin.y + self.clipRect.size.height - targetView.frame.size.height;
        targetView.frame = frame;
    }

    //    CGPoint maxClipPoint = CGPointMake(self.clipRect.origin.x + self.clipRect.size.width, self.clipRect.origin.y +
    //    self.clipRect.size.height); CGPoint anchor = self.clipRect.origin; BOOL inside = NO;
    //
    //    if (targetView.bounds.origin.x > self.clipRect.origin.x) {
    //        inside = YES;
    //        anchor.x = self.clipRect.origin.x;
    //    }
    //    if (targetView.bounds.origin.y > self.clipRect.origin.y) {
    //        inside = YES;
    //        anchor.y = self.clipRect.origin.y;
    //    }
    //    if (targetView.bounds.origin.x + targetView.bounds.size.width < maxClipPoint.x) {
    //        inside = YES;
    //        anchor.x = maxClipPoint.x - targetView.bounds.size.width;
    //    }
    //    if (targetView.bounds.origin.y + targetView.bounds.size.height < maxClipPoint.y) {
    //        inside = YES;
    //        anchor.y = maxClipPoint.y - targetView.bounds.size.height;
    //    }
    //
    //    if (inside) {
    //        UIAttachmentBehavior *bouncingBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicItem
    //        attachedToAnchor:anchor]; bouncingBehavior.length = 1; bouncingBehavior.damping = 1;
    //        bouncingBehavior.frequency = 2;
    //
    //        [self.animator addBehavior:bouncingBehavior];
    //        self.bouncingBehavior = bouncingBehavior;
    //    }
}

- (void)fitContentSize {
    CGFloat targetH = self.targetImageView.bounds.size.height;
    CGFloat targetW = self.targetImageView.bounds.size.width;
    if (targetH < self.clipRect.size.height || targetW < self.clipRect.size.width) {
        CGFloat scale = 1.0;
        if (targetW > targetH) {
            scale = targetW / targetH;
        } else {
            scale = targetH / targetW;
        }
        self.targetImageView.transform = CGAffineTransformScale(self.targetImageView.transform, scale, scale);
    }
}

- (void)cancelAction:(UIButton *)sender {
    if (!self.navigationController.navigationBar) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        //        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)confirmAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(imageClipperController:didClipImage:)]) {
        [self.delegate imageClipperController:self didClipImage:[self getResultImgae]];
    }

    if (!self.navigationController.navigationBar) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIImage *)getResultImgae {
    CGRect      rect              = [self.view convertRect:self.clipRect toView:self.targetImageView];
    // 获取原图大小对 imageView 进行截取
    UIImageView *clipperImageView = [[UIImageView alloc] initWithImage:self.targetImageView.image];
    CGFloat     scale             = clipperImageView.image.size.width / self.clipRect.size.width;
    rect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
    return [clipperImageView.image jf_clippedImageInRect:rect];
}

- (CGRect)clipRect {
    if (self.masksToCircleClip) {
        CGFloat clipW = self.circleclipRadius * 2;
        CGFloat clipH = self.circleclipRadius * 2;
        CGFloat clipX = self.view.center.x - self.circleclipRadius;
        CGFloat clipY = self.view.center.y - self.circleclipRadius;
        return CGRectMake(clipX, clipY, clipW, clipH);
    } else {
        CGFloat clipW = self.clipSize.width;
        CGFloat clipH = self.clipSize.height;
        CGFloat clipX = self.view.center.x - clipW * 0.5;
        CGFloat clipY = self.view.center.y - clipH * 0.5;
        return CGRectMake(clipX, clipY, clipW, clipH);
    }
}

- (void)setOriginalImage:(UIImage *)originalImage {
    _originalImage = originalImage;
    self.targetImageView.image = originalImage;
}

- (UIImageView *)targetImageView {
    if (!_targetImageView) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _targetImageView = [[UIImageView alloc]
                initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - kBottomBarHeight)];
        _targetImageView.userInteractionEnabled = YES;
        _targetImageView.multipleTouchEnabled   = YES;
        _targetImageView.contentMode            = UIViewContentModeScaleAspectFit;
    }
    return _targetImageView;
}

- (UIButton *)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    return button;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [self createButton];
        _cancelButton.frame = CGRectMake(
                kHorizontalMargin, (kBottomBarHeight - kButtonSize.height) * 0.5, kButtonSize.width, kButtonSize.height);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [self createButton];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _confirmButton.frame = CGRectMake(screenSize.width - kButtonSize.width - kHorizontalMargin,
                (kBottomBarHeight - kButtonSize.height) * 0.5,
                kButtonSize.width,
                kButtonSize.height);
        [_confirmButton setTitle:@"选取" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIView *)overlay {
    if (!_overlay) {
        _overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlay.backgroundColor = [UIColor blackColor];
        _overlay.alpha           = 0.8;
    }
    return _overlay;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar =
                [[UIView alloc] initWithFrame:CGRectMake(0,
                        [UIScreen mainScreen].bounds.size.height - kBottomBarHeight - JFCompatibilityBottom,
                        [UIScreen mainScreen].bounds.size.width,
                        kBottomBarHeight + JFCompatibilityBottom)];
        _bottomBar.backgroundColor = [UIColor colorWithRed:20 / 255.0 green:20 / 255.0 blue:20 / 255.0 alpha:1];
    }
    return _bottomBar;
}

@end
