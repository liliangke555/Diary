//
//  WSPersonHeadView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/11.
//

#import "WSPersonHeadView.h"

@interface WSPersonHeadView ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UILabel *folllwerLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) UIButton *followButton;
@end

@implementation WSPersonHeadView
+ (instancetype)personHeadView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WSPersonHeadView" owner:nil options:@{}] lastObject];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headerImageView.layer setCornerRadius:38];
    [self.headerImageView setClipsToBounds:YES];
    
    UIEdgeInsets edge = UIEdgeInsetsMake(129, 10, 68, 100);
    UIImage * frameImg1 = [UIImage imageNamed:@"mine_person_background"];
    frameImg1 = [frameImg1 resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    [self.backImageView setImage:frameImg1];
    
    [self.followingButton.layer setBorderWidth:1];
    [self.followingButton.layer setBorderColor:K_TextBuleColor.CGColor];
    [self.followingButton.layer setCornerRadius:17];
    [self.followingButton setClipsToBounds:YES];
    
    self.followButton = [UIButton k_mainButtonWithTarget:self action:@selector(followButtonAction:)];
    [self addSubview:self.followButton];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImageView.mas_centerY);
        make.right.equalTo(self.backImageView.mas_right).mas_offset(-23);
        make.height.mas_equalTo(34);
    }];
    [self.followButton setTitle:@"    Follow    " forState:UIControlStateNormal];
    [self.followButton.layer setCornerRadius:17];
    [self.followButton setClipsToBounds:YES];
    [self.followButton.titleLabel setFont:KSystemFont(17)];
    
    [self.folllwerLabel setFont:KSDINBoldFont(22)];
    [self.likesLabel setFont:KSDINBoldFont(22)];
    [self.collectsLabel setFont:KSDINBoldFont(22)];
    [self.followingLabel setFont:KSDINBoldFont(22)];
}
- (IBAction)followingButtonAction:(UIButton *)sender {
    sender.hidden = YES;
    self.followButton.hidden = NO;
}
- (void)followButtonAction:(UIButton *)sender {
    sender.hidden = YES;
    self.followingButton.hidden = NO;
}

@end
