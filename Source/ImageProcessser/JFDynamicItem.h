//
//  JFDynamicItem.h
//  iLoving
//
//  Created by sheldon on 23/09/2017.
//  Copyright © 2017 jumpingfrog0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface JFDynamicItem : NSObject<UIDynamicItem>
@property (nonatomic, readwrite) CGPoint center;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readwrite) CGAffineTransform transform;
@end
