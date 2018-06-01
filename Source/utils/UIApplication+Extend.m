//
//  UIApplication+Extend.m
//  ObjcComponent
//
//  Created by sheldon on 01/06/2018.
//  Copyright © 2018 jumpingfrog0. All rights reserved.
//

#import "UIApplication+Extend.h"

@implementation UIApplication (Extend)
- (BOOL)jf_usesViewControllerBasedStatusBarAppearance
{
    NSString *key    = @"UIViewControllerBasedStatusBarAppearance";
    NSNumber *object = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
    if (object) {
        return [object boolValue];
    }
    return YES;
}

@end
