//
//  WSPersonPageController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSPersonPController.h"
#import "WSPersonPageView.h"
#import "WSPersonPostTableCell.h"
#import "WSSheetView.h"
#import "WSGetUserInfoByIDRequest.h"
#import "WSCheckFollowRequest.h"
#import "WSCycleListRequest.h"
#import "WSDeleteCycleRequest.h"
#import "WSCycleAddOrEditRequest.h"
#import "WSCycleDetailController.h"
#import "WSAddBlacklistRequest.h"
#import "WSFollowingRequest.h"
#import "WSCancelFollowRequest.h"
#import "WSBlackListRepoRequest.h"
#import "WSChatController.h"

@interface WSPersonPController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    dispatch_group_t _group;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WSPersonPageView *personView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) WSUserInfoModel *userModel;
@property (nonatomic, assign) BOOL isFollow;
@end

@implementation WSPersonPController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray array];
    [self navView];
    CKWeakify(self);
    _group = dispatch_group_create();
    self.tableView.mj_header = [CKRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf reloadUserData];
        [weakSelf reloadList];
        if (![kUser.uid isEqualToString:self.userIdString]) {
            [weakSelf reloadFollowing];
        }
        dispatch_group_notify(self->_group, dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        });
    }];
    self.tableView.mj_footer = [CKRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf reloadList];
    }];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark -
- (void)reloadUserData {
    WSGetUserInfoByIDRequest *request = [WSGetUserInfoByIDRequest.alloc init];
    request.userId = self.userIdString;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSUserInfoModel *userModel = response.data;
        weakSelf.userModel = userModel;
        [weakSelf.personView setUserModel:userModel];
        dispatch_group_leave(self->_group);
    } failHandler:^(BaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
- (void)reloadFollowing {
    WSCheckFollowRequest *request = [WSCheckFollowRequest.alloc init];
    request.userId = self.userIdString;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        BOOL isFollow = [response.data boolValue];
        weakSelf.isFollow = isFollow;
        weakSelf.personView.followUser = isFollow;
        dispatch_group_leave(self->_group);
    } failHandler:^(BaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
- (void)followingUser {
    WSFollowingRequest *request = [WSFollowingRequest.alloc init];
    request.userId = self.userIdString;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        weakSelf.isFollow = YES;
        weakSelf.personView.followUser = YES;
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)cancelFollow {
    WSCancelFollowRequest *requet = [WSCancelFollowRequest.alloc init];
    requet.userId = self.userIdString;
    CKWeakify(self);
    [requet asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        weakSelf.isFollow = NO;
        weakSelf.personView.followUser = NO;
    } failHandler:^(BaseResponse * _Nonnull response) {
    }];
}
- (void)reloadList {
    WSCycleListRequest *request = [WSCycleListRequest.alloc init];
    request.deviceType = WSDeviceType;
    request.packageName = WSPackageName;
    request.data20 = @"2";
    request.data8 = @"0";
    request.sort = @[@"data3,desc"];
    request.size = 20;
    request.page = self.pageNum;
    request.userId = self.userIdString;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        if (weakSelf.pageNum == 1) {
            [weakSelf.dataSource removeAllObjects];
        }
        WSCycleListModel *listModel = response.data;
        if (listModel.totalPages == weakSelf.pageNum) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            weakSelf.pageNum ++;
        }
        [weakSelf.dataSource addObjectsFromArray:listModel.data];
        dispatch_group_leave(self->_group);
    } failHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_footer endRefreshing];
        dispatch_group_leave(self->_group);
    }];
}
- (void)deleteCycleWithModel:(WSCycleDetailModel *)model {
    WSDeleteCycleRequest *request = [WSDeleteCycleRequest.alloc init];
    request.id = model.id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.dataSource removeObject:model];
        [weakSelf.tableView reloadData];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)uploadDetailWithModel:(WSCycleDetailModel *)model {
    WSCycleAddOrEditRequest *request = [WSCycleAddOrEditRequest mj_objectWithKeyValues:model.mj_keyValues];
    request.data8 = @"1";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.dataSource removeObject:model];
        [weakSelf.tableView reloadData];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)addBlackList {
    WSAddBlacklistRequest *request = [WSAddBlacklistRequest.alloc init];
    request.userId = self.userIdString;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [MBProgressHUD showSuccessfulWithMessage:@""];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)repoWithUserContent:(NSString *)content {
    WSBlackListRepoRequest *request = [WSBlackListRepoRequest.alloc init];
    request.userId = self.userIdString;
    request.content = content;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [MBProgressHUD showSuccessfulWithMessage:@""];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}

#pragma mark - IBAction
- (void)backBUttonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)moreButtonAction:(UIButton *)sender {
    [self showMoreSheet];
}

