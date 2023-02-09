//
//  WSMineCollectController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/11.
//

#import "WSMineCollectController.h"
#import "WSYogaCourseCollectionCell.h"

@interface WSMineCollectController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void (^scrollCallback)(UIScrollView *);
@end

@implementation WSMineCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColor.clearColor];
    [self collectionView];
}
#pragma mark - JXPagerViewListViewDelegate
- (UIView *)listView {
    return self.view;
}
/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
 */
- (UIScrollView *)listScrollView {
    return self.collectionView;
}
/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CK_WIDTH-50) / 2.0f, 158);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSYogaCourseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSYogaCourseCollectionCell.class) forIndexPath:indexPath];
    [cell setAdvanced:indexPath.item % 2 == 0];
    return cell;
}
#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(20, 15, 0, 15)];
        [flowLayout setMinimumInteritemSpacing:20];
        [flowLayout setMinimumLineSpacing:20];
        [flowLayout setItemSize:CGSizeMake((CK_WIDTH-50) / 2.0f, 158)];
        [flowLayout setSectionHeadersPinToVisibleBounds:YES];
        _collectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:UIColor.clearColor];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSYogaCourseCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSYogaCourseCollectionCell.class)];
    }
    return _collectionView;
}

@end
