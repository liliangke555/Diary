//
//  WSPersonPostTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSPersonPostTableCell.h"

@interface WSPersonPostTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *giftButton;
@property (weak, nonatomic) IBOutlet UIView *imagBackView;

@end

@implementation WSPersonPostTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.pimageView.layer setCornerRadius:20];
    [self.pimageView setClipsToBounds:YES];
    
    [self.nameLabel setTextColor:K_TextGrayColor];
    [self.nameLabel setFont:KSFProRoundedBoldFont(16)];
    [self.nameLabel setText:@"Anna"];
    
    [self.titleLabel setTextColor:K_BlackColor];
    [self.titleLabel setFont:KSFProRoundedMediumFont(14)];
    [self.titleLabel setText:@"Here is the diary title"];
    
    [self.contentLabel setTextColor:K_TextDrakGrayColor];
    [self.contentLabel setFont:KSFProRoundedRegularFont(16)];
    [self.contentLabel setText:@"Here is the text of the diary"];
    
    [self.likeButton setImage:[UIImage imageNamed:@"cycle_like_icon"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"cycle_like_selected"] forState:UIControlStateSelected];
    [self.likeButton setTitleColor:K_TextLightGrayColor forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor k_colorWithHex:0x11D7E1FF] forState:UIControlStateSelected];
    [self.likeButton.titleLabel setFont:KSFProRoundedMediumFont(12)];
    
    [self.commentButton.titleLabel setFont:KSFProRoundedMediumFont(12)];
    [self.commentButton setTitleColor:K_TextLightGrayColor forState:UIControlStateNormal];
    
    [self.giftButton.titleLabel setFont:KSFProRoundedMediumFont(12)];
    [self.giftButton setTitleColor:K_TextLightGrayColor forState:UIControlStateNormal];
}
- (IBAction)moreButtonAction:(UIButton *)sender {
    if (self.didClickMore) {
        self.didClickMore(self.model);
    }
}
- (IBAction)likeButtonAction:(id)sender {
}
- (void)setModel:(WSCycleDetailModel *)model {
    _model = model;
    if (model) {
        [self.pimageView sd_setImageWithURL:[NSURL URLWithString:model.data9]];
        [self.nameLabel setText:model.data10];
        
        [self.titleLabel setText:model.data4];
        [self.contentLabel setText:model.data5];
        [self.imagBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (model.data6.length > 0) {
            
            
            UIImageView *imageView = [UIImageView.alloc init];
            [self.imagBackView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(self.imagBackView).insets(UIEdgeInsetsZero);
                make.width.height.mas_equalTo(219*CK_HEIGHT_Sales);
                make.bottom.equalTo(self.imagBackView.mas_bottom).mas_offset(-20);
            }];
            [imageView.layer setCornerRadius:12];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setClipsToBounds:YES];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.data6]];
            [imageView setBackgroundColor:K_TextLightGrayColor];
        }
        [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",model.data11] forState:UIControlStateNormal];
        [self.commentButton setTitle:[NSString stringWithFormat:@"%ld",model.child.count] forState:UIControlStateNormal];
        [self.giftButton setTitle:[NSString stringWithFormat:@"%ld",model.data13] forState:UIControlStateNormal];
        if ([model.listActionType containsObject:@1]) {
            self.likeButton.selected = YES;
        }
        if ([kUser.uid isEqualToString:model.userId]) {
            [self.moreButton setHidden:YES];
        } else {
            [self.moreButton setHidden:NO];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
