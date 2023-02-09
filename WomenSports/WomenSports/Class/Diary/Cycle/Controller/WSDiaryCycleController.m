//
//  WSDiaryCycleController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import "WSDiaryCycleController.h"
#import "WSCycleHeaderView.h"
#import "WSCycleListTableCell.h"
#import "WSGiftPopupView.h"
#import "WSSheetView.h"
#import "WSCycleDetailController.h"
#import "WSCycleListRequest.h"
#import "WSLikeCycleRequest.h"
#import "WSCancelLikeRequest.h"
#import "WSGetGiftListRequest.h"
#import "WSFollowingRequest.h"
#import "WSCheckFollowRequest.h"
#import "WSCancelFollowRequest.h"
#import "WSMessageController.h"
#import "WSBlackListRepoRequest.h"
#import "WSSendGiftRequest.h"

@interface WSDiaryCycleController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) WSCycleHeaderView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *searchText;
@end

@implementation WSDiaryCycleController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publicSuccess) name:@"WSPublicCycle" object:nil];
    [self searchView];
    self.dataSource = [NSMutableArray array];
    CKWeakify(self);
    self.tableView.mj_header = [CKRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf reloadList];
    }];
    self.tableView.mj_footer = [CKRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf reloadList];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)publicSuccess {
    [self.tableView.mj_header beginRefreshing];
}
- (void)reloadList {
    WSCycleListRequest *request = [WSCycleListRequest.alloc init];
    request.deviceType = WSDeviceType;
    request.packageName = WSPackageName;
    request.data20 = @"2";
    request.sort = @[@"createTime,desc"];
    request.size = 20;
    request.data10 = self.searchText;
    request.page = self.pageNum;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
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
        [weakSelf.tableView reloadData];
    } failHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
