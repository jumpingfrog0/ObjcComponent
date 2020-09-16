//
//  JFCollectionViewTestController.m
//  ObjcComponent
//
//  Created by huangdonghong on 2020/9/16.
//  Copyright © 2020 jumpingfrog0. All rights reserved.
//

#import "JFCollectionViewTestController.h"
#import <Masonry/Masonry.h>
#import "JFPageGridLayout.h"
#import "JFGridPanelCollectionViewLayout.h"

@interface JFCollectionViewTestController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionView2;
@end

@implementation JFCollectionViewTestController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubview];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView.tag == 100) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 100) {
        return 10;
    }
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *colors = @[[UIColor redColor], [UIColor yellowColor], [UIColor redColor], [UIColor blueColor]];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JFTestCollectionCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = colors[arc4random() % 4];
    return cell;
}
#pragma mark - UI

- (void)setupSubview
{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(15);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(15);
        }
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.height.mas_offset(100);
    }];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"JFTestCollectionCell"];
    
    [self.view addSubview:self.collectionView2];
    [self.collectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(200);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(200);
        }
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_offset(140);
    }];
    [self.collectionView2 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"JFTestCollectionCell"];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        JFPageGridLayout *layout = [JFPageGridLayout new];
        layout.rows = 1;
        layout.colomns = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UICollectionView *)collectionView2
{
    if (!_collectionView2) {
        JFGridPanelCollectionViewLayout *layout = [[JFGridPanelCollectionViewLayout alloc] init];
        layout.interItemSpacingX = 10;
        layout.interItemSpacingY = 10;
        
        CGFloat horizontalMargin = 7;
        layout.itemInsets = UIEdgeInsetsMake(0.0f, horizontalMargin, 0.0f, horizontalMargin);

        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        NSInteger numberOfColumn = 5;
        CGFloat width = (screenSize.width - horizontalMargin * 2 - layout.minimumInteritemSpacing * (numberOfColumn - 1)) / numberOfColumn;
        CGFloat height = width;

        layout.itemSize = CGSizeMake(width, height);
        
        _collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView2.backgroundColor = [UIColor whiteColor];
        _collectionView2.delegate = self;
        _collectionView2.dataSource = self;
        _collectionView2.pagingEnabled = YES;
        _collectionView2.tag = 100;
//        _collectionView2.showsVerticalScrollIndicator = NO;
//        _collectionView2.showsHorizontalScrollIndicator = NO;
//        _collectionView2.alwaysBounceHorizontal=YES;
    }
    return _collectionView2;
}

@end

