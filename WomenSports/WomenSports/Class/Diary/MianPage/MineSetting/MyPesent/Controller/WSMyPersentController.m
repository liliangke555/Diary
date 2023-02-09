//
//  WSMyPersentController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSMyPersentController.h"
#import "WSMyPersentCollectionCell.h"
#import "WSGetGiftStatisticRequest.h"

@interface WSMyPersentController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation WSMyPersentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"My Present";
    self.dataSource = [NSMutableArray array];
    self.images = @[@"gift_feather_icon",@"gift_applause_icon",@"gift_gift_icon",
    @"gift_flamingo_icon",@"gift_bouquet_icon",@"gift_octopus_icon",
    @"gift_doughnut_icon",@"gift_cake_icon"];
    
    [self reloadList];
}
- (void)reloadList {
    WSGetGiftStatisticRequest *request = [WSGetGiftStatisticRequest.alloc init];
    request.userId = kUser.uid;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.dataSource addObjectsFromArray:response.data];
        [weakSelf.collectionView reloadData];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSMyPersentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSMyPersentCollectionCell.class) forIndexPath:indexPath];
    WSGetGiftStatisticModel *model = self.dataSource[indexPath.row];
    [cell.pimageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    [cell.tnumberLabel setText:[NSString stringWithFormat:@"X%@",model.num]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_back_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"There is nothing for now, go to\nother pages to see";
    NSDictionary *attributes = @{NSFontAttributeName: KSFProRoundedRegularFont(16),
                                NSForegroundColorAttributeName:K_TextGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -CK_HEIGHT_Sales*50;
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self reloadList];
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:10];
        [flowLayout setItemSize:CGSizeMake((CK_WIDTH-30) / 4.0f, 88)];
        [flowLayout setSectionHeadersPinToVisibleBounds:YES];
        _collectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).mas_offset(20);
            make.left.right.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 15, 0, 15));
//            make.height.mas_equalTo(208);
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_equalTo(-20-KBottomSafeHeight);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        [_collectionView setBackgroundColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSMyPersentCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSMyPersentCollectionCell.class)];
        [_collectionView.layer setCornerRadius:12];
        [_collectionView setClipsToBounds:YES];
    }
    return _collectionView;
}
@end
