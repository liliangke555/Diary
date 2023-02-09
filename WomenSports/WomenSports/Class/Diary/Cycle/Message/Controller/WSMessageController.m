//
//  WSMessageController.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSMessageController.h"
#import "WSNewsController.h"
#import "WSFollowingController.h"
#import "WSFollowerController.h"

@interface WSMessageController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,EaseIMKitManagerDelegate,EMChatManagerDelegate>
@property (nonatomic, strong) JXCategoryNumberView *categoryView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WSNewsController *newsViewController;
@property (nonatomic, strong) WSFollowingController *followingController;
@property (nonatomic, strong) WSFollowerController *followerController;
@end

@implementation WSMessageController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)dealloc {
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EaseIMKitManager shareInstance] removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self.categoryView reloadData];
    [self.listContainerView reloadData];
    //监听消息接收，主要更新会话tabbaritem的badge
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EaseIMKitManager shareInstance] addDelegate:self];
}
- (void)setupView {
    UILabel *label = [UILabel.alloc init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).mas_offset(15);
        make.height.mas_equalTo(46);
    }];
    [label setText:@"Message"];
    [label setFont:KSFProRoundedBoldFont(30)];
    [label setTextColor:K_BlackColor];
    self.titleLabel = label;
}
#pragma mark - JXCategoryListContainerViewDelegate
// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 3;
}
// 根据下标 index 返回对应遵守并实现 `JXCategoryListContentViewDelegate` 协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return self.newsViewController;
    } else if (index == 1) {
        return self.followingController;
    } else {
        return self.followerController;
    }
}
#pragma mark - EaseIMKitManagerDelegate

- (void)conversationsUnreadCountUpdate:(NSInteger)unreadCount {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakself.categoryView.counts = @[unreadCount > 0 ? @(unreadCount).stringValue : @"",@"",@""];
        [weakself.categoryView reloadData];
    });
}
#pragma mark - EMChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages {
    
}

//　收到已读回执
- (void)messagesDidRead:(NSArray *)aMessages {
    [self _loadConversationTabBarItemBadge];
}

- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    [self _loadConversationTabBarItemBadge];
}

- (void)onConversationRead:(NSString *)from to:(NSString *)to {
    [self _loadConversationTabBarItemBadge];
}
#pragma mark - Private

- (void)_loadConversationTabBarItemBadge {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    self.categoryView.counts = @[unreadCount > 0 ? @(unreadCount).stringValue : @"",@"",@""];
    [self.categoryView reloadData];
}
#pragma mark - Getter
- (JXCategoryNumberView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryNumberView alloc] init];
        _categoryView.delegate = self;
        [self.view addSubview:_categoryView];
        [_categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 126*CK_WIDTH_Sales));
            make.height.mas_equalTo(60);
        }];
        [_categoryView setBackgroundColor:K_WhiteColor];
        _categoryView.titles = @[@"News",@"Following",@"Follower"];

//        _categoryView.numberLabelOffset = CGPointMake(20, 8);
//        _categoryView.counts = @[@"",@"",@""];
        _categoryView.shouldMakeRoundWhenSingleNumber = YES;
        _categoryView.numberLabelHeight = 16;
        _categoryView.numberBackgroundColor = [UIColor k_colorWithHex:0x11D7E1FF];
        _categoryView.numberLabelFont = KSFProRoundedMediumFont(12);
        _categoryView.titleColorGradientEnabled = YES;
        [_categoryView setTitleFont:KSFProRoundedBoldFont(16)];
        [_categoryView setTitleColor:[UIColor k_colorWithHex:0xD9D9D9FF]];
        [_categoryView setTitleSelectedColor:K_BlackColor];
        
        
        UIView *lineView = [UIView.alloc init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_categoryView.mas_bottom);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(1);
        }];
        [lineView setBackgroundColor:K_SepLineColor];
    }
    return _categoryView;
}
- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        [_listContainerView.scrollView setScrollEnabled:NO];
        [self.view addSubview:_listContainerView];
        [_listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.categoryView.mas_bottom).mas_offset(1);
            make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        // 关联到 categoryView
        self.categoryView.listContainer = _listContainerView;
    }
    return _listContainerView;
}
- (WSNewsController *)newsViewController {
    if (!_newsViewController) {
        _newsViewController = [WSNewsController.alloc init];
        CKWeakify(self);
        [_newsViewController setDeleteConversationCompletion:^(BOOL isDelete) {
            [weakSelf _loadConversationTabBarItemBadge];
        }];
        [_newsViewController setReloadUnReadNum:^(NSInteger num) {
            NSString *string = num > 0 ? [NSString stringWithFormat:@"%ld",num] : @"";
            weakSelf.categoryView.counts = @[string,@"",@""];
            [weakSelf.categoryView reloadData];
        }];
    }
    return _newsViewController;
}
- (WSFollowingController *)followingController {
    if (!_followingController) {
        _followingController = [WSFollowingController.alloc init];
    }
    return _followingController;;
}
- (WSFollowerController *)followerController {
    if (!_followerController) {
        _followerController = [WSFollowerController.alloc init];
    }
    return _followerController;
}
@end
