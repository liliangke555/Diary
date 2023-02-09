//
//  WSConfirmPassController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSConfirmPassController.h"

@interface WSConfirmPassController ()

@end

@implementation WSConfirmPassController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"Confirm Password";
    [self setUIViwe];
    
    UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(backAction:)];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:@"  " forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navigation_back_white"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navigation_back_white"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
#pragma mark - IBAction
- (void)backAction:(UIButton *)sender {
    [self backViewController];
}
- (void)buttonAction:(UIButton *)sender {
    [self backViewController];
}
- (void)backViewController {
    BOOL isFind = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"WSLginEmailController")]) {
            isFind = YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
    if (!isFind) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - SetUI
- (void)setUIViwe {
    
    UIImageView *iconImageView = [UIImageView.alloc init];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_offset(6*CK_HEIGHT_Sales);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(262*CK_HEIGHT_Sales);
    }];
    [iconImageView setImage:[UIImage imageNamed:@"login_email_icon"]];
    
    UIView *bottomView = [UIView.alloc init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).mas_offset(20*CK_HEIGHT_Sales);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
//    [bottomView.layer setCornerRadius:24];
    [bottomView setBackgroundColor:K_WhiteColor];
    
    UILabel *titleLable = [UILabel.alloc init];
    [bottomView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left).mas_offset(15);
    }];
    [titleLable setText:@"Confirm Password"];
    [titleLable setFont:KSFProRoundedBoldFont(30)];
    [titleLable setTextColor:K_BlackColor];
    
    MASViewAttribute *lastAttribute = bottomView.mas_bottom;
    {
        UIView *view = [UIView.alloc init];
        [bottomView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLable.mas_bottom).mas_offset(40*CK_HEIGHT_Sales);
            make.left.right.equalTo(bottomView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(52);
        }];
        [view setBackgroundColor:K_WhiteColor];
        [view.layer setCornerRadius:26];
        [view.layer setBorderWidth:1];
        [view.layer setBorderColor:K_TextLightGrayColor.CGColor];
        
        UITextField *textField = [UITextField.alloc init];
        [view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.centerY.equalTo(view.mas_centerY);
        }];
        [textField setFont:KSFProRoundedMediumFont(16)];
        [textField setTextColor:K_BlackColor];
        
        NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Password"];
        [attString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, @"Password".length)];
        [textField setAttributedPlaceholder:attString];
        
        lastAttribute = view.mas_bottom;
    }
    {
        UIView *view = [UIView.alloc init];
        [bottomView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(30*CK_HEIGHT_Sales);
            make.left.right.equalTo(bottomView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(52);
        }];
        [view setBackgroundColor:K_WhiteColor];
        [view.layer setCornerRadius:26];
        [view.layer setBorderWidth:1];
        [view.layer setBorderColor:K_TextLightGrayColor.CGColor];
        
        UITextField *textField = [UITextField.alloc init];
        [view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.centerY.equalTo(view.mas_centerY);
        }];
        [textField setFont:KSFProRoundedMediumFont(16)];
        [textField setTextColor:K_BlackColor];
        
        NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Confirm Password"];
        [attString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, @"Confirm Password".length)];
        [textField setAttributedPlaceholder:attString];
        
        lastAttribute = view.mas_bottom;
    }
    
    
    UIButton *button = [UIButton k_blackButtonWithTarget:self action:@selector(buttonAction:)];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_bottom).mas_offset(-10-KBottomSafeHeight);
        make.height.mas_equalTo(48);
        make.left.right.equalTo(bottomView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    [button.layer setCornerRadius:24];
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    
}

@end
