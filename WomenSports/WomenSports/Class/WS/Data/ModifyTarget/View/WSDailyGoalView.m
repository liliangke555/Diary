//
//  WSDailyGoalView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/10.
//

#import "WSDailyGoalView.h"

@implementation WSDailyGoalView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *titleLabel = [UILabel.alloc init];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).insets(UIEdgeInsetsMake(20, 15, 0, 0));
        }];
        [titleLabel setFont:KBoldFont(16)];
        [titleLabel setTextColor:K_TextDrakGrayColor];
        [titleLabel setText:@"Daily goal"];
        
        UILabel *exerciseLabel = [UILabel.alloc init];
        [self addSubview:exerciseLabel];
        [exerciseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(31);
            make.top.equalTo(titleLabel.mas_bottom).mas_offset(15);
        }];
        [exerciseLabel setFont:KSystemFont(12)];
        [exerciseLabel setTextColor:K_TextLightGrayColor];
        [exerciseLabel setText:@"Exercise consumption"];
        
        UILabel *timeLabel = [UILabel.alloc init];
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(exerciseLabel.mas_right);
            make.centerY.equalTo(exerciseLabel.mas_centerY);
            make.right.equalTo(self.mas_right);
            make.width.equalTo(exerciseLabel.mas_width);
        }];
        [timeLabel setFont:KSystemFont(12)];
        [timeLabel setTextColor:K_TextLightGrayColor];
        [timeLabel setText:@"Exercise time"];
        
        UIImageView *conImageView = [UIImageView.alloc init];
        [self addSubview:conImageView];
        [conImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(exerciseLabel.mas_left);
            make.top.equalTo(exerciseLabel.mas_bottom).mas_offset(14);
        }];
        [conImageView setImage:[UIImage imageNamed:@"data_consum_icon"]];
        
        UILabel *comNumLabel = [UILabel.alloc init];
        [self addSubview:comNumLabel];
        [comNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(conImageView.mas_right).mas_offset(3);
            make.centerY.equalTo(conImageView.mas_centerY);
        }];
        [comNumLabel setFont:KSDINBoldFont(24)];
        [comNumLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
        [comNumLabel setText:@"180"];
        
        UILabel *comBLabel = [UILabel.alloc init];
        [self addSubview:comBLabel];
        [comBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(comNumLabel.mas_right);
            make.bottom.equalTo(comNumLabel.mas_bottom);
        }];
        [comBLabel setFont:KSDINBoldFont(16)];
        [comBLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
        [comBLabel setText:@"(kcal)"];
        
        
        UIImageView *conTimeImageView = [UIImageView.alloc init];
        [self addSubview:conTimeImageView];
        [conTimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeLabel.mas_left);
            make.top.equalTo(timeLabel.mas_bottom).mas_offset(14);
        }];
        [conTimeImageView setImage:[UIImage imageNamed:@"data_time_icon"]];
        
        UILabel *comTimeNumLabel = [UILabel.alloc init];
        [self addSubview:comTimeNumLabel];
        [comTimeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(conTimeImageView.mas_right).mas_offset(3);
            make.centerY.equalTo(conTimeImageView.mas_centerY);
        }];
        [comTimeNumLabel setFont:KSDINBoldFont(24)];
        [comTimeNumLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
        [comTimeNumLabel setText:@"20"];
        
        UILabel *comTimeBLabel = [UILabel.alloc init];
        [self addSubview:comTimeBLabel];
        [comTimeBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(comTimeNumLabel.mas_right);
            make.bottom.equalTo(comTimeNumLabel.mas_bottom);
        }];
        [comTimeBLabel setFont:KSDINBoldFont(16)];
        [comTimeBLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
        [comTimeBLabel setText:@"(min)"];
        
        UIButton *button = [UIButton k_mainButtonWithTarget:self action:@selector(buttonAction:)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).mas_offset(-20);
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(48);
        }];
        [button setTitle:@"Target generation" forState:UIControlStateNormal];
        [button.layer setCornerRadius:24];
    }
    return self;
}
- (void)buttonAction:(UIButton *)sender {
    
}
@end
