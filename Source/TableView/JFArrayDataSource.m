//
//  JFArrayDataSource.m
//  ObjcComponent
//
//  Created by huangdonghong on 2020/4/24.
//  Copyright © 2020 jumpingfrog0. All rights reserved.
//

//
//  JFArrayDataSource.m
//  wake
//
//  Created by sheldon on 16/11/2017.
//  Copyright © 2017 JF. All rights reserved.
//

#import "JFArrayDataSource.h"

@interface JFArrayDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end


@implementation JFArrayDataSource

- (id)init
{
    return nil;
}

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (void)reloadItems:(NSArray *)anItems {
    self.items = anItems;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.items.count > 0) {
        id item = self.items[(NSUInteger) indexPath.section];
        if ([item isKindOfClass:[NSArray class]]) {
            return self.items[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
        } else {
            return self.items[(NSUInteger)indexPath.row];
        }
    }
    return nil;
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.items.count > 0) {
        id item = self.items[0];
        if ([item isKindOfClass:[NSArray class]]) {
            return self.items.count;
        } else {
            return 1;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.items.count > 0) {
        id item = self.items[0];
        if ([item isKindOfClass:[NSArray class]]) {
            return [self.items[section] count];
        } else {
            return self.items.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

@end
