//
//  JFTableViewTestController.h
//  ObjcComponent
//
//  Created by huangdonghong on 2020/4/26.
//  Copyright © 2020 jumpingfrog0. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFArrayDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFTableViewTestController : UIViewController
@property(nonatomic, strong) UITableView        *tableView;
@property(nonatomic, strong) JFArrayDataSource *dataSource;
@property(nonatomic, strong) NSMutableArray     *data;
@end

NS_ASSUME_NONNULL_END
