//
//  WSDeleteAccountController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSDeleteAccountController.h"
#import "WSDeleteUsersRequest.h"
#import "WSFeedbackRequest.h"
#import "AppDelegate+WSAppDelegate.h"

@interface WSDeleteAccountController ()<UITextViewDelegate>
{
    dispatch_group_t _group;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UIView *textBackView;

@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation WSDeleteAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.textBackView.layer setCornerRadius:8];
    [self.textBackView setClipsToBounds:YES];
    
    [self.placeLabel setFont:KSFProRoundedMediumFont(14)];
    
    [self.textView setFont:KSFProRoundedMediumFont(14)];
    [self.textView setTextColor:K_BlackColor];
    
    self.textView.delegate = self;
    
    [self doneButton];
    
    
}
- (void)deleteUser {
    WSDeleteUsersRequest *request = [WSDeleteUsersRequest.alloc init];
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    } failHandler:^(BaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
- (void)feedback {
    WSFeedbackRequest *request = [WSFeedbackRequest.alloc init];
    request.content = self.textView.text;
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    } failHandler:^(BaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
- (void)doneButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    _group = dispatch_group_create();
    [self deleteUser];
    if (self.textView.text.length > 0) {
        [self feedback];
    }
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        [WSSingleCache clean];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate setLoginView];
    });
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    if (pointLength > 0) {
        self.placeLabel.hidden = YES;
    } else {
        self.placeLabel.hidden = NO;
    }
    return YES;
}
#pragma mark - Getter
- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton k_blackButtonWithTarget:self action:@selector(doneButtonAction:)];
        [self.view addSubview:_doneButton];
        [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textBackView.mas_bottom).mas_offset(145);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(48);
        }];
        [_doneButton setTitle:@"Delete account" forState:UIControlStateNormal];
        [_doneButton.layer setCornerRadius:24];
        UIImage *img = [UIImage k_imageWithColor:K_TextRedColor];
        [_doneButton setBackgroundImage:img forState:UIControlStateNormal];
    }
    return _doneButton;
}
@end
