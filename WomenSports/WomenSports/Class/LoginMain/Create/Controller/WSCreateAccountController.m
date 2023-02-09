//
//  WSCreateAccountController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSCreateAccountController.h"
#import "WSInformationController.h"
#import "WSEmailCanBeRequest.h"
#import "WSRegistUserRequest.h"
#import "AppDelegate.h"

@interface WSCreateAccountController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UIView *passView;
@property (nonatomic, strong) UITextField *passTextField;
@property (nonatomic, strong) UIView *passAginView;
@property (nonatomic, strong) UITextField *passAginField;
@property (nonatomic, assign, getter=isCanBeEmail) BOOL canBeEmail;
@end

@implementation WSCreateAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"Create Account";
    [self setUIViwe];
}
#pragma mark - Networking
- (void)emailCanBe:(NSString *)email {
    WSEmailCanBeRequest *request = [WSEmailCanBeRequest.alloc init];
    request.email = email;
    request.deviceType = WSDeviceType;
    request.packageName = WSPackageName;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
//        WSEmailCanBeModel *model = response.data;
        weakSelf.canBeEmail = [response.data boolValue];
        if ([response.data boolValue]) {
            
        } else {
            [MBProgressHUD showMessage:@"The current email address is not available!"];
            [weakSelf.emailView.layer setBorderColor:K_TextRedColor.CGColor];
            [weakSelf.emailTextField setTextColor:K_TextRedColor];
        }
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)registUser {
    WSRegistUserRequest *request = [WSRegistUserRequest.alloc init];
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
        userModel.anonymousName = [NSString stringWithFormat:@"User_%05u",arc4random() % 10000];
        userModel.anonymousHeaderUrl = userModel.header;
        [WSSingleCache shareSingleCache].userModel = userModel;
        [WSSingleCache shareSingleCache].token = kUser.token;
        
        AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDele registEasIMWithName:userModel.uid password:userModel.uid];
        
        WSInformationController *vc = [WSInformationController.alloc init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)buttonAction:(UIButton *)sender {
    if (self.isCanBeEmail) {
        if (self.passTextField.text.length < 6) {
            [MBProgressHUD showMessage:@"The password cannot be less than 6 digits"];
            return;
        }
        if ([self.passTextField.text isEqualToString:self.passAginField.text]) {
            [self registUser];
        } else {
            [MBProgressHUD showMessage:@"The confirmation password is inconsistent!"];
        }
    } else {
        [MBProgressHUD showMessage:@"The current email address is not available!"];
    }
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 100) {
        if (![textField.text isValidEmail]) {
            [MBProgressHUD showMessage:@"The current email address is not available!"];
            [self.emailView.layer setBorderColor:K_TextRedColor.CGColor];
            [self.emailTextField setTextColor:K_TextRedColor];
            return;
        }
        [self emailCanBe:textField.text];
    }
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    if (textField.tag == 100) {
//        [self.emailView.layer setBorderColor:K_BlackColor.CGColor];
//        [self.emailTextField setTextColor:K_BlackColor];
//    }
//}
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
        } else {
            [self.passAginView.layer setBorderColor:K_BlackColor.CGColor];
            [self.passAginField setTextColor:K_BlackColor];
        }
    } else {
        if (textField.tag == 100) {
            [self.emailView.layer setBorderColor:K_TextLightGrayColor.CGColor];
        } else if (textField.tag == 101) {
            [self.passView.layer setBorderColor:K_TextLightGrayColor.CGColor];
        } else {
            [self.passAginView.layer setBorderColor:K_TextLightGrayColor.CGColor];
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
    [titleLable setText:@"Create Account"];
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
        textField.delegate = self;
        textField.tag = 100;
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
        textField.delegate = self;
        textField.tag = 101;
        [textField setSecureTextEntry:YES];
        self.passTextField = textField;
        
        NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Password"];
        [attString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, @"Password".length)];
        [textField setAttributedPlaceholder:attString];
        
        lastAttribute = view.mas_bottom;
    }
    {
        UIView *view = [UIView.alloc init];
        [bottomView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(30);
            make.left.right.equalTo(bottomView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(52);
        }];
        [view setBackgroundColor:K_WhiteColor];
        [view.layer setCornerRadius:26];
        [view.layer setBorderWidth:2];
        [view.layer setBorderColor:K_TextLightGrayColor.CGColor];
        self.passAginView = view;
        
        UITextField *textField = [UITextField.alloc init];
        [view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.centerY.equalTo(view.mas_centerY);
        }];
        [textField setFont:KSFProRoundedMediumFont(16)];
        [textField setTextColor:K_BlackColor];
        textField.delegate = self;
        textField.tag = 102;
        [textField setSecureTextEntry:YES];
        self.passAginField = textField;
        
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
    [button setTitle:@"Sign up" forState:UIControlStateNormal];
}

@end
