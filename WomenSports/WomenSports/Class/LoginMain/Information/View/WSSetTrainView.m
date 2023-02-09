//
//  WSSetTrainView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSSetTrainView.h"
#import "WSTrainCollectionCell.h"

@interface WSSetTrainView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation WSSetTrainView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UILabel *label = [UILabel.alloc init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).insets(UIEdgeInsetsMake(20, 15, 0, 0));
        }];
        [label setText:@"Training intensity"];
        [label setTextColor:K_TextDrakGrayColor];
        [label setFont:KMediumFont(16)];
        
        MASViewAttribute *lastAttribute = label.mas_bottom;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:20];
        [flowLayout setItemSize:CGSizeMake(CK_WIDTH-60, 80)];
        [flowLayout setSectionHeadersPinToVisibleBounds:YES];
        UICollectionView *collectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(15);
            make.left.right.bottom.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        }];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView setBackgroundColor:K_WhiteColor];
        collectionView.alwaysBounceVertical=YES;
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSTrainCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSTrainCollectionCell.class)];
    }
    return self;
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSTrainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSTrainCollectionCell.class) forIndexPath:indexPath];
    [cell setIndex:indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
