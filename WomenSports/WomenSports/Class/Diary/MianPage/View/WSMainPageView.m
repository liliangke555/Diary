//
//  WSMainPageView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import "WSMainPageView.h"

@interface WSMainPageView ()
@property (nonatomic, strong) UIView *backView;

@end

@implementation WSMainPageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *label = [UILabel.alloc init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).mas_offset(20*CK_HEIGHT_Sales);
            make.left.equalTo(self.mas_left).mas_offset(15);
        }];
        [label setText:[NSString stringWithFormat:@"Hello %@",kUser.name]];
        
        [label setTextColor:K_BlackColor];
        [label setFont:KSFProRoundedMediumFont(22)];
        self.nameLabel = label;
        
        UIView *backView = [UIView.alloc init];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(15);
            make.top.equalTo(label.mas_bottom).mas_offset(20*CK_HEIGHT_Sales);
            make.right.equalTo(self.mas_right).mas_offset(-45);
            make.height.mas_equalTo(470*CK_HEIGHT_Sales);
        }];
        [backView setBackgroundColor:K_WhiteColor];
        backView.layer.cornerRadius = 18;
        [backView setClipsToBounds:YES];
        self.backView = backView;
        [backView addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(backTapAction:)]];
        
        UILabel *dayLabel = [UILabel.alloc init];
        [backView addSubview:dayLabel];
        [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).mas_offset(20);
            make.left.equalTo(backView.mas_left).mas_offset(20);
        }];
        [dayLabel setText:@"22"];
        [dayLabel setFont:KSFProRoundedMediumFont(24)];
        [dayLabel setTextColor:[UIColor k_colorWithHex:0x1D7E1FF]];
        self.dayLable = dayLabel;
        
        UILabel *timeLabel = [UILabel.alloc init];
        [backView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dayLabel.mas_centerY);
            make.left.equalTo(dayLabel.mas_right).mas_offset(10);
        }];
        [timeLabel setText:@"2022.December"];
        [timeLabel setFont:KSFProRoundedRegularFont(16)];
        [timeLabel setTextColor:K_TextGrayColor];
        self.timeLable = timeLabel;
        
        UIImageView *imageView = [UIImageView.alloc init];
        [backView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dayLabel.mas_bottom).mas_offset(35*CK_HEIGHT_Sales);
//            make.left.equalTo(backView.mas_left).mas_offset(22);
            make.centerX.equalTo(backView.mas_centerX);
//            make.height.mas_equalTo(232*CK_HEIGHT_Sales);
//            make.width.mas_equalTo(272*CK_WIDTH_Sales);
        }];
        [imageView setImage:[UIImage imageNamed:@"home_med_background"]];
        
        UIButton *button = [UIButton k_blackButtonWithTarget:self action:@selector(recordButtonAction:)];
        [backView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).mas_offset(48*CK_HEIGHT_Sales);
            make.centerX.equalTo(backView.mas_centerX);
            make.width.mas_equalTo(160);
            make.height.mas_equalTo(52);
        }];
        [button setTitle:@"Record Today" forState:UIControlStateNormal];
        [button.titleLabel setFont:KSFProRoundedRegularFont(18)];
        [button.layer setCornerRadius:26];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.backView.layer.shadowColor = K_ShadowColor.CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0,3);
    self.backView.layer.shadowOpacity = 1;
    self.backView.layer.shadowRadius = 8;
    [self.backView.layer setMasksToBounds:NO];
}
- (void)recordButtonAction:(UIButton *)sender {
    if (self.didClickRecord) {
        self.didClickRecord();
    }
}
- (void)backTapAction:(UIButton *)sender {
    if (self.didClickDetail) {
        self.didClickDetail();
    }
}
@end
