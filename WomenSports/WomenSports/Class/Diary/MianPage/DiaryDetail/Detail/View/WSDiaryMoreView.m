//
//  WSDiaryMoreView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/17.
//

#import "WSDiaryMoreView.h"
#import "WSDiaryMoreCollectionCell.h"

@interface WSDiaryMoreView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation WSDiaryMoreView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.imageArray = @[@"more_edit_icon",@"more_delete_icon"];
        self.titleArray = @[@"Edit diary",@"Delete Diary"];
        
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        self.type = MMPopupTypeSheet;
//        self.backgroundColor = K_WhiteColor;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CK_WIDTH);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        UIView *topView = [UIView.alloc init];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(24);
        }];
        [topView setBackgroundColor:K_WhiteColor];
        [topView.layer setCornerRadius:12];
        [topView setClipsToBounds:YES];
        
        UIView *contentView = [UIView.alloc init];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).mas_offset(-12);
            make.left.right.equalTo(self).with.insets(UIEdgeInsetsZero);
//            make.height.mas_equalTo(200);
        }];
        [contentView setBackgroundColor:K_WhiteColor];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(8, 16, 0, 16)];
        [flowLayout setMinimumInteritemSpacing:20];
        [flowLayout setMinimumLineSpacing:20];
        [flowLayout setItemSize:CGSizeMake((CK_WIDTH-92) / 4.0f, ((CK_WIDTH-92) / 4.0f) + 25)];
        [flowLayout setSectionHeadersPinToVisibleBounds:YES];
        UICollectionView *collectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [contentView addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_top);
            make.left.right.equalTo(self).with.insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(200);
        }];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView setBackgroundColor:UIColor.clearColor];
        collectionView.alwaysBounceVertical=YES;
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSDiaryMoreCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSDiaryMoreCollectionCell.class)];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(collectionView.mas_bottom).mas_offset(KBottomSafeHeight);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contentView.mas_bottom);
        }];
    }
    return self;
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSDiaryMoreCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSDiaryMoreCollectionCell.class) forIndexPath:indexPath];
    [cell.pImageView setImage:[UIImage imageNamed:self.imageArray[indexPath.item]]];
    [cell.titleLabel setText:self.titleArray[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didClickItem) {
        self.didClickItem(indexPath.item);
    }
    [self hide];
}
@end
