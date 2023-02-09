//
//  WSInformationController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSInformationController.h"
#import "WSSetNameView.h"
#import "WSSetBodyView.h"
#import "WSSetTrainView.h"
#import "AppDelegate+WSAppDelegate.h"
#import "WSUploadFileRequest.h"
#import "WSAddOrEditUserInfoRequest.h"

@interface WSInformationController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *subButton;

@property (nonatomic, strong) WSSetNameView *setNameView;
@property (nonatomic, strong) WSSetBodyView *setBodyView;
@property (nonatomic, strong) WSSetTrainView *setTrainView;

@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) WSAddOrEditUserInfoRequest *saveRequest;
@end

@implementation WSInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maxPhoto = 1;
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Personal information";
    [self setUIViwe];
    
    UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(skipButtonAction:)];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:@"Skip" forState:UIControlStateNormal];
    [button.titleLabel setFont:KSFProRoundedMediumFont(14)];
    [button setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:button];
    
    CKWeakify(self);
    [self.setNameView setDidClickHeader:^{
        [weakSelf addImage];
    }];
    [self.setNameView setDidEndEdit:^(NSString * _Nonnull string) {
        weakSelf.saveRequest.data2 = string;
    }];
}
- (void)refreshView {
    if (self.photoSource.count > 0) {
        self.headerImage = self.photoSource[0];
        [self uploadImage];
    }
}
- (void)saveUserInfo {
    if (self.saveRequest.data1.length <= 0 && self.saveRequest.data2.length <= 0) {
        [MBProgressHUD showMessage:@"No modification"];
        return;
    }
    
    self.saveRequest.data3 = kUser.anonymousHeaderUrl;
    self.saveRequest.data4 = kUser.anonymousName;
    CKWeakify(self);
    [self.saveRequest asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSUserInfoModel *model = response.data;
        WSUserModel *userModel = [WSUserModel mj_objectWithKeyValues:kUser.mj_keyValues];
        userModel.changeHeaderUrl = model.data1;
        userModel.changeName = model.data2;
        
        [[WSSingleCache shareSingleCache] setUserModel:userModel];
        
        AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDele setIMUrlWithurl:model.data1 name:model.data2];
        [appDele setTabbarView];
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
        [weakSelf.setNameView.headerButton sd_setImageWithURL:[NSURL URLWithString:response.data] forState:UIControlStateNormal];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)buttonAction:(UIButton *)sender {
//    NSInteger index = self.scrollView.contentOffset.x / CK_WIDTH;
//    if (index == 0) {
//        [self.scrollView setContentOffset:CGPointMake(CK_WIDTH, 0) animated:YES];
//        [self.pageLabel setText:[NSString stringWithFormat:@"%ld/3",index + 2]];
//    } else if (index == 1) {
//        [self.scrollView setContentOffset:CGPointMake(CK_WIDTH*2, 0) animated:YES];
//        [self.pageLabel setText:[NSString stringWithFormat:@"%ld/3",index + 2]];
//        [self.subButton setTitle:@"Submit" forState:UIControlStateNormal];
//    } else {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
    [self saveUserInfo];
}
- (void)skipButtonAction:(UIButton *)sender {
//    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDele setTabbarView];
    self.saveRequest.data1 = kUser.header;
    self.saveRequest.data2 = kUser.nickname;
    [self saveUserInfo];

}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / CK_WIDTH;
    [self.pageLabel setText:[NSString stringWithFormat:@"%ld/3",index + 1]];
}
#pragma mark - SetUI
- (void)setUIViwe {
    
//    UIImageView *iconImageView = [UIImageView.alloc init];
//    [self.view addSubview:iconImageView];
//    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).mas_offset(80+KStatusBarHeight);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.height.mas_equalTo(142);
//    }];
//    [iconImageView setImage:[UIImage imageNamed:@"logo_icon"]];
    
//    UIView *bottomView = [UIView.alloc init];
//    [self.view addSubview:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(iconImageView.mas_bottom).mas_offset(50);
//        make.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
//        make.bottom.equalTo(self.view.mas_bottom).mas_offset(24);
//    }];
//    [bottomView.layer setCornerRadius:24];
//    [bottomView setBackgroundColor:K_WhiteColor];
    
    
    
    UIButton *button = [UIButton k_blackButtonWithTarget:self action:@selector(buttonAction:)];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-10-KBottomSafeHeight);
        make.height.mas_equalTo(48);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    [button.layer setCornerRadius:24];
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    self.subButton = button;
    
//    UIScrollView *scrollView = [UIScrollView.alloc init];
//    [bottomView addSubview:scrollView];
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(bottomView).insets(UIEdgeInsetsMake(24, 0, 0, 0));
//        make.bottom.equalTo(button.mas_top);
//    }];
//    [scrollView setContentSize:CGSizeMake(CK_WIDTH*3, 0)];
//    [scrollView setPagingEnabled:YES];
//    [scrollView setScrollEnabled:NO];
//    scrollView.delegate = self;
//    self.scrollView = scrollView;
    
    WSSetNameView *view1 = [WSSetNameView.alloc init];
    [self.view addSubview:view1];
    self.setNameView = view1;
    
//    WSSetBodyView *view2 = [WSSetBodyView.alloc init];
//    view2.frame = CGRectMake(CK_WIDTH, 0, CK_WIDTH, CGRectGetHeight(scrollView.frame));
//    [scrollView addSubview:view2];
//    self.setBodyView = view2;
//
//    WSSetTrainView *view3 = [WSSetTrainView.alloc init];
//    view3.frame = CGRectMake(CK_WIDTH*2, 0, CK_WIDTH, CGRectGetHeight(scrollView.frame));
//    [scrollView addSubview:view3];
//    self.setTrainView = view3;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.setNameView.frame = CGRectMake(0, 0, CK_WIDTH, 300);
//    self.setBodyView.frame = CGRectMake(CK_WIDTH, 0, CK_WIDTH, CGRectGetHeight(self.scrollView.frame));
//    self.setTrainView.frame = CGRectMake(CK_WIDTH*2 + 15, 0, CK_WIDTH - 30, CGRectGetHeight(self.scrollView.frame));
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
