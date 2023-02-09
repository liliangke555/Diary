//
//  WSBlackListController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSBlackListController.h"
#import "WSBlackListTableCell.h"
#import "WSGetBlackListRequest.h"
#import "WSCancelBlackRequest.h"

@interface WSBlackListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation WSBlackListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Blacklist";
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
- (void)reloadList {
    WSGetBlackListRequest *request = [WSGetBlackListRequest.alloc init];
    request.page = self.pageNum;
    request.size = 20;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        WSGetBlackListModel *listModel = response.data;
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
- (void)cancelBlackWithModel:(WSGetBlackModel *)model {
    WSCancelBlackRequest *request = [WSCancelBlackRequest.alloc init];
    request.userId = model.id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.dataSource removeObject:model];
        [weakSelf.tableView reloadData];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSBlackListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSBlackListTableCell.class)];
    CKWeakify(self);
    [cell setDidClickRemove:^(WSGetBlackModel * _Nonnull model) {
        [weakSelf cancelBlackWithModel:model];
    }];
    [cell setModel:self.dataSource[indexPath.row]];
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSBlackListTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSBlackListTableCell.class)];
    }
    return _tableView;
}
@end
