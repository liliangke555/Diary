//
//  WSCommunityDetailTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import "WSCommunityDetailTableCell.h"
#import "WSComImageCollectionCell.h"

@interface WSCommunityDetailTableCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *pimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@property (strong, nonatomic) UIButton *followButton;
@end

@implementation WSCommunityDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.pimageView.layer setCornerRadius:22];
    [self.pimageView setClipsToBounds:YES];
    
    self.followButton = [UIButton k_mainButtonWithTarget:self action:@selector(followButtonAction:)];
    [self.contentView addSubview:self.followButton];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pimageView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).mas_offset(-15);
        make.height.mas_equalTo(30);
    }];
    [self.followButton setTitle:@"    Follow    " forState:UIControlStateNormal];
    [self.followButton.layer setCornerRadius:15];
    [self.followButton setClipsToBounds:YES];
    [self.followButton.titleLabel setFont:KSystemFont(14)];
    
    [self.followingButton setTitleColor:K_TextBuleColor forState:UIControlStateNormal];
    [self.followingButton.layer setBorderWidth:1];
    [self.followingButton.layer setCornerRadius:15];
    [self.followingButton.layer setBorderColor:K_TextBuleColor.CGColor];
    self.followingButton.hidden = YES;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:15];
    [flowLayout setItemSize:CGSizeMake((CK_WIDTH-50) / 2.0f, 158)];
    [flowLayout setSectionHeadersPinToVisibleBounds:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSComImageCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSComImageCollectionCell.class)];
    
    self.collectionHeight.constant = (CK_WIDTH-60) / 3.0f;
}
- (IBAction)followingButtonAction:(UIButton *)sender {
    sender.hidden = YES;
    self.followButton.hidden = NO;
}
- (IBAction)moreButtonAction:(UIButton *)sender {
    if (self.didClickMore) {
        self.didClickMore();
    }
}
- (void)followButtonAction:(UIButton *)sender {
    sender.hidden = YES;
    self.followingButton.hidden = NO;
    
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CK_WIDTH-60) / 3.0f, (CK_WIDTH-60) / 3.0f);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSComImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSComImageCollectionCell.class) forIndexPath:indexPath];
    [cell.pImageView sd_setImageWithURL:[NSURL URLWithString:@"https://inews.gtimg.com/newsapp_bt/0/13303937706/1000"]];
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
