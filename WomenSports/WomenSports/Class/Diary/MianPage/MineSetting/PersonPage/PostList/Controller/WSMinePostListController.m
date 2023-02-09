//
//  WSMinePostListController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/11.
//

#import "WSMinePostListController.h"
#import "WSCommunityTableCell.h"
#import "WSSheetView.h"
#import "WSReportController.h"
#import "WSCommunityDetailController.h"

@interface WSMinePostListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) void (^scrollCallback)(UIScrollView *);
@end

@implementation WSMinePostListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UIColor.clearColor];
    [self tableView];
}

- (void)showAlterView {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 2) {
            WSReportController *vc = [WSReportController.alloc init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    NSArray *items = @[MMItemMake(@"Collect", MMItemTypeHighlight, block),
                       MMItemMake(@"Not interested", MMItemTypeNormal, block),
                       MMItemMake(@"Report", MMItemTypeNormal, block),];
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    [view show];
}
#pragma mark - JXPagerViewListViewDelegate
- (UIView *)listView {
    return self.view;
}
/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
 */
- (UIScrollView *)listScrollView {
    return self.tableView;
}
/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCommunityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSCommunityTableCell.class)];
    CKWeakify(self);
    [cell setDidClickMore:^{
        [weakSelf showAlterView];
    }];
    cell.noMore = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WSCommunityDetailController *vc = [WSCommunityDetailController.alloc init];
    [self.navigationController pushViewController:vc animated:YES];
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
        [_tableView setSeparatorColor:K_SepLineColor];
        [_tableView setBackgroundColor:UIColor.clearColor];
        [_tableView setTableFooterView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 21)]];
        [_tableView setTableHeaderView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 0.01f)]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSCommunityTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSCommunityTableCell.class)];
    }
    return _tableView;
}

@end
