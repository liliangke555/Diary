//
//  WSLoginController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSLoginController.h"
#import "WSLginEmailController.h"
#import "WSMoreTextAlterView.h"
#import "WSGetPpkRequest.h"
#import "WSGetAppKeyRequest.h"

#import "AppDelegate.h"
#import "AppDelegate+WSAppDelegate.h"

#import <AuthenticationServices/AuthenticationServices.h>
#import "WSAppleLoginRequest.h"
#import "WSInformationController.h"
#import "WSGetUserInfoRequest.h"
#import "CKBaseWebViewController.h"

@interface WSLoginController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

static NSString *contentString = @"These are the app’s usage agreement and user agreement. Please read and abide by it carefully. If you have any questions, please consult our customer service team.\nThese are the app’s usage agreement and user agreement. Please read and abide by it carefully. If you have any questions, please consult our customer service team.\nThese are the app’s usage agreement and user agreement. Please read and abide by it carefully. If you have any questions, please consult our customer service team.\nThese are the app’s usage agreement and user agreement. Please read and abide by it carefully. If you have any questions, please consult our customer service team.\nThese are the app’s usage agreement and user agreement. Please read and abide by it carefully. If you have any questions, please consult our customer service team.\nThese are the app’s usage agreement and user agreement. Please read and abide by it carefully. If you have any questions, please consult our customer service team.\nThese are the app’s usage agreement and user agreement. Please read and abide by it carefully. If you have any questions, please consult our customer service team.";

@implementation WSLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUIView];
    
//    NSArray *array = [UIFont familyNames];
//    NSString *familyName ;
//    NSMutableArray *fontNames = [[NSMutableArray alloc] init];
//    for(familyName in array) {
//        NSArray *names = [UIFont fontNamesForFamilyName:familyName];
//        [fontNames addObjectsFromArray:names];
//    }
//    NSLog(@"%@", fontNames);
    
