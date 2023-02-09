//
//  WSSetNameView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSSetNameView.h"

@implementation WSSetNameView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        UIView *view = [UIView.alloc init];
//        [self addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.mas_centerX);
//            make.top.equalTo(self.mas_top).mas_offset(14);
//            make.width.height.mas_equalTo(88);
//        }];
//        CAGradientLayer *gl = [CAGradientLayer layer];
//        gl.frame = CGRectMake(0,0,88,88);
//        gl.startPoint = CGPointMake(1, 0.5);
//        gl.endPoint = CGPointMake(0, 0.5);
//        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:111/255.0 blue:106/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:126/255.0 green:95/255.0 blue:255/255.0 alpha:1.0].CGColor];
//        gl.locations = @[@(0), @(1.0f)];
//        [view.layer insertSublayer:gl atIndex:0];
//        [view.layer setCornerRadius:44];
//        [view setClipsToBounds:YES];
        
        UIButton *headerButton = [UIButton k_buttonWithTarget:self action:@selector(headerButtonAction:)];
        [self addSubview:headerButton];
        [headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).mas_offset(22);
            make.width.height.mas_equalTo(84);
        }];
        [headerButton setImage:[UIImage imageNamed:@"set_header_icon"] forState:UIControlStateNormal];
        [headerButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [headerButton.layer setCornerRadius:42];
        [headerButton setClipsToBounds:YES];
        self.headerButton = headerButton;
        
        UIImageView *imageView = [UIImageView.alloc init];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(headerButton).insets(UIEdgeInsetsZero);
        }];
        [imageView setImage:[UIImage imageNamed:@"set_camre_icon"]];
        
        {
            UIView *textView = [UIView.alloc init];
            [self addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headerButton.mas_bottom).mas_offset(32);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                make.height.mas_equalTo(52);
            }];
            [textView setBackgroundColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
            [textView.layer setCornerRadius:8];
            
            UITextField *textField = [UITextField.alloc init];
            [textView addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(textView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                make.centerY.equalTo(textView.mas_centerY);
            }];
            [textField setFont:KSFProRoundedMediumFont(14)];
            [textField setTextColor:K_BlackColor];
            textField.delegate = self;
            self.textView = textField;
            
            NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Nickname"];
            [attString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, @"Nickname".length)];
            [textField setAttributedPlaceholder:attString];
        }
    }
    return self;
}
- (void)headerButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    if (self.didClickHeader) {
        self.didClickHeader();
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.didEndEdit) {
        self.didEndEdit(textField.text);
    }
}
@end
