//
//  WSTargetController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/6.
//

#import "WSTargetController.h"
#import "WSTargetHead.h"
#import "WSTargetChartCollectionCell.h"

@interface WSTargetController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) WSTargetHead *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation WSTargetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Target";
    [self.view addSubview:self.headerView];
    [self collectionView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.headerView.frame = CGRectMake(0, KNavBarAndStatusBarHeight, CK_WIDTH, 251);
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSTargetChartCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSTargetChartCollectionCell.class) forIndexPath:indexPath];
    [cell setIndex:indexPath.item];
    return cell;
}
#pragma mark - Getter
- (WSTargetHead *)headerView {
    if (!_headerView) {
        _headerView = [WSTargetHead TargetHeadView];
    }
    return _headerView;
}
#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 15, 0, 15)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:20];
        [flowLayout setItemSize:CGSizeMake(CK_WIDTH-30, 161)];
        [flowLayout setSectionHeadersPinToVisibleBounds:YES];
        _collectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.right.bottom.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:UIColor.clearColor];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSTargetChartCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSTargetChartCollectionCell.class)];
    }
    return _collectionView;
}
@end
