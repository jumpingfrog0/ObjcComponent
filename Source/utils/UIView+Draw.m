//
//  UIView+Draw.m
//  ObjcComponent
//
//  Created by sheldon on 01/06/2018.
//  Copyright © 2018 jumpingfrog0. All rights reserved.
//

#import "UIView+Draw.h"
#import <objc/runtime.h>

static NSString const *kProgressLayer = @"kProgressLayer";

@implementation UIView (Draw)
- (void)setCircleHollowWithMaskColor:(UIColor *)color radius:(CGFloat)radius center:(CGPoint)center {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.bounds]];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center
                                                    radius:radius
                                                startAngle:0
                                                  endAngle:2 * M_PI
                                                 clockwise:NO]];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path          = path.CGPath;
    shapeLayer.fillRule      = kCAFillRuleEvenOdd;
    shapeLayer.fillColor     = color.CGColor;

    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:shapeLayer];
}

- (void)setCenterCircleHollowWithMaskColor:(UIColor *)color radius:(CGFloat)radius {
    [self setCircleHollowWithMaskColor:color
                                radius:radius
                                center:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5)];
}

- (void)setHollowWithMaskColor:(UIColor *)color rect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.bounds]];
    [path appendPath:[UIBezierPath bezierPathWithRect:rect]];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path          = path.CGPath;
    shapeLayer.fillRule      = kCAFillRuleEvenOdd;
    shapeLayer.fillColor     = color.CGColor;

    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:shapeLayer];
}

- (void)addCircleLayerWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius
{
    if (self.progressLayer != nil) {
        [self.progressLayer removeFromSuperlayer];
    }
    
    CGPoint center     = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat startPoint = -M_PI_2;            //设置进度条起点位置
    CGFloat endPoint   = -M_PI_2 + M_PI * 2; //设置进度条终点位置
    
    //环形路径
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame         = self.bounds;
    progressLayer.fillColor     = [[UIColor clearColor] CGColor];            // 填充色为无色
    progressLayer.strokeColor   = [color CGColor];                           // 指定path的渲染颜色
    progressLayer.opacity       = 1;                                         //背景颜色的透明度
    progressLayer.lineWidth     = width * [UIScreen mainScreen].scale * 0.5; //线的宽度
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startPoint
                                                      endAngle:endPoint
                                                     clockwise:YES];
    progressLayer.path = [path CGPath];
    [self.layer addSublayer:progressLayer];
    
    self.progressLayer = progressLayer;
}

- (void)addRectLayerWithColor:(UIColor *)color width:(CGFloat)width inRect:(CGRect)rect
{
    if (self.progressLayer != nil) {
        [self.progressLayer removeFromSuperlayer];
    }

    // 路径
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame         = self.bounds;
    progressLayer.fillColor     = [[UIColor clearColor] CGColor];            // 填充色为无色
    progressLayer.strokeColor   = [color CGColor];                           // 指定path的渲染颜色
    progressLayer.opacity       = 1;                                         //背景颜色的透明度
    progressLayer.lineWidth     = width * [UIScreen mainScreen].scale * 0.5; //线的宽度

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    progressLayer.path = [path CGPath];
    [self.layer addSublayer:progressLayer];

    self.progressLayer = progressLayer;
}

#pragma mark - getter & setter

- (void)setProgressLayer:(CAShapeLayer *)progressLayer
{
    objc_setAssociatedObject(self, &kProgressLayer, progressLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)progressLayer
{
    return (CAShapeLayer *)objc_getAssociatedObject(self, &kProgressLayer);
}
@end
