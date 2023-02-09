//
//  WSMyPostController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSMyPostController.h"
#import "WSCycleListTableCell.h"
#import "WSSheetView.h"
#import "WSCycleDetailController.h"
#import "WSDeleteCycleRequest.h"

@interface WSMyPostController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation WSMyPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"My Post";
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
- (void)showAlterViewWithModel:(WSCycleDetailModel *)model {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
            [weakSelf deleteCycleWithModel:model];
        }
    };
    NSArray *items = @[MMItemMake(@"Delete", MMItemTypeHighlight, block),];
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    [view setCancelColor:K_TextLightGrayColor];
    [view show];
}
- (void)reloadList {
    WSCycleListRequest *request = [WSCycleListRequest.alloc init];
    request.deviceType = WSDeviceType;
    request.packageName = WSPackageName;
    request.data20 = @"2";
    request.sort = @[@"data3,desc"];
    request.size = 20;
    request.page = self.pageNum;
    request.userId = kUser.uid;
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
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
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
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCycleListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSCycleListTableCell.class)];
    CKWeakify(self);
    [cell setDidClickMore:^(id model) {
        [weakSelf showAlterViewWithModel:model];
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
        [_tableView setBackgroundColor:K_WhiteColor];
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView setTableHeaderView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 1)]];
        [_tableView setTableFooterView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 1)]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSCycleListTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSCycleListTableCell.class)];
    }
    return _tableView;
}
@end
