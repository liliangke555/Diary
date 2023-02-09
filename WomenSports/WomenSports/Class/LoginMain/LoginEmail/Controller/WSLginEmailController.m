//
//  WSLginEmailController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSLginEmailController.h"
#import "WSCreateAccountController.h"
#import "WSSetPasswordController.h"
#import "AppDelegate+WSAppDelegate.h"
#import "WSLoginUserRequest.h"
#import "WSGetUserInfoRequest.h"
#import "AppDelegate.h"

@interface WSLginEmailController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UIView *passView;
@property (nonatomic, strong) UITextField *passTextField;
@end

@implementation WSLginEmailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"Sign in";
    [self setUIViwe];
}
#pragma mark - IBAction
- (void)buttonAction:(UIButton *)sender {
    [self loginUser];
}
- (void)forgetButtonAction:(UIButton *)sender {
    WSSetPasswordController *vc = [WSSetPasswordController.alloc init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)createAction:(UIButton *)sender {
    WSCreateAccountController *vc = [WSCreateAccountController.alloc init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Networking
- (void)loginUser {
    WSLoginUserRequest *request = [WSLoginUserRequest.alloc init];
    request.appId = WSAPPID;
    request.allAppId = WSAPPID;
    request.deviceType = WSDeviceType;
    request.packageName = WSPackageName;
    request.version = WSVersion;
    request.email = self.emailTextField.text;
    request.password = [NSString MD5ForLower32Bate:self.passTextField.text];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSUserModel *userModel = response.data;
        
        [WSSingleCache shareSingleCache].userModel = userModel;
        [WSSingleCache shareSingleCache].token = userModel.token;
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate loginIMWithUsername:userModel.uid password:userModel.uid];
        
        [weakSelf getUserInfo];
    } failHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.emailView.layer setBorderColor:K_TextRedColor.CGColor];
        [weakSelf.emailTextField setTextColor:K_TextRedColor];
    }];
}
- (void)getUserInfo {
    WSGetUserInfoRequest *request = [WSGetUserInfoRequest.alloc init];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSUserInfoModel *model = response.data;
        WSUserModel *userModel = [WSUserModel mj_objectWithKeyValues:kUser.mj_keyValues];
        
        userModel.changeHeaderUrl = model.data1;
        userModel.changeName = model.data2;
        userModel.anonymousHeaderUrl = model.data3;
        userModel.anonymousName = model.data4;
        
        [WSSingleCache shareSingleCache].userModel = userModel;
        
        AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDele setTabbarView];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    if (pointLength > 0) {
        if (textField.tag == 100) {
            [self.emailView.layer setBorderColor:K_BlackColor.CGColor];
            [self.emailTextField setTextColor:K_BlackColor];
        } else if (textField.tag == 101) {
            [self.passView.layer setBorderColor:K_BlackColor.CGColor];
            [self.passTextField setTextColor:K_BlackColor];
        }
    } else {
        if (textField.tag == 100) {
            [self.emailView.layer setBorderColor:K_TextLightGrayColor.CGColor];
        } else if (textField.tag == 101) {
            [self.passView.layer setBorderColor:K_TextLightGrayColor.CGColor];
        }
    }
    return YES;
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
    [titleLable setText:@"Sign in"];
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
        [view.layer setBorderWidth:2];
        [view.layer setBorderColor:K_TextLightGrayColor.CGColor];
        self.emailView = view;
        
        UITextField *textField = [UITextField.alloc init];
        [view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.centerY.equalTo(view.mas_centerY);
        }];
        [textField setFont:KSFProRoundedMediumFont(16)];
        [textField setTextColor:K_BlackColor];
        textField.tag = 100;
        textField.delegate = self;
        self.emailTextField = textField;
        
        NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Email Address"];
        [attString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, @"Email Address".length)];
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
        [view.layer setBorderWidth:2];
        [view.layer setBorderColor:K_TextLightGrayColor.CGColor];
        self.passView = view;
        
        UITextField *textField = [UITextField.alloc init];
        [view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.centerY.equalTo(view.mas_centerY);
        }];
        [textField setFont:KSFProRoundedMediumFont(16)];
        [textField setTextColor:K_BlackColor];
        textField.tag = 101;
        textField.delegate = self;
        [textField setSecureTextEntry:YES];
        self.passTextField = textField;
        
        NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Password"];
        [attString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, @"Password".length)];
        [textField setAttributedPlaceholder:attString];
        
        lastAttribute = view.mas_bottom;
    }
    
    UIButton *forgetButton = [UIButton k_buttonWithTarget:self action:@selector(forgetButtonAction:)];
    [bottomView addSubview:forgetButton];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).mas_offset(-15);
        make.top.equalTo(lastAttribute).mas_offset(20*CK_HEIGHT_Sales);
    }];
    [forgetButton setTitle:@"Forget Password" forState:UIControlStateNormal];
    [forgetButton.titleLabel setFont:KSFProRoundedMediumFont(16)];
    [forgetButton setTitleColor:K_BlackColor forState:UIControlStateNormal];
    
    
    UIButton *button = [UIButton k_blackButtonWithTarget:self action:@selector(buttonAction:)];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_bottom).mas_offset(-10-KBottomSafeHeight);
        make.height.mas_equalTo(48);
        make.left.right.equalTo(bottomView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    [button.layer setCornerRadius:24];
    [button setTitle:@"Sign in" forState:UIControlStateNormal];
    
    {
        UIView *view = [UIView.alloc init];
        [bottomView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView.mas_centerX);
            make.bottom.equalTo(button.mas_top).mas_offset(-30);
        }];
        
        UILabel *label = [UILabel.alloc init];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(view).insets(UIEdgeInsetsZero);
        }];
        [label setText:@"Don’t have account?"];
        [label setFont:KSFProRoundedMediumFont(14)];
        [label setTextColor:K_TextLightGrayColor];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(createAction:)];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(view).insets(UIEdgeInsetsZero);
            make.left.equalTo(label.mas_right);
        }];
        [button setTitle:@"Create one" forState:UIControlStateNormal];
        [button setTitleColor:K_BlackColor forState:UIControlStateNormal];
        [button.titleLabel setFont:KSFProRoundedMediumFont(14)];
    }
}

@end
