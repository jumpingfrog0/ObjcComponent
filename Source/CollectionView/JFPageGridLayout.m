//
//  JFPageGridLayout.m
//  ObjcComponent
//
//  Created by jumpingfrog0 on 2020/04/26.
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

#import "JFPageGridLayout.h"
#import <JFUIKit/JFUIKit.h>

@interface JFPageGridLayout ()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
@end


@implementation JFPageGridLayout

#pragma mark - Layout

- (void)prepareLayout
{
    self.attributesArray = [NSMutableArray array];
    // 目前只处理1个session
    NSUInteger allItems = [self.collectionView numberOfItemsInSection:0];
    NSUInteger pageItems = self.rows * self.colomns;
    CGSize itemSize = CGSizeMake(self.collectionView.jf_width / self.colomns, self.collectionView.jf_height / self.rows);
    for (NSUInteger i = 0; i < allItems; i++) {
        NSUInteger page = i / pageItems;
        NSUInteger colomnIndexOfPage = i % self.colomns;
        CGFloat x = page * self.collectionView.jf_width + colomnIndexOfPage * itemSize.width;
        NSUInteger rowIndexOfPage = i / self.colomns % self.rows;
        CGFloat y = rowIndexOfPage * itemSize.height;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *itemAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemAttributes.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
        [self.attributesArray addObject:itemAttributes];
    }
}

- (CGSize)collectionViewContentSize
{
    NSUInteger allItems = [self.collectionView numberOfItemsInSection:0];
    if (allItems == 0) {
        return CGSizeZero;
    }
    NSUInteger pageItems = self.rows * self.colomns;
    NSUInteger pages = (allItems - 1) / pageItems + 1;
    return CGSizeMake(self.collectionView.jf_width * pages, self.collectionView.jf_height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.attributesArray) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [attributesArray addObject:attributes];
        }
    }
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.attributesArray[indexPath.row];
    }
    return nil;
}


@end
