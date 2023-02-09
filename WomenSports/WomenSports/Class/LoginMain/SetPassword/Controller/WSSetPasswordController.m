//
//  WSSetPasswordController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSSetPasswordController.h"
#import "WSConfirmPassController.h"
#import "WSEmailCanBeRequest.h"

@interface WSSetPasswordController ()<UITextFieldDelegate>{
    dispatch_source_t _timer;
}
@property (nonatomic, strong) UILabel *timeoutLabel;
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UIView *passView;
@property (nonatomic, strong) UITextField *passTextField;
@end

@implementation WSSetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"Set Password";
    [self setUIViwe];
}
- (void)emailCanBe:(NSString *)email {
    WSEmailCanBeRequest *request = [WSEmailCanBeRequest.alloc init];
    request.email = email;
    request.deviceType = WSDeviceType;
    request.packageName = WSPackageName;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSEmailCanBeModel *model = response.data;
        if (model.content) {
            WSConfirmPassController *vc = [WSConfirmPassController.alloc init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessage:@"Verification code verification failed!"];
            [weakSelf.passView.layer setBorderColor:K_TextRedColor.CGColor];
            [weakSelf.passTextField setTextColor:K_TextRedColor];
        }
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)buttonAction:(UIButton *)sender {
    [self emailCanBe:self.emailTextField.text];
}
- (void)resendAction:(UIButton *)sender {
    
    if (_timer == nil) {
        CKWeakify(self);
        __block NSInteger timeout = 60; // 倒计时时间
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
                    dispatch_source_cancel(self->_timer);
                    self->_timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.timeoutLabel.text = @"";
                    });
                } else { // 倒计时重新计算 时/分/秒
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.timeoutLabel setText:[NSString stringWithFormat:@"Send(%ld)",timeout]];
                    });
                    timeout--; // 递减 倒计时-1(总时间以秒来计算)
                }
            });
            dispatch_resume(_timer);
        }
    }
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
    [titleLable setText:@"Set Password"];
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
            make.left.right.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 58+18));
            make.centerY.equalTo(view.mas_centerY);
        }];
        [textField setFont:KSFProRoundedMediumFont(16)];
        [textField setTextColor:K_BlackColor];
        textField.tag = 101;
        textField.delegate = self;
        self.passTextField = textField;
        
        NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Verification Code"];
        [attString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, @"Verification Code".length)];
        [textField setAttributedPlaceholder:attString];
        
        lastAttribute = view.mas_bottom;
        
        UILabel *timeoutLabel = [UILabel.alloc init];
        [view addSubview:timeoutLabel];
        [timeoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.right.equalTo(view.mas_right).mas_offset(-18);
        }];
        [timeoutLabel setText:@""];
        [timeoutLabel setTextColor:K_TextLightGrayColor];
        [timeoutLabel setFont:KSFProRoundedMediumFont(14)];
        self.timeoutLabel = timeoutLabel;
    }
    
    
    UIButton *button = [UIButton k_blackButtonWithTarget:self action:@selector(buttonAction:)];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView.mas_bottom).mas_offset(-10-KBottomSafeHeight);
        make.height.mas_equalTo(48);
        make.left.right.equalTo(bottomView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    [button.layer setCornerRadius:24];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    
    {
        UIView *view = [UIView.alloc init];
        [bottomView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView.mas_centerX);
            make.top.equalTo(lastAttribute).mas_offset(20*CK_HEIGHT_Sales);
        }];
        
        UILabel *label = [UILabel.alloc init];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(view).insets(UIEdgeInsetsZero);
        }];
        [label setText:@"Didn’t receive the code? "];
        [label setFont:KSystemFont(16)];
        [label setTextColor:K_TextLightGrayColor];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(resendAction:)];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(view).insets(UIEdgeInsetsZero);
            make.left.equalTo(label.mas_right);
        }];
        [button setTitle:@"Resend" forState:UIControlStateNormal];
        [button setTitleColor:K_BlackColor forState:UIControlStateNormal];
        [button.titleLabel setFont:KSystemFont(16)];
    }
}

@end
