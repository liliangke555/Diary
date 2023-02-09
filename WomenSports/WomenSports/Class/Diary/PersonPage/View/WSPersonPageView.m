//
//  WSPersonPageView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSPersonPageView.h"

@interface WSPersonPageView ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoHeight;

@end

@implementation WSPersonPageView
+ (instancetype)persenPageView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WSPersonPageView" owner:nil options:@{}] lastObject];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView.layer setCornerRadius:37.5];
    [self.headImageView setClipsToBounds:YES];
    
    [self.nameLabel setFont:KSFProRoundedMediumFont(18)];
    [self.nameLabel setTextColor:K_BlackColor];
    
    [self.idLabel setFont:KSFProRoundedMediumFont(14)];
    [self.idLabel setTextColor:K_TextDrakGrayColor];
    
    [self.followButton setTitleColor:[UIColor k_colorWithHex:0x11D7E1FF] forState:UIControlStateNormal];
    [self.followButton.titleLabel setFont:KSFProRoundedRegularFont(14)];
    [self.followButton setTitle:@"    Follow    " forState:UIControlStateNormal];
    [self.followButton setTitle:@"    Following    " forState:UIControlStateSelected];
    [self.followButton.layer setCornerRadius:4];
    [self.followButton.layer setBorderWidth:1];
    [self.followButton.layer setBorderColor:[UIColor k_colorWithHex:0x11D7E1FF].CGColor];
    
    [self.messageButton.layer setCornerRadius:4];
    [self.messageButton setClipsToBounds:YES];
    
    [self.headBackView.layer setCornerRadius:12];
//    [self.headBackView setClipsToBounds:YES];
}
- (void)setUserModel:(WSUserInfoModel *)userModel {
    _userModel = userModel;
    if (userModel) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userModel.data1]];
        [self.nameLabel setText:userModel.data2];
        [self.idLabel setText:[NSString stringWithFormat:@"ID: %ld",[userModel.userId integerValue] % 2000000000]];
        if ([userModel.userId isEqualToString:kUser.uid]) {
            [self.buttonsView setHidden:YES];
            self.infoHeight.constant = 114;
        } else {
            [self.buttonsView setHidden:NO];
            self.infoHeight.constant = 148;
        }
    }
}
- (void)setFollowUser:(BOOL)followUser {
    _followUser = followUser;
    [self.followButton setSelected:followUser];
}
- (IBAction)followButtonAction:(UIButton *)sender {
    if (self.didClickFollow) {
        self.didClickFollow(self.followUser);
    }
}
- (IBAction)messageButtonAction:(UIButton *)sender {
    if (self.didClickMessage) {
        self.didClickMessage(self.userModel);
    }
}
@end
