//
//  JFArrayDataSource.m
//  ObjcComponent
//
//  Created by jumpingfrog0 on 2020/04/24.
//
//
//  Copyright (c) 2020 Jumpingfrog0 LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "JFArrayDataSource.h"

@interface JFArrayDataSource ()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;

@end


@implementation JFArrayDataSource

- (id)init {
    return nil;
}

- (id)initWithItems:(NSArray *)items
         identifier:(NSString *)identifier
 configureCellBlock:(TableViewCellConfigureBlock)block {
    return [self initWithItems:items cellClass:[UITableViewCell class] identifier:identifier configureCellBlock:block];
}

- (id)initWithItems:(NSArray *)items
          cellClass:(Class)cls
         identifier:(NSString *)identifier
 configureCellBlock:(TableViewCellConfigureBlock)block {
    if (self = [super init]) {
        self.items = items;
        self.cellIdentifier = identifier;
        self.cellClass = cls;
        self.configureCellBlock = [block copy];
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
    if (!cell) {
        cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

@end