- (void)likeCycleWithModel:(WSCycleDetailModel *)model {
    WSLikeCycleRequest *request = [WSLikeCycleRequest.alloc init];
    request.auditTreeDataId = model.id;
    request.type = @"1";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        model.data11 = model.data11 + 1;
        NSMutableArray *array = [NSMutableArray arrayWithArray:model.listActionType];
        [array addObject:@1];
        model.listActionType = array;
        [weakSelf.tableView reloadData];
        [weakSelf uploadDetailWithModel:model];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)uploadDetailWithModel:(WSCycleDetailModel *)model {
    WSCycleAddOrEditRequest *request = [WSCycleAddOrEditRequest mj_objectWithKeyValues:model.mj_keyValues];
    request.hideLoadingView = YES;
//    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)cancelLikeWithModel:(WSCycleDetailModel *)model {
    WSCancelLikeRequest *request = [WSCancelLikeRequest.alloc init];
    request.auditTreeDataId = model.id;
    request.type = @"1";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        model.data11 = model.data11 - 1;
        NSMutableArray *array = [NSMutableArray arrayWithArray:model.listActionType];
        [array removeObject:@1];
        model.listActionType = array;
        [weakSelf.tableView reloadData];
        [weakSelf uploadDetailWithModel:model];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)followingUser:(NSString *)userId {
    WSFollowingRequest *request = [WSFollowingRequest.alloc init];
    request.userId = userId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)checkFollowingWithModel:(WSCycleDetailModel *)model {
    WSCheckFollowRequest *request = [WSCheckFollowRequest.alloc init];
    request.userId = model.userId;
//    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        BOOL isFollow = [response.data boolValue];
        [weakSelf showAlterView:model isFollow:isFollow];

    } failHandler:^(BaseResponse * _Nonnull response) {
    }];
}
- (void)cancelFollowWithUserid:(NSString *)userID {
    WSCancelFollowRequest *requet = [WSCancelFollowRequest.alloc init];
    requet.userId = userID;
    [requet asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
    } failHandler:^(BaseResponse * _Nonnull response) {
    }];
}
- (void)repoWithUser:(NSString *)userid content:(NSString *)content {
    WSBlackListRepoRequest *request = [WSBlackListRepoRequest.alloc init];
    request.userId = userid;
    request.content = content;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [MBProgressHUD showSuccessfulWithMessage:@""];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)sendGiftWithUserModel:(WSCycleDetailModel *)detailModel giftModel:(WSGiftModel *)giftModel {
    WSSendGiftRequest *request = [WSSendGiftRequest.alloc init];
    request.userId = detailModel.userId;
    request.giftId = giftModel.id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSSendGiftModel *sendModel = response.data;
        if ([sendModel.enough integerValue] == 0) {
            [MBProgressHUD showMessage:@"Fee deduction failed"];
        } else {
            detailModel.data13 = detailModel.data13 + 1;
            [weakSelf.tableView reloadData];
            [weakSelf uploadDetailWithModel:detailModel];
            [MBProgressHUD showSuccessfulWithMessage:@""];
        }
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)giftViewShowWithModel:(WSCycleDetailModel *)model {
    
    WSGiftPopupView *view = [WSGiftPopupView.alloc init];
    CKWeakify(self);
    [view setDidSendGift:^(WSGiftModel * _Nonnull giftModel) {
        [weakSelf sendGiftWithUserModel:model giftModel:giftModel];
    }];
    
    [view show];
}
- (void)showAlterView:(WSCycleDetailModel *)model isFollow:(BOOL)isFowoll {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 1) {
            [weakSelf showReportSheet:model.userId];
        } else {
            if (isFowoll) {
                [weakSelf cancelFollowWithUserid:model.userId];
            } else {
                [weakSelf followingUser:model.userId];
            }
        }
    };
    NSArray *items = @[MMItemMake(@"Follow", MMItemTypeNormal, block),
                       MMItemMake(@"Report complaints", MMItemTypeNormal, block)];
    if (isFowoll) {
        items = @[MMItemMake(@"Unfollow", MMItemTypeNormal, block),
                           MMItemMake(@"Report complaints", MMItemTypeNormal, block)];
    }
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    [view show];
}
- (void)showReportSheet:(NSString *)userid {
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
        [weakSelf repoWithUser:userid content:string];
    };
    NSArray *items = @[MMItemMake(@"Pornographic vulgar", MMItemTypeNormal, block),
                       MMItemMake(@"Advertising fraud", MMItemTypeNormal, block),
                       MMItemMake(@"Politically sensitive", MMItemTypeNormal, block),
                       MMItemMake(@"Bloody terror", MMItemTypeNormal, block),
                       MMItemMake(@"Incite war and abuse", MMItemTypeNormal, block),
                       MMItemMake(@"Other", MMItemTypeNormal, block),
    ];
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    [view show];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCycleListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSCycleListTableCell.class)];
    CKWeakify(self);
    [cell setDidClickGift:^(WSCycleDetailModel * _Nonnull detailModel) {
        [weakSelf giftViewShowWithModel:detailModel];
    }];
    [cell setDidClickMore:^(WSCycleDetailModel * _Nonnull detailModel){
        [weakSelf checkFollowingWithModel:detailModel];
    }];
    [cell setDidClickLike:^(WSCycleDetailModel * _Nonnull detailModel,BOOL isLike) {
        if (isLike) {
            [weakSelf likeCycleWithModel:detailModel];
        } else {
            [weakSelf cancelLikeWithModel:detailModel];
        }
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
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -CK_HEIGHT_Sales*50;
}
#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - Getter
- (WSCycleHeaderView *)searchView {
    if (!_searchView) {
        _searchView = [WSCycleHeaderView.alloc init];
        [self.view addSubview:_searchView];
        [_searchView setFrame:CGRectMake(0, KStatusBarHeight, CK_WIDTH, 44)];
        CKWeakify(self);
        [_searchView setDidClickSearch:^(NSString * _Nonnull str) {
            if (str.length <= 0) {
                str = nil;
            }
            weakSelf.searchText = str;
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    }
    return _searchView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(44+KStatusBarHeight, 0, 0, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView setTableHeaderView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 1)]];
        [_tableView setTableFooterView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 1)]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSCycleListTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSCycleListTableCell.class)];
    }
    return _tableView;
}
@end
