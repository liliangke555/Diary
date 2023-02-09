//
//  WSCycleHeaderView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/17.
//

#import "WSCycleHeaderView.h"
#import "WSPersonPController.h"
#import "WSMessageController.h"

@interface WSCycleHeaderView ()<UITextFieldDelegate>

@end

@implementation WSCycleHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIButton *messageButton = [UIButton k_buttonWithTarget:self action:@selector(messageButtonAction:)];
        [self addSubview:messageButton];
        [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(49);
        }];
        [messageButton setImage:[UIImage imageNamed:@"cycle_message_icon"] forState:UIControlStateNormal];
        
        UIButton *personButton = [UIButton k_buttonWithTarget:self action:@selector(personButtonAction:)];
        [self addSubview:personButton];
        [personButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(49);
        }];
        [personButton setImage:[UIImage imageNamed:@"cycle_person_icon"] forState:UIControlStateNormal];
        
//        UISearchBar *searchBar = [UISearchBar.alloc init];
//        [self addSubview:searchBar];
//        [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(messageButton.mas_right).mas_offset(10);
//            make.right.equalTo(personButton.mas_left).mas_offset(-10);
//            make.top.bottom.equalTo(self).insets(UIEdgeInsetsMake(5, 0, 5, 0));
//        }];
//        [searchBar setPlaceholder:@"Search"];
//        searchBar.delegate = self;
        
        UITextField *textField = [UITextField.alloc init];
        [self addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(messageButton.mas_right);
            make.right.equalTo(personButton.mas_left);
            make.top.bottom.equalTo(self).insets(UIEdgeInsetsMake(2, 0, 2, 0));
        }];
        [textField.layer setCornerRadius:20];
        [textField setClipsToBounds:YES];
        [textField setBackgroundColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
        textField.delegate = self;
        [textField setReturnKeyType:UIReturnKeySearch];
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        
        
        NSString *textString = @"    Search";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:textString];
        // 插入图片附件
        NSTextAttachment *imageAtta = [[NSTextAttachment alloc] init];
        imageAtta.bounds = CGRectMake(0, 0, 18, 18);
        imageAtta.image = [UIImage imageNamed:@"search_icon"];
        NSAttributedString *attach = [NSAttributedString attributedStringWithAttachment:imageAtta];
        [attributeString insertAttributedString:attach atIndex:0];
        
        // 段落样式
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        ///计算placeHolder文字宽度
        CGSize textSize = [textString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:KSFProRoundedMediumFont(14)} context:nil].size;
        
        // 缩进以实现居中展示(解决问题a)
        [style setFirstLineHeadIndent:([[UIScreen mainScreen] bounds].size.width-98-18-20-textSize.width)/2.0];
        [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeString.length)];
        
        [attributeString addAttribute:NSFontAttributeName value:KSFProRoundedMediumFont(14) range:NSMakeRange(1, attributeString.length - 1)];
        ///解决问题b
        [attributeString addAttribute:NSBaselineOffsetAttributeName value:@(0.36 * 10) range:NSMakeRange(1, attributeString.length - 1)];
        textField.attributedPlaceholder = attributeString;
        
//        UIImageView *barImageView = [[[searchBar.subviews firstObject] subviews] firstObject];
//        barImageView.layer.borderColor = K_WhiteColor.CGColor;
//        barImageView.layer.borderWidth = 1;
        
    }
    return self;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.didClickSearch) {
        self.didClickSearch(textField.text);
    }
    
//    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - IBAction
- (void)messageButtonAction:(UIButton *)sender {
    WSMessageController *conversationVC = [[WSMessageController alloc] init];
    [[UIViewController currentNavigatonController] pushViewController:conversationVC animated:YES];
}
- (void)personButtonAction:(UIButton *)sender {
    WSPersonPController *vc = [WSPersonPController.alloc init];
    vc.userIdString = kUser.uid;
    [[UIViewController currentNavigatonController] pushViewController:vc animated:YES];
}
@end
