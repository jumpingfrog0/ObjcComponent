//
//  JFGridPanelCollectionViewLayout.m
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

#import "JFGridPanelCollectionViewLayout.h"

static NSString * const JFGridPanelCollectionViewLayoutCellKind = @"JFGridPanelCollectionViewLayoutCellKind";

@interface JFGridPanelCollectionViewLayout ()<UICollectionViewDelegateFlowLayout>

@end

@implementation JFGridPanelCollectionViewLayout

@synthesize itemSize = _itemSize;

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    self.itemSize = CGSizeMake(100, 100);
    self.interItemSpacingX = 0.0f;
    self.interItemSpacingY = 0.0f;
    self.numberOfColumns = 5;
}

#pragma mark - Prepare Layout

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = nil;
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes =
                [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForCellAtIndexPath:indexPath];
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[JFGridPanelCollectionViewLayoutCellKind] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

#pragma mark - Layout Methods

- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat startingX = (indexPath.section * [UIScreen mainScreen].bounds.size.width) + self.itemInsets.left;
    NSInteger column = indexPath.row % self.numberOfColumns;
    NSInteger row = indexPath.row / self.numberOfColumns;
    CGFloat originX = floor(startingX + (self.itemSize.width + self.interItemSpacingX) * column);
    CGFloat originY = floor((self.itemSize.height + self.interItemSpacingY) * row) + self.itemInsets.top;
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:
     ^ (NSString *elementIdentifier, NSDictionary *elementsInfo, BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:
         ^ (NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[JFGridPanelCollectionViewLayoutCellKind][indexPath];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width * self.collectionView.numberOfSections), self.collectionView.bounds.size.height);
}

@end
