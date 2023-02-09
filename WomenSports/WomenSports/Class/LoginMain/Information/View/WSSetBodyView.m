//
//  WSSetBodyView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSSetBodyView.h"

@implementation WSSetBodyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        MASViewAttribute *lastAttribute = self.mas_top;
        {
            UIView *textView = [UIView.alloc init];
            [self addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).mas_offset(16);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                make.height.mas_equalTo(52);
            }];
            [textView setBackgroundColor:[UIColor k_colorWithHex:0xF4F4F7FF]];
            [textView.layer setCornerRadius:8];
            
            UITextField *textField = [UITextField.alloc init];
            [textView addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(textView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                make.centerY.equalTo(textView.mas_centerY);
            }];
            [textField setFont:KMediumFont(16)];
            [textField setTextColor:K_TextMainColor];
            
            NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Height"];
            [attString addAttribute:NSForegroundColorAttributeName value:K_TextGrayColor range:NSMakeRange(0, @"Height".length)];
            [textField setAttributedPlaceholder:attString];
            
            lastAttribute = textView.mas_bottom;
        }
        {
            UIView *textView = [UIView.alloc init];
            [self addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).mas_offset(30);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                make.height.mas_equalTo(52);
            }];
            [textView setBackgroundColor:[UIColor k_colorWithHex:0xF4F4F7FF]];
            [textView.layer setCornerRadius:8];
            
            UITextField *textField = [UITextField.alloc init];
            [textView addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(textView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                make.centerY.equalTo(textView.mas_centerY);
            }];
            [textField setFont:KMediumFont(16)];
            [textField setTextColor:K_TextMainColor];
            
            NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Weight"];
            [attString addAttribute:NSForegroundColorAttributeName value:K_TextGrayColor range:NSMakeRange(0, @"Weight".length)];
            [textField setAttributedPlaceholder:attString];
            
            lastAttribute = textView.mas_bottom;
        }
    }
    return self;
}

@end
