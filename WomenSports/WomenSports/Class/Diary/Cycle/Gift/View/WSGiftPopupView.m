//
//  WSGiftPopupView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import "WSGiftPopupView.h"
#import "WSGiftCollectionCell.h"
#import "WSMyCoinController.h"

@interface WSGiftPopupView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *coins;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) WSGiftModel *giftModel;
@end

@implementation WSGiftPopupView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.images = @[@"gift_feather_icon",@"gift_applause_icon",@"gift_gift_icon",
        @"gift_flamingo_icon",@"gift_bouquet_icon",@"gift_octopus_icon",
        @"gift_doughnut_icon",@"gift_cake_icon"];
        self.coins = @[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80"];
        
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        self.type = MMPopupTypeSheet;
//        self.backgroundColor = K_BlackColor;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        
        UIView *view = [UIView.alloc init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);
            make.left.right.equalTo(self).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(24);
        }];
        [view setBackgroundColor:K_WhiteColor];
        [view.layer setCornerRadius:12];
        [view setClipsToBounds:YES];
        
        UIView *contentView = [UIView.alloc init];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_bottom).mas_offset(-12);
            make.left.right.equalTo(self).with.insets(UIEdgeInsetsZero);
        }];
        [contentView setBackgroundColor:K_WhiteColor];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 15, 0, 15)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:20];
        [flowLayout setItemSize:CGSizeMake((CK_WIDTH-94) / 4.0f, 88)];
        [flowLayout setSectionHeadersPinToVisibleBounds:YES];
        UICollectionView *collectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [contentView addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView.mas_top);
            make.left.right.equalTo(self).with.insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(206);
        }];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView setBackgroundColor:UIColor.clearColor];
        collectionView.alwaysBounceVertical=YES;
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSGiftCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSGiftCollectionCell.class)];
        self.collectionView = collectionView;
        
        UIButton *rechageButton = [UIButton k_buttonWithTarget:self action:@selector(rechageButtonAction:)];
        [contentView addSubview:rechageButton];
        [rechageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).mas_offset(15);
            make.top.equalTo(collectionView.mas_bottom).mas_offset(20);
        }];
        [rechageButton setTitle:@"Recharge" forState:UIControlStateNormal];
        [rechageButton setTitleColor:K_BlackColor forState:UIControlStateNormal];
        [rechageButton.titleLabel setFont:KSFProRoundedMediumFont(16)];
        [rechageButton setImage:[UIImage imageNamed:@"community_right_icon"] forState:UIControlStateNormal];
        [rechageButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        UIButton *sendButton = [UIButton k_buttonWithTarget:self action:@selector(sendButtonAction:)];
        [contentView addSubview:sendButton];
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView.mas_right).mas_offset(-15);
            make.centerY.equalTo(rechageButton.mas_centerY);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(34);
        }];
        [sendButton setBackgroundColor:[UIColor k_colorWithHex:0x11D7E1FF]];
        [sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [sendButton.titleLabel setFont:KBoldFont(16)];
        [sendButton.layer setCornerRadius:17];
        
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(sendButton.mas_bottom).mas_offset(KBottomSafeHeight+15);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contentView.mas_bottom);
        }];
        
        [self loadGiftList];
    }
    return self;
}
- (void)rechageButtonAction:(UIButton *)sender {
    
    WSMyCoinController *vc = [WSMyCoinController.alloc init];
    [[UIViewController currentNavigatonController] pushViewController:vc animated:YES];
    [self hide];
}
- (void)sendButtonAction:(UIButton *)sender {
    if (self.giftModel == nil) {
        [MBProgressHUD showMessage:@"Please select a gift！"];
        return;
    }
    if (self.didSendGift) {
        self.didSendGift(self.giftModel);
    }
    [self hide];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSGiftCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSGiftCollectionCell.class) forIndexPath:indexPath];
//    [cell setIndex:indexPath.item];
    WSGiftModel *model = self.dataSource[indexPath.item];
    [cell.pimageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    [cell.coinLabel setText:model.price];
//    [cell.pimageView setImage:[UIImage imageNamed:self.images[indexPath.item]]];
//    [cell.coinLabel setText:self.coins[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.giftModel = self.dataSource[indexPath.item];
}
- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (void)loadGiftList {
    WSGetGiftListRequest *request = [WSGetGiftListRequest.alloc init];
    request.page = 1;
    request.size = 20;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSGetGiftListModel *listModel = response.data;
        weakSelf.dataSource = listModel.data;
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
@end
