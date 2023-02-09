//
//  WSHomeController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSHomeController.h"
#import "WSHomeHeaderView.h"
#import "WSHomeView.h"
#import "WSYogaController.h"
#import "WSMeditationController.h"
#import "WSTargetController.h"
#import "WSPersonPageController.h"
#import "WSMIneSettingView.h"

@interface WSHomeController ()
@property (nonatomic, strong) WSHomeHeaderView *headerView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) WSHomeView *homeView;
@property (nonatomic, strong) WSMIneSettingView *mineView;
@end

@implementation WSHomeController
// 必须在viewDidAppear或者viewWillAppear中写，因为每次都需要将delegate设为当前界面
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.headerView];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.rightButton];
    CKWeakify(self);
    [self.homeView setDidSelectedYoga:^{
        WSYogaController *vc = [WSYogaController.alloc init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.homeView setDidSelectedMeditate:^{
        WSMeditationController *vc = [WSMeditationController.alloc init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.homeView setDidSelectedRealx:^{
        WSMeditationController *vc = [WSMeditationController.alloc init];
        vc.realxPage = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.homeView setDidSelectedShap:^{
        WSYogaController *vc = [WSYogaController.alloc init];
        vc.shapPage = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.homeView setDidSelectedTarget:^{
        WSTargetController *vc = [WSTargetController.alloc init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.mineView setDidClickPerson:^{
        WSPersonPageController *vc = [WSPersonPageController.alloc init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - IBAction
- (void)rightButtonAction:(UIButton *)sender {
    [self.mineView show];
}
- (void)tapgesAction:(UITapGestureRecognizer *)sender {
    [self.mineView show];
}
#pragma mark - Getter
- (WSHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [WSHomeHeaderView.alloc init];
//        _headerView.frame = CGRectMake(0, 0, 120, 44);
        [_headerView setUserInteractionEnabled:YES];
        [_headerView addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(tapgesAction:)]];
    }
    return _headerView;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton k_buttonWithTarget:self action:@selector(rightButtonAction:)];
        _rightButton.frame = CGRectMake(0, 0, 44, 44);
        [_rightButton setImage:[UIImage imageNamed:@"home_more_icon"] forState:UIControlStateNormal];
    }
    return _rightButton;
}
- (WSHomeView *)homeView {
    if (!_homeView) {
        _homeView = [WSHomeView.alloc init];
        [self.view addSubview:_homeView];
        [_homeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(KNavBarAndStatusBarHeight, 0, 0, 0));
        }];
    }
    return _homeView;
}
- (WSMIneSettingView *)mineView {
    if (!_mineView) {
        _mineView = [WSMIneSettingView.alloc init];
    }
    return _mineView;
}

@end
