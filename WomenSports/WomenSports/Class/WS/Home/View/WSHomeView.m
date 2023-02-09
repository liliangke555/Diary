//
//  WSHomeView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSHomeView.h"

@implementation WSHomeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIScrollView *scrollView = [UIScrollView.alloc init];
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
        }];
        [scrollView setContentSize:CGSizeMake(0, 640)];
        
        UIView *contentView = [UIView.alloc init];
        [scrollView addSubview:contentView];
        [contentView setFrame:CGRectMake(0, 0, CK_WIDTH, 640)];
        
        MASViewAttribute *lastAttribute = contentView.mas_top;
        
        {
            UIButton *yogaButton = [UIButton k_buttonWithTarget:self action:@selector(yogaButtonAction:)];
            [contentView addSubview:yogaButton];
            [yogaButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).mas_offset(20);
                make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                make.height.mas_equalTo(162);
            }];
            [yogaButton setBackgroundImage:[UIImage imageNamed:@"home_yoga_background"] forState:UIControlStateNormal];
            
            lastAttribute = yogaButton.mas_bottom;
            
            UILabel *titleLabel = [UILabel.alloc init];
            [yogaButton addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(yogaButton.mas_top).mas_offset(30);
                make.left.equalTo(yogaButton.mas_left).mas_offset(22);
            }];
            [titleLabel setText:@"Yoga"];
            [titleLabel setFont:KBoldFont(16)];
            [titleLabel setTextColor:K_TextMainColor];
            
            UILabel *subLabel = [UILabel.alloc init];
            [yogaButton addSubview:subLabel];
            [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).mas_offset(5);
                make.left.equalTo(yogaButton.mas_left).mas_offset(20);
            }];
            [subLabel setText:@"Let’s start"];
            [subLabel setFont:KSystemFont(13)];
            [subLabel setTextColor:K_TextSubMainColor];
        }
        
        {
            UIButton *medButton = [UIButton k_buttonWithTarget:self action:@selector(medButtonAction:)];
            [contentView addSubview:medButton];
            [medButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).mas_offset(20);
                make.left.equalTo(contentView.mas_left).mas_offset(15);
                make.height.mas_equalTo(216);
                make.width.mas_equalTo((CK_WIDTH - 45) / 2.0f);
            }];
            [medButton setBackgroundImage:[UIImage imageNamed:@"home_med_background"] forState:UIControlStateNormal];
            
            
            UILabel *titleLabel = [UILabel.alloc init];
            [medButton addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(medButton.mas_top).mas_offset(20);
                make.left.equalTo(medButton.mas_left).mas_offset(22);
            }];
            [titleLabel setText:@"Meditation"];
            [titleLabel setFont:KBoldFont(16)];
            [titleLabel setTextColor:K_TextMainColor];
            
            UILabel *subLabel = [UILabel.alloc init];
            [medButton addSubview:subLabel];
            [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).mas_offset(5);
                make.left.equalTo(medButton.mas_left).mas_offset(20);
            }];
            [subLabel setText:@"Let’s start"];
            [subLabel setFont:KSystemFont(13)];
            [subLabel setTextColor:K_TextSubMainColor];
        }
        
        {
            UIButton *realxButton = [UIButton k_buttonWithTarget:self action:@selector(realxButtonAction:)];
            [contentView addSubview:realxButton];
            [realxButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).mas_offset(40);
                make.right.equalTo(contentView.mas_right).mas_offset(-15);
                make.height.mas_equalTo(151);
                make.width.mas_equalTo((CK_WIDTH - 45) / 2.0f);
            }];
            [realxButton setBackgroundImage:[UIImage imageNamed:@"home_realx_background"] forState:UIControlStateNormal];
            
            lastAttribute = realxButton.mas_bottom;
            
            UILabel *titleLabel = [UILabel.alloc init];
            [realxButton addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(realxButton.mas_top).mas_offset(20);
                make.left.equalTo(realxButton.mas_left).mas_offset(20);
            }];
            [titleLabel setText:@"Realx"];
            [titleLabel setFont:KBoldFont(16)];
            [titleLabel setTextColor:K_TextMainColor];
            
            UILabel *subLabel = [UILabel.alloc init];
            [realxButton addSubview:subLabel];
            [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).mas_offset(5);
                make.left.equalTo(realxButton.mas_left).mas_offset(20);
            }];
            [subLabel setText:@"15min"];
            [subLabel setFont:KSystemFont(13)];
            [subLabel setTextColor:K_TextSubMainColor];
        }
        
        {
            UIButton *shapingButton = [UIButton k_buttonWithTarget:self action:@selector(shapingButtonAction:)];
            [contentView addSubview:shapingButton];
            [shapingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).mas_offset(75);
                make.left.equalTo(contentView.mas_left).mas_offset(15);
                make.height.mas_equalTo(151);
                make.width.mas_equalTo((CK_WIDTH - 45) / 2.0f);
            }];
            [shapingButton setBackgroundImage:[UIImage imageNamed:@"home_shaping_background"] forState:UIControlStateNormal];
            
            
            UILabel *titleLabel = [UILabel.alloc init];
            [shapingButton addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(shapingButton.mas_top).mas_offset(14);
                make.left.equalTo(shapingButton.mas_left).mas_offset(20);
            }];
            [titleLabel setText:@"Shaping"];
            [titleLabel setFont:KBoldFont(16)];
            [titleLabel setTextColor:K_TextMainColor];
            
            UILabel *subLabel = [UILabel.alloc init];
            [shapingButton addSubview:subLabel];
            [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).mas_offset(5);
                make.left.equalTo(shapingButton.mas_left).mas_offset(20);
            }];
            [subLabel setText:@"Let’s start"];
            [subLabel setFont:KSystemFont(13)];
            [subLabel setTextColor:K_TextSubMainColor];
        }
        
        {
            UIButton *targetButton = [UIButton k_buttonWithTarget:self action:@selector(targetButtonAction:)];
            [contentView addSubview:targetButton];
            [targetButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).mas_offset(30);
                make.right.equalTo(contentView.mas_right).mas_offset(-15);
                make.height.mas_equalTo(216);
                make.width.mas_equalTo((CK_WIDTH - 45) / 2.0f);
            }];
            [targetButton setBackgroundImage:[UIImage imageNamed:@"home_target_background"] forState:UIControlStateNormal];
            
            
            UILabel *titleLabel = [UILabel.alloc init];
            [targetButton addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(targetButton.mas_top).mas_offset(20);
                make.right.equalTo(targetButton.mas_right).mas_offset(-20);
            }];
            [titleLabel setText:@"Target"];
            [titleLabel setFont:KBoldFont(16)];
            [titleLabel setTextColor:K_TextMainColor];
            
            UILabel *subLabel = [UILabel.alloc init];
            [targetButton addSubview:subLabel];
            [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom).mas_offset(5);
                make.right.equalTo(targetButton.mas_right).mas_offset(-14);
            }];
            [subLabel setText:@"Let’s start"];
            [subLabel setFont:KSystemFont(13)];
            [subLabel setTextColor:K_TextSubMainColor];
        }
    }
    return self;
}
#pragma mark - IBAction
- (void)yogaButtonAction:(UIButton *)sender {
    if (self.didSelectedYoga) {
        self.didSelectedYoga();
    }
}
- (void)medButtonAction:(UIButton *)sender {
    if (self.didSelectedMeditate) {
        self.didSelectedMeditate();
    }
}
- (void)realxButtonAction:(UIButton *)sender {
    if (self.didSelectedRealx) {
        self.didSelectedRealx();
    }
}
- (void)shapingButtonAction:(UIButton *)sender {
    if (self.didSelectedShap) {
        self.didSelectedShap();
    }
}
- (void)targetButtonAction:(UIButton *)sender {
    if (self.didSelectedTarget) {
        self.didSelectedTarget();
    }
}
@end
