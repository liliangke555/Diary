//
//  WSFollowerController.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSFollowerController.h"
#import "WSFollowerListRequest.h"
#import "WSFollowManTableCell.h"
#import "WSFollowingRequest.h"

@interface WSFollowerController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WSFollowerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
- (void)reloadList {
    WSFollowerListRequest *request = [WSFollowerListRequest.alloc init];
    request.page = self.pageNum;
    request.size = 20;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        WSFollowingListModel *listModel = response.data;
        if (weakSelf.pageNum == 1) {
            [weakSelf.dataSource removeAllObjects];
        }
        if (listModel.totalPages >= weakSelf.pageNum) {
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
- (void)followingUser:(WSFollowDetailModel *)model {
    WSFollowingRequest *request = [WSFollowingRequest.alloc init];
    request.userId = model.id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSFollowManTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSFollowManTableCell.class)];
    CKWeakify(self);
    [cell setDidClickUnfollow:^(WSFollowDetailModel * _Nonnull detailModel) {
//        [weakSelf cancelFollowWithModel:detailModel];
        [weakSelf followingUser:detailModel];
    }];
    [cell setModel:self.dataSource[indexPath.row]];
    [cell setFollower:YES];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setRowHeight:90];
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_WhiteColor];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView setTableHeaderView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 1)]];
        [_tableView setTableFooterView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 1)]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSFollowManTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSFollowManTableCell.class)];
    }
    return _tableView;
}

@end
