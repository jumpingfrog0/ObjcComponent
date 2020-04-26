//
//  JFTableViewTestController.m
//  ObjcComponent
//
//  Created by huangdonghong on 2020/4/26.
//  Copyright © 2020 jumpingfrog0. All rights reserved.
//

#import "JFTableViewTestController.h"

@interface JFTableViewTestController () <UITableViewDelegate>

@end

@implementation JFTableViewTestController

- (void)loadView {
    [super loadView];

    [self.view addSubview:self.tableView];
    self.title = @"JFArrayDataSource Test";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [NSMutableArray array];
    [self setupTableView];
    [self setupData];

    [self.dataSource reloadItems:self.data];
    [self.tableView reloadData];
}

- (void)setupData {
    self.data = [NSMutableArray arrayWithArray:@[
        @[@"111", @"222", @"333"],
        @[@"444", @"555"],
        @[@"666"]
    ]];
}

#pragma mark - UI

- (void)setupTableView {
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"JFTableViewCell"];
    TableViewCellConfigureBlock configureCell = ^(UITableViewCell *cell, NSString *str) {
        cell.textLabel.text = str;
    };

    _dataSource = [[JFArrayDataSource alloc] initWithItems:self.data identifier:@"JFTableViewCell" configureCellBlock:configureCell];
    _tableView.dataSource = self.dataSource;
    _tableView.delegate   = self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.data[indexPath.section][indexPath.row];
    NSLog(@"%@", str);
}

@end
