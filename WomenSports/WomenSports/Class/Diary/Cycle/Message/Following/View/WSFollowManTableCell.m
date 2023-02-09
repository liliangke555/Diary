//
//  WSFollowManTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "WSFollowManTableCell.h"

@interface WSFollowManTableCell ()
@property (weak, nonatomic) IBOutlet UIView *headerBackView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation WSFollowManTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.headerBackView.layer setCornerRadius:30];
    [self.headerBackView.layer setBorderWidth:1];
    [self.headerBackView.layer setBorderColor:[UIColor k_colorWithHex:0x222222FF].CGColor];
    [self.headerBackView setClipsToBounds:YES];
    
    [self.headerImageView.layer setCornerRadius:28];
    [self.headerImageView setClipsToBounds:YES];
    
    [self.nameLabel setTextColor:[UIColor k_colorWithHex:0x222222FF]];
    [self.nameLabel setFont:KSFProRoundedMediumFont(16)];
    
    [self.button.layer setCornerRadius:16];
    [self.button.layer setBorderWidth:1];
    [self.button.layer setBorderColor:K_BlackColor.CGColor];
    [self.button.titleLabel setFont:KSFProRoundedMediumFont(14)];
    [self.button setTitleColor:K_BlackColor forState:UIControlStateNormal];
    [self.button setClipsToBounds:YES];
}
- (IBAction)butonAction:(UIButton *)sender {
    if (self.didClickUnfollow) {
        self.didClickUnfollow(self.model);
    }
}
- (void)setModel:(WSFollowDetailModel *)model {
    _model = model;
    if (model) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.header] placeholderImage:[UIImage imageNamed:@"set_header_icon"]];
        [self.nameLabel setText:model.nickname];
        
    }
}
- (void)setFollower:(BOOL)follower {
    _follower = follower;
    if (follower) {
        [self.button setBackgroundColor:K_BlackColor];
        [self.button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.button setTitle:@"Following" forState:UIControlStateNormal];
    } else {
        [self.button setBackgroundColor:UIColor.whiteColor];
        [self.button setTitleColor:K_BlackColor forState:UIControlStateNormal];
        [self.button setTitle:@"Unfollow" forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
