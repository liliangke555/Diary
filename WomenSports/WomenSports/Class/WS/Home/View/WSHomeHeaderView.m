//
//  WSHomeHeaderView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSHomeHeaderView.h"

@implementation WSHomeHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImageView *imageView = [UIImageView.alloc init];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self).insets(UIEdgeInsetsZero);
            make.width.equalTo(imageView.mas_height);
        }];
        [imageView setImage:[UIImage imageNamed:@"set_header_icon"]];
        [imageView.layer setCornerRadius:22];
        
        UILabel *label = [UILabel.alloc init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).mas_offset(10);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [label setText:@"Abigal "];
        [label setTextColor:K_TextMainColor];
        [label setFont:KBoldFont(18)];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_left);
            make.right.equalTo(label.mas_right);
            make.height.mas_equalTo(44);
        }];
    }
    return self;
}

@end
