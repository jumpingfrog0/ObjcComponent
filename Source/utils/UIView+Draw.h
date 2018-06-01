//
//  UIView+Draw.h
//  ObjcComponent
//
//  Created by sheldon on 01/06/2018.
//  Copyright © 2018 jumpingfrog0. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Draw)

- (void)setCircleHollowWithMaskColor:(UIColor *)color radius:(CGFloat)radius center:(CGPoint)center;
- (void)setCenterCircleHollowWithMaskColor:(UIColor *)color radius:(CGFloat)radius;

- (void)setHollowWithMaskColor:(UIColor *)color rect:(CGRect)rect;
- (void)addCircleLayerWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius;
- (void)addRectLayerWithColor:(UIColor *)color width:(CGFloat)width inRect:(CGRect)rect;
@end
