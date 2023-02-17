//
//  WSMainPageController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import "WSMainPageController.h"
#import "WSMainPageView.h"
#import "WSMIneSettingView.h"
#import "WSWeatherController.h"
#import "WSDiaryDetailController.h"
#import "WSMyCoinController.h"
#import "WSInfomationController.h"
#import "WSDeleteAccountController.h"
#import "WSBlackListController.h"
#import "WSMyPersentController.h"
#import "WSMyPostController.h"
#import "AppDelegate+WSAppDelegate.h"
#import "WSPersonPController.h"
#import "WSGetUpgradeInfoRequest.h"
#import "CKBaseWebViewController.h"

@interface WSMainPageController ()
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) WSMainPageView *mainView;
@property (nonatomic, strong) WSMIneSettingView *mineView;
@end

@implementation WSMainPageController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary *textAttributes = @{
        NSFontAttributeName : KBoldFont(18),
        NSForegroundColorAttributeName : K_TextMainColor,
    };
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        barApp.titleTextAttributes = textAttributes;
        barApp.backgroundColor = UIColor.clearColor;
        barApp.shadowColor = K_WhiteColor;
        barApp.backgroundEffect = nil;
        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
        self.navigationController.navigationBar.standardAppearance = barApp;
    } else  {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage k_imageWithColor:K_WhiteColor] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    }
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mainView.nameLabel setText:[NSString stringWithFormat:@"Hello %@",kUser.name]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.rightView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.leftButton];
    
    NSDate *date = [NSDate date];

    //下面是单独获取每项的值
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger year = [comps year];
    NSInteger day = [comps day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    //获取当前时间日期展示字符串 如：2019-05-23-13:58:59
    NSString *monthString = [formatter stringFromDate:date];
    
    [self.mainView.dayLable setText:[NSString stringWithFormat:@"%02ld",day]];
    [self.mainView.timeLable setText:[NSString stringWithFormat:@"%ld.%@",year,monthString]];
    CKWeakify(self);
    [self.mainView setDidClickRecord:^{
        WSWeatherController *vc = [WSWeatherController.alloc init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.mainView setDidClickDetail:^{
        WSDiaryDetailController *vc = [WSDiaryDetailController.alloc init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.mineView setDidClickContent:^(NSInteger index) {
        if (index == 0) {
            [MBProgressHUD showMessage:@"Under development..."];
            return;
//            WSMyCoinController *vc = [WSMyCoinController.alloc init];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        if (index == 6) {
            WSDeleteAccountController *vc = [WSDeleteAccountController.alloc init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        if (index == 2) {
            WSBlackListController *vc = [WSBlackListController.alloc init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        if (index == 3) {
            WSMyPersentController *vc = [WSMyPersentController.alloc init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        if (index == 1) {
            WSMyPostController *vc = [WSMyPostController.alloc init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        if (index == 7) {
            [WSSingleCache clean];
            [[EMClient sharedClient] logout:YES];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate setLoginView];
        }
        if (index == 5) {
//            [weakSelf reloadUPdate];
            CKBaseWebViewController *vc = [[CKBaseWebViewController alloc] initWithTitle:@"Privacy Policy"];
            vc.stringUrl = @"http://cfiles.pharmaforte.xyz/agreement/diary/privacy-policy.html";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        if (index == 4) {
            CKBaseWebViewController *vc = [[CKBaseWebViewController alloc] initWithTitle:@"Terms of Use"];
            vc.stringUrl = @"http://cfiles.pharmaforte.xyz/agreement/diary/terms-of-use.html";
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    [self.mineView setDidClickPerson:^{
        WSInfomationController *vc = [WSInfomationController.alloc init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)reloadUPdate {
    WSGetUpgradeInfoRequest *request = [WSGetUpgradeInfoRequest.alloc init];
    request.deviceType = WSDeviceType;
    request.packageName = WSPackageName;
    request.version = WSVersion;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSGetUpgradeInfoModel *model = response.data;
        if ([model.needUpgrade integerValue] > 0) {
            [weakSelf showUpdateWihtModel:model];
        } else {
            [MBProgressHUD showMessage:@"No updated version"];
        }
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)showUpdateWihtModel:(WSGetUpgradeInfoModel *)model {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:model.upgradeDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 跳到浏览器web页面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.upgradeUrl] options:@{} completionHandler:nil];
//        [self _deleteConversation:indexPath];
    }];
    [clearAction setValue:[UIColor colorWithRed:245/255.0 green:52/255.0 blue:41/255.0 alpha:1.0] forKey:@"_titleTextColor"];
    [alertController addAction:clearAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction  setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    alertController.modalPresentationStyle = 0;
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - IBAction
- (void)rightButtonAction:(UIButton *)sender {
    WSPersonPController *vc = [WSPersonPController.alloc init];
    vc.userIdString = kUser.uid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)leftButtonAction:(UIButton *)sender {
    [self.mineView show];
}
#pragma mark - Getter
- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [UIView.alloc init];
        [_rightView setFrame:CGRectMake(0, 0, 44, 44)];
        [_rightView.layer setCornerRadius:22];
        [_rightView.layer setBorderWidth:1];
        [_rightView.layer setBorderColor:K_BlackColor.CGColor];
        [_rightView setClipsToBounds:YES];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(rightButtonAction:)];
        button.frame = CGRectMake(2, 2, 40, 40);
        [_rightView addSubview:button];
        [button sd_setImageWithURL:[NSURL URLWithString:kUser.headerUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"set_header_icon"]];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [button.layer setCornerRadius:20];
        [button setClipsToBounds:YES];
    }
    return _rightView;
}
- (UIButton *)leftButton {
    if (!_leftButton) {
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(leftButtonAction:)];
        button.frame = CGRectMake(0, 0, 44, 44);
        [button setImage:[UIImage imageNamed:@"home_more_icon"] forState:UIControlStateNormal];
        _leftButton = button;
    }
    return _leftButton;
}
- (WSMainPageView *)mainView {
    if (!_mainView) {
        _mainView = [WSMainPageView.alloc init];
        [self.view addSubview:_mainView];
//        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
//        }];
        [_mainView setFrame:self.view.bounds];
    }
    return _mainView;
}
- (WSMIneSettingView *)mineView {
    if (!_mineView) {
        _mineView = [WSMIneSettingView.alloc init];
    }
    return _mineView;
}
@end