//    [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(<#selector#>) name:<#(nullable NSNotificationName)#> object:<#(nullable id)#>
    
    [self getPpK];
    
    [self showAlterView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)emailButtonAction:(UIButton *)sender {
    WSLginEmailController *vc = [WSLginEmailController.alloc init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)showAlterView {
    NSURL *html = [[NSBundle mainBundle] URLForResource:@"EULA" withExtension:@"html"];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithURL:html options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    WSMoreTextAlterView *view = [WSMoreTextAlterView.alloc initWithTitle:@"Eula" detail:attrStr];
    [view show];
}
- (void)getPpK {
    WSGetPpkRequest *request = [WSGetPpkRequest.alloc init];
    request.version = WSVersion;
    request.type = WSDeviceType;
    request.pkgName = WSPackageName;
    request.notEncryption = YES;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        
        WSGetPpkModel *model = response.data;
        
        NSString *startPubKey = [model.content substringToIndex:50];
        NSString *currentString = [model.content substringFromIndex:50+model.customNum];
        NSString *endPubKey = [currentString substringWithRange:NSMakeRange(0, currentString.length - model.customNum)];
        NSString *pubKey = [NSString stringWithFormat:@"%@%@",startPubKey,endPubKey];
        [[NSUserDefaults standardUserDefaults] setObject:pubKey forKey:WSPublicKey];
        
        NSString *startPrivateKey = [model.content2 substringToIndex:50];
        currentString = [model.content2 substringFromIndex:50+model.customNum];
        NSString *centerPrivateKey = [currentString substringWithRange:NSMakeRange(0, currentString.length - 50 - model.customNum)];
        NSString *endPrivateKey = [currentString substringWithRange:NSMakeRange(currentString.length - 50, 50)];
        NSString *privateKey = [NSString stringWithFormat:@"%@%@%@",startPrivateKey,centerPrivateKey,endPrivateKey];
        [[NSUserDefaults standardUserDefaults] setObject:privateKey forKey:WSPrivateKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self getAppKey];
        
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)getAppKey {
    WSGetAppKeyRequest *request = [WSGetAppKeyRequest.alloc init];
    request.version =WSVersion;
    request.pkgName = WSPackageName;
    request.hideLoadingView = YES;
//    request.notEncryption = YES;
    request.type = @"2";
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSGetAppKeyModel *model = response.data;
        [[NSUserDefaults standardUserDefaults] setObject:model.emKey forKey:WSEmKey];
        [[NSUserDefaults standardUserDefaults] setObject:model.agKey forKey:WSAgKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate initEaIMKit];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)loginApple:(ASAuthorizationAppleIDCredential *)credential {
    NSString *user = credential.user;
    NSData *identifyToken = credential.identityToken;
    NSData *authCode = credential.authorizationCode;
    NSString *codeStr = [[NSString alloc] initWithData:authCode encoding:NSUTF8StringEncoding];
    NSString *identifyTokenStr = [[NSString alloc] initWithData:identifyToken encoding:NSUTF8StringEncoding];
    NSString *name = [NSString stringWithFormat:@"%@%@",credential.fullName.givenName?:@"",credential.fullName.familyName?:@""];
    
    WSAppleLoginRequest *request = [WSAppleLoginRequest.alloc init];
    request.appId = WSAPPID;
    request.allAppId = WSAPPID;
    request.deviceType = WSDeviceType;
    request.packageName = WSPackageName;
    request.version = WSVersion;
    request.thirdId = user;
    request.appleCode = codeStr;
    request.nickname = name;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSUserModel *userModel = response.data;
        
        AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDele registEasIMWithName:userModel.uid password:userModel.uid];
        
        if ([userModel.profileStatus integerValue] == 1) {
            [WSSingleCache shareSingleCache].userModel = userModel;
            [WSSingleCache shareSingleCache].token = kUser.token;
            [weakSelf getUserInfo];
        } else {
            
            userModel.anonymousName = [NSString stringWithFormat:@"User_%05u",arc4random() % 10000];
            userModel.anonymousHeaderUrl = userModel.header;
            [WSSingleCache shareSingleCache].userModel = userModel;
            [WSSingleCache shareSingleCache].token = kUser.token;
            WSInformationController *vc = [WSInformationController.alloc init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failHandler:^(BaseResponse * _Nonnull response) {
        
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
#pragma mark -IBAction
- (void)appleButtonAction:(UIButton *)sender {
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *provider = [ASAuthorizationAppleIDProvider new];
        ASAuthorizationAppleIDRequest *request = provider.createRequest;
        request.requestedScopes = @[ASAuthorizationScopeEmail, ASAuthorizationScopeFullName];
        ASAuthorizationController *vc = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        vc.delegate = self;
        vc.presentationContextProvider = self;
        [vc performRequests];
    }
}
- (void)useButtonAction:(UIButton *)sender {
    CKBaseWebViewController *vc = [[CKBaseWebViewController alloc] initWithTitle:@"Terms of Use"];
    vc.stringUrl = @"http://cfiles.pharmaforte.xyz/agreement/diary/terms-of-use.html";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)privacyButtonAction:(UIButton *)sender {
    CKBaseWebViewController *vc = [[CKBaseWebViewController alloc] initWithTitle:@"Privacy Policy"];
    vc.stringUrl = @"http://cfiles.pharmaforte.xyz/agreement/diary/privacy-policy.html";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *user = credential.user;
        NSData *identifyToken = credential.identityToken;
        NSData *authCode = credential.authorizationCode;
        NSString *codeStr = [[NSString alloc] initWithData:authCode encoding:NSUTF8StringEncoding];
        NSString *identifyTokenStr = [[NSString alloc] initWithData:identifyToken encoding:NSUTF8StringEncoding];
        NSString *name = [NSString stringWithFormat:@"%@%@",credential.fullName.givenName,credential.fullName.familyName];
        [self loginApple:credential];
        NSLog(@"user = %@, authCode = %@", user, codeStr);
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *credential = authorization.credential;
        NSLog(@"password = %@", credential.password);
    } else {
        NSLog(@"授权信息不符");
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    NSLog(@"[Wing] error = %@", error);
}

- (void)setUIView {
    UIImageView *imageView = [UIImageView.alloc init];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_offset(99*CK_HEIGHT_Sales);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [imageView setImage:[UIImage imageNamed:@"login_top_icon"]];
    
    UIButton *emailBUtton = [UIButton k_blackButtonWithTarget:self action:@selector(emailButtonAction:)];
    [self.view addSubview:emailBUtton];
    [emailBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).mas_offset(80*CK_HEIGHT_Sales);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.height.mas_equalTo(48);
    }];
    [emailBUtton setTitle:@"Sign in with Email" forState:UIControlStateNormal];
    [emailBUtton.layer setCornerRadius:24];
    
    UIButton *appleButton = [UIButton k_whiteButtonWithTarget:self action:@selector(appleButtonAction:)];
    [self.view addSubview:appleButton];
    [appleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailBUtton.mas_bottom).mas_offset(25*CK_HEIGHT_Sales);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.height.mas_equalTo(48);
    }];
    [appleButton setTitle:@"   Sign in with Apple" forState:UIControlStateNormal];
    [appleButton setImage:[UIImage imageNamed:@"login_apple_icon"] forState:UIControlStateNormal];
    [appleButton.layer setCornerRadius:24];
    [appleButton setHidden:YES];
    
    UILabel *label = [UILabel.alloc init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(appleButton.mas_bottom).mas_offset(70*CK_HEIGHT_Sales);
    }];
    [label setText:@" & "];
    [label setFont:KSFProRoundedBoldFont(15)];
    [label setTextColor:K_TextDrakGrayColor];
    
    UIButton *useButton = [UIButton k_buttonWithTarget:self action:@selector(useButtonAction:)];
    [self.view addSubview:useButton];
    [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(label.mas_left);
    }];

    [useButton setTitleColor:K_TextDrakGrayColor forState:UIControlStateNormal];
    [useButton.titleLabel setFont:KSFProRoundedBoldFont(15)];
    NSMutableAttributedString *userAttString = [NSMutableAttributedString.alloc initWithString:@"Terms of Use"];
    [userAttString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, @"Terms of Use".length)];
    [useButton setAttributedTitle:userAttString forState:UIControlStateNormal];
    
    {
        UIButton *useButton = [UIButton k_buttonWithTarget:self action:@selector(privacyButtonAction:)];
        [self.view addSubview:useButton];
        [useButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label.mas_centerY);
            make.left.equalTo(label.mas_right);
        }];
        [useButton setTitleColor:K_TextDrakGrayColor forState:UIControlStateNormal];
        [useButton.titleLabel setFont:KSFProRoundedBoldFont(15)];
        NSMutableAttributedString *userAttString = [NSMutableAttributedString.alloc initWithString:@"Privacy Policy"];
        [userAttString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, @"Privacy Policy".length)];
        [useButton setAttributedTitle:userAttString forState:UIControlStateNormal];
    }
}

@end
