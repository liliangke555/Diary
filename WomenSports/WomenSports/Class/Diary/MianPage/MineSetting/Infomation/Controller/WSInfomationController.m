//
//  WSInfomationController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/11.
//

#import "WSInfomationController.h"
#import "WSAddOrEditUserInfoRequest.h"
#import "WSUploadFileRequest.h"
#import "WSGetUserInfoRequest.h"
#import "AppDelegate.h"

@interface WSInfomationController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageview;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIView *textBackView;
@property (weak, nonatomic) IBOutlet UITextField *tetField;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) WSAddOrEditUserInfoRequest *saveRequest;
@end

@implementation WSInfomationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maxPhoto = 1;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Personal information";
    [self doneButton];
    NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Nickname"];
    [attString addAttribute:NSFontAttributeName value:KSFProRoundedMediumFont(14) range:NSMakeRange(0, @"Nickname".length)];
    [attString addAttribute:NSForegroundColorAttributeName value:K_TextLightGrayColor range:NSMakeRange(0, @"Nickname".length)];
    [self.tetField setAttributedPlaceholder:attString];
    [self.tetField setFont:KSFProRoundedMediumFont(14)];
    self.tetField.delegate = self;
    
    [self.textBackView.layer setCornerRadius:8];
    [self.textBackView setClipsToBounds:YES];
    
    [self.headerImageview.layer setCornerRadius:42];
    [self.headerImageview setClipsToBounds:YES];
    
    [self getUserInfo];
}
- (void)getUserInfo {
    WSGetUserInfoRequest *request = [WSGetUserInfoRequest.alloc init];
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSUserInfoModel *model = response.data;
        NSString *isString = model.id;
        if (isString.length > 0) {
            weakSelf.saveRequest = [WSAddOrEditUserInfoRequest mj_objectWithKeyValues:model.mj_keyValues];
            [weakSelf.headerImageview sd_setImageWithURL:[NSURL URLWithString:model.data1]];
            weakSelf.tetField.text = model.data2;
        }
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)saveUserInfo {
    if (self.saveRequest.data1.length <= 0 && self.saveRequest.data2.length <= 0) {
        [MBProgressHUD showMessage:@"No modification"];
        return;
    }
    CKWeakify(self);
    [self.saveRequest asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSUserInfoModel *model = response.data;
        WSUserModel *userModel = [WSUserModel mj_objectWithKeyValues:kUser.mj_keyValues];
        userModel.changeHeaderUrl = model.data1;
        userModel.changeName = model.data2;
        
        [[WSSingleCache shareSingleCache] setUserModel:userModel];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate setIMUrlWithurl:model.data1 name:model.data2];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)uploadImage {
    WSUploadFileRequest *request = [WSUploadFileRequest.alloc init];
    NSData *imageData;
    NSString *mimetype;
    if (UIImagePNGRepresentation(self.headerImage) != nil) {
        mimetype = @"image/png";
        imageData = UIImagePNGRepresentation(self.headerImage);
    }else{
        mimetype = @"image/jpeg";
        imageData = UIImageJPEGRepresentation(self.headerImage, 1);
    }
    CKWeakify(self);
    [MBProgressHUD showLoadingWithMessage:@"Uploading..."];
    [request uploadWitImagedData:imageData uploadName:@"file" progress:^(NSProgress * _Nonnull progress) {
        
    } successHandler:^(BaseResponse * _Nonnull response) {
        weakSelf.saveRequest.data1 = response.data;
        [weakSelf.headerImageview sd_setImageWithURL:[NSURL URLWithString:response.data]];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)refreshView {
    if (self.photoSource.count > 0) {
        self.headerImage = self.photoSource[0];
        [self uploadImage];
    }
}
#pragma mark - IBAction
- (void)doneButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self saveUserInfo];
}
- (IBAction)cameraButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self addImage];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.saveRequest.data2 = textField.text;
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
        [_doneButton setTitle:@"Confirm" forState:UIControlStateNormal];
        [_doneButton.layer setCornerRadius:24];
    }
    return _doneButton;
}
- (WSAddOrEditUserInfoRequest *)saveRequest {
    if (!_saveRequest) {
        _saveRequest = [WSAddOrEditUserInfoRequest.alloc init];
        _saveRequest.packageName = WSPackageName;
        _saveRequest.deviceType = WSDeviceType;
        
    }
    return _saveRequest;
}
@end