- (void)showReportSheet {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        NSString *string = @"Other";
        if (index == 0) {
            string = @"Pornographic vulgar";
        } else if (index == 1) {
            string = @"Advertising fraud";
        } else if (index == 2) {
            string = @"Politically sensitive";
        } else if (index == 3) {
            string = @"Bloody terror";
        } else if (index == 4) {
            string = @"Incite war and abuse";
        }
        [weakSelf repoWithUserContent:string];
    };
    NSArray *items = @[MMItemMake(@"Pornographic vulgar", MMItemTypeNormal, block),
                       MMItemMake(@"Advertising fraud", MMItemTypeNormal, block),
                       MMItemMake(@"Politically sensitive", MMItemTypeNormal, block),
                       MMItemMake(@"Bloody terror", MMItemTypeNormal, block),
                       MMItemMake(@"Incite war and abuse", MMItemTypeNormal, block),
                       MMItemMake(@"Other", MMItemTypeNormal, block),
    ];
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    view.cancelColor = K_TextLightGrayColor;
    [view show];
}
- (void)showMoreSheet {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 2) {
            [weakSelf showReportSheet];
        }
        if (index == 3) {
            [weakSelf addBlackList];
        }
        if (index == 1) {
            WSChatController *controller = [WSChatController.alloc initWithConversationId:weakSelf.userIdString conversationType:EMConversationTypeChat];
            controller.navigationItem.title = weakSelf.userModel.data2;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
        if (index == 0) {
            if (weakSelf.isFollow) {
                [weakSelf cancelFollow];
            } else {
                [weakSelf followingUser];
            }
        }
    };
    NSString *string = @"Follow";
    if (self.isFollow) {
        string = @"Unfollow";
    }
    NSArray *items = @[MMItemMake(string, MMItemTypeNormal, block),
                       MMItemMake(@"Private letter", MMItemTypeNormal, block),
                       MMItemMake(@"Report", MMItemTypeNormal, block),
                       MMItemMake(@"Block", MMItemTypeNormal, block),
    ];
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    view.cancelColor = K_TextLightGrayColor;
    [view show];
}
- (void)showItemMoreWithModel:(WSCycleDetailModel *)model {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
            [weakSelf deleteCycleWithModel:model];
        } else {
            [weakSelf uploadDetailWithModel:model];
        }
    };
    NSArray *items = @[MMItemMake(@"Delete", MMItemTypeHighlight, block),
                       MMItemMake(@"Hide this post", MMItemTypeNormal, block),
    ];
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    view.cancelColor = K_TextLightGrayColor;
    [view show];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSPersonPostTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSPersonPostTableCell.class)];
    CKWeakify(self);
    [cell setDidClickMore:^(WSCycleDetailModel *detailModel){
        [weakSelf showItemMoreWithModel:detailModel];
    }];
    [cell setModel:self.dataSource[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WSCycleDetailController *vc = [WSCycleDetailController.alloc init];
    vc.detailModel = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([kUser.uid isEqualToString:self.userIdString]) {
        [self.personView setFrame:CGRectMake(0, 0, CK_WIDTH, 231+KStatusBarHeight)];
    } else {
        [self.personView setFrame:CGRectMake(0, 0, CK_WIDTH, 265+KStatusBarHeight)];
    }
    NSLog(@"%@",NSStringFromCGRect(self.personView.frame));
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 100) {
        [self.navView setBackgroundColor:K_WhiteColor];
        [self.backButton setImage:[UIImage imageNamed:@"navigation_back_white"] forState:UIControlStateNormal];
        if (!self.mienPage) {
            [self.moreButton setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
        }
    } else {
        [self.navView setBackgroundColor:UIColor.clearColor];
        [self.backButton setImage:[UIImage imageNamed:@"person_back_icon"] forState:UIControlStateNormal];
        if (!self.mienPage) {
            [self.moreButton setImage:[UIImage imageNamed:@"person_more_icon"] forState:UIControlStateNormal];
        }
    }
}
#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_back_icon"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"There is nothing for now, go to\nother pages to see";
    NSDictionary *attributes = @{NSFontAttributeName: KSFProRoundedRegularFont(16),
                                NSForegroundColorAttributeName:K_TextGrayColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark - Getter
- (WSPersonPageView *)personView {
    if (!_personView) {
        _personView = [WSPersonPageView persenPageView];
        CKWeakify(self);
        [_personView setDidClickFollow:^(BOOL isFollow){
            if (isFollow) {
                [weakSelf cancelFollow];
            } else {
                [weakSelf followingUser];
            }
        }];
        [_personView setDidClickMessage:^(WSUserInfoModel *model){
            WSChatController *controller = [WSChatController.alloc initWithConversationId:weakSelf.userIdString conversationType:EMConversationTypeChat];
            controller.navigationItem.title = model.data2;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
    }
    return _personView;
}
#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setSeparatorColor:K_SepLineColor];
        [_tableView setBackgroundColor:UIColor.clearColor];
        [_tableView setTableFooterView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 21)]];
        [_tableView setTableHeaderView:self.personView];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSPersonPostTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSPersonPostTableCell.class)];
        [_tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    return _tableView;
}
- (UIView *)navView {
    if (!_navView) {
        _navView = [UIView.alloc init];
        [self.view insertSubview:_navView aboveSubview:self.tableView];
        [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(KNavBarAndStatusBarHeight);
        }];
        
        UIButton *backButton = [UIButton k_buttonWithTarget:self action:@selector(backBUttonAction:)];
        [_navView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_navView.mas_bottom);
            make.left.equalTo(_navView.mas_left);
            make.width.height.mas_equalTo(44);
        }];
        [backButton setImage:[UIImage imageNamed:@"person_back_icon"] forState:UIControlStateNormal];
        self.backButton = backButton;
        
        if (![self.userIdString isEqualToString:kUser.uid]) {
            UIButton *moreButton = [UIButton k_buttonWithTarget:self action:@selector(moreButtonAction:)];
            [_navView addSubview:moreButton];
            [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_navView.mas_bottom);
                make.right.equalTo(_navView.mas_right).mas_offset(-10);
                make.width.height.mas_equalTo(44);
            }];
            [moreButton setImage:[UIImage imageNamed:@"person_more_icon"] forState:UIControlStateNormal];
            self.moreButton = moreButton;
        }
    }
    return _navView;
}
@end
