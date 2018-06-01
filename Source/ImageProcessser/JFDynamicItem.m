//
//  JFDynamicItem.m
//  iLoving
//
//  Created by sheldon on 23/09/2017.
//  Copyright © 2017 jumpingfrog0. All rights reserved.
//

#import "JFDynamicItem.h"

@implementation JFDynamicItem
- (instancetype)init
{
    self = [super init];

    if (self) {
        // Sets non-zero `bounds`, because otherwise Dynamics throws an exception.
        _bounds = CGRectMake(0, 0, 1, 1);
    }

    return self;
}
@end
