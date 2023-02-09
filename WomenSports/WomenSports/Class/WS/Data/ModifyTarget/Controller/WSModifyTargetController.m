//
//  WSModifyTargetController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/10.
//

#import "WSModifyTargetController.h"
#import "WSSetTrainView.h"
#import "WSDailyGoalView.h"

@interface WSModifyTargetController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WSSetTrainView *setTainView;
@property (nonatomic, strong) WSDailyGoalView *dailyGoalView;
@end

@implementation WSModifyTargetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Modify target";
    [self.scrollView addSubview:self.setTainView];
    [self.scrollView addSubview:self.dailyGoalView];
}

#pragma mark - Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView.alloc init];
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(KNavBarAndStatusBarHeight, 0, 0, 0));
        }];
        [_scrollView setContentSize:CGSizeMake(CK_WIDTH, 600)];
    }
    return _scrollView;
}
- (WSSetTrainView *)setTainView {
    if (!_setTainView) {
        _setTainView = [WSSetTrainView.alloc init];
        _setTainView.frame = CGRectMake(15, 20, CK_WIDTH-30, 354);
        _setTainView.layer.cornerRadius = 12;
        [_setTainView setBackgroundColor:K_WhiteColor];
        _setTainView.layer.shadowColor = [UIColor k_colorWithHex:0xCCCCCC23].CGColor;
        _setTainView.layer.shadowOffset = CGSizeMake(0,0);
        _setTainView.layer.shadowOpacity = 1;
        _setTainView.layer.shadowRadius = 8;
        [_setTainView setClipsToBounds:YES];
        _setTainView.layer.masksToBounds = NO;
    }
    return _setTainView;
}
- (WSDailyGoalView *)dailyGoalView {
    if (!_dailyGoalView) {
        _dailyGoalView = [WSDailyGoalView.alloc init];
        _dailyGoalView.frame = CGRectMake(15, 394, CK_WIDTH - 30, 204);
        [_dailyGoalView setBackgroundColor:K_WhiteColor];
        _dailyGoalView.layer.shadowColor = [UIColor k_colorWithHex:0xCCCCCC23].CGColor;
        _dailyGoalView.layer.shadowOffset = CGSizeMake(0,0);
        _dailyGoalView.layer.shadowOpacity = 1;
        _dailyGoalView.layer.shadowRadius = 8;
        _dailyGoalView.layer.cornerRadius = 12;
        [_dailyGoalView setClipsToBounds:YES];
        _dailyGoalView.layer.masksToBounds = NO;
    }
    return _dailyGoalView;
}
@end
