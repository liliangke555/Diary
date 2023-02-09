//
//  WSPersonPageController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/11.
//

#import "WSPersonPageController.h"
#import "WSMinePostListController.h"
#import "WSMineCollectController.h"
#import "JXPagerListRefreshView.h"
#import "WSPersonHeadView.h"

@interface WSPersonPageController ()<JXCategoryViewDelegate,JXPagerViewDelegate,JXPagerMainTableViewGestureDelegate>
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) JXCategoryTitleView *titleView;
@property (nonatomic, strong) WSPersonHeadView *personHeaderView;
@end

@implementation WSPersonPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.pagerView.frame = self.view.bounds;
}
#pragma mark - JXPagerViewDelegate
/**
 返回tableHeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 281+KStatusBarHeight;
}
/**
 返回tableHeaderView
 */
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.personHeaderView;
}
/**
 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
 */
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 50;
}
/**
 返回悬浮HeaderView
 */
- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    UIView *view = [UIView.alloc init];
    self.titleView.frame = CGRectMake(15, 0, CK_WIDTH - 30, 50);
    [view addSubview:self.titleView];
    return view;
}
/**
 返回列表的数量
 */
- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return 2;
}
/**
 根据index初始化一个对应列表实例。注意：一定要是新生成的实例！！！
 只要遵循JXPagerViewListViewDelegate即可，无论你返回的是UIView还是UIViewController都可以。
 */
- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        WSMinePostListController *vc = [WSMinePostListController.alloc init];
        return vc;
    } else {
        WSMineCollectController *vc = [WSMineCollectController.alloc init];
        return vc;
    }
}
#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.titleView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
#pragma mark - Getter
- (JXCategoryTitleView *)titleView {
    if (!_titleView) {
        _titleView = [JXCategoryTitleView.alloc init];
        _titleView.delegate = self;
//        [self.view addSubview:_titleView];
//        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_top).mas_offset(281+KStatusBarHeight);
//            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
//            make.height.mas_equalTo(50);
//        }];
//        [_titleView setFrame:CGRectMake(15, 0, CK_WIDTH - 30, 50)];
        [_titleView setBackgroundColor:[UIColor k_colorWithHex:0x885FFF1A]];
        _titleView.titles = @[@"Post",@" Collect"];
        [_titleView setTitleFont:KSystemFont(18)];
        [_titleView setTitleColor:[UIColor k_colorWithHex:0xB5A9DCFF]];
        [_titleView setTitleSelectedColor:K_TextBuleColor];
        [_titleView setTitleSelectedFont:KBoldFont(18)];
        [_titleView setCellBackgroundSelectedColor:UIColor.whiteColor];
        _titleView.titleColorGradientEnabled = YES;
        [_titleView.layer setCornerRadius:8];
        [_titleView setClipsToBounds:YES];
        
        
        // BackgroundView 样式的指示器
        JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
        backgroundView.indicatorHeight = JXCategoryViewAutomaticDimension;
        backgroundView.indicatorCornerRadius = 6;
        backgroundView.indicatorWidth = 156 / 375.0f * CK_WIDTH;
        backgroundView.indicatorHeight = 38;
        backgroundView.indicatorColor = K_WhiteColor;
        _titleView.indicators = @[backgroundView];
    }
    return _titleView;
}
- (JXPagerListRefreshView *)pagerView {
    if (!_pagerView) {
        _pagerView = [JXPagerListRefreshView.alloc initWithDelegate:self];
        _pagerView.mainTableView.gestureDelegate = self;
        [_pagerView.mainTableView setBackgroundColor:UIColor.clearColor];
        _pagerView.listContainerView.listCellBackgroundColor = UIColor.clearColor;
        [self.view addSubview:_pagerView];
        _pagerView.pinSectionHeaderVerticalOffset = KNavBarAndStatusBarHeight;
    }
    return _pagerView;
}
- (WSPersonHeadView *)personHeaderView {
    if (!_personHeaderView) {
        _personHeaderView = [WSPersonHeadView personHeadView];
        
    }
    return _personHeaderView;
}
@end
