//
//  WSYogaController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSYogaController.h"
#import "WSYogaCourseCollectionCell.h"
#import "WSYogaHeadCollectionCell.h"

@interface WSYogaController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation WSYogaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Yoga";
    [self collectionView];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(CK_WIDTH - 30, 131);
    }
    return CGSizeMake((CK_WIDTH-50) / 2.0f, 158);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 4;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WSYogaHeadCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSYogaHeadCollectionCell.class) forIndexPath:indexPath];
        if (self.isShapPage) {
            [cell.pImageView setImage:[UIImage imageNamed:@"shap_head_icon"]];
        }
        return cell;
    }
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
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(KNavBarAndStatusBarHeight, 0, 0, 0));
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:UIColor.clearColor];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSYogaCourseCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSYogaCourseCollectionCell.class)];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSYogaHeadCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSYogaHeadCollectionCell.class)];
    }
    return _collectionView;
}

@end
