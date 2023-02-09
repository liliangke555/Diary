//
//  WSCommunityTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/7.
//

#import "WSCommunityTableCell.h"
#import "WSMainButton.h"
#import "WSComImageCollectionCell.h"

@interface WSCommunityTableCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@end

@implementation WSCommunityTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.headImageView.layer setCornerRadius:22];
    [self.headImageView setClipsToBounds:YES];
    
    self.followButton = [UIButton k_mainButtonWithTarget:self action:@selector(followButtonAction:)];
    [self.contentView addSubview:self.followButton];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView.mas_centerY);
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
}
- (IBAction)likeButtonAction:(UIButton *)sender {
}
- (IBAction)commButtonAction:(UIButton *)sender {
}
- (IBAction)moreButtonAction:(UIButton *)sender {
    if (self.didClickMore) {
        self.didClickMore();
    }
}
- (IBAction)followButtonAction:(UIButton *)sender {
    sender.hidden = YES;
    self.followingButton.hidden = NO;
}
- (IBAction)followingButtonAction:(UIButton *)sender {
    sender.hidden = YES;
    self.followButton.hidden = NO;
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
- (void)setVideoDetail:(BOOL)videoDetail {
    _videoDetail = videoDetail;
    if (videoDetail) {
        self.collectionHeight.constant = 160.0f;
    } else {
        self.collectionHeight.constant = (CK_WIDTH-60) / 3.0f;
    }
}
- (void)setNoMore:(BOOL)noMore {
    _noMore = noMore;
    [self.moreButton setHidden:noMore];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
