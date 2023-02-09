//
//  WSCommunityDetailController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import "WSCommunityDetailController.h"
#import "WSCommunityDetailTableCell.h"
#import "WSCommunityCommentTableCell.h"
#import "WSSheetView.h"
#import "WSReportController.h"
#import "WSCommunityComBottomView.h"
#import "WSGiftPopupView.h"

@interface WSCommunityDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WSCommunityComBottomView *comBottomView;
@end

@implementation WSCommunityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Details";
    [self tableView];
    CKWeakify(self);
    [self.comBottomView setDidClickGift:^{
        [weakSelf giftViewShow];
    }];
}
- (void)giftViewShow {
    WSGiftPopupView *view = [WSGiftPopupView.alloc init];
    [view show];
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
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WSCommunityDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSCommunityDetailTableCell.class)];
        CKWeakify(self);
        [cell setDidClickMore:^{
            [weakSelf showAlterView];
        }];
        return cell;
    }
    WSCommunityCommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSCommunityCommentTableCell.class)];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView.alloc init];;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [UIView.alloc init];
        UILabel *label = [UILabel.alloc init];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).mas_offset(15);
        }];
        [label setText:@"Com"];
        [label setFont:KSystemFont(14)];
        [label setTextColor:[UIColor k_colorWithHex:0x8D95AEFF]];
        
        UILabel *numLabel = [UILabel.alloc init];
        [view addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).mas_offset(5);
            make.centerY.equalTo(label.mas_centerY);
        }];
        [numLabel setText:@"25"];
        [numLabel setTextColor:[UIColor k_colorWithHex:0x6D7797FF]];
        [numLabel setFont:KSystemFont(14)];
        return view;
    }
    return [UIView.alloc init];
}
#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(KNavBarAndStatusBarHeight, 0, 34+KBottomSafeHeight, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:UIColor.clearColor];
        [_tableView setBackgroundColor:UIColor.clearColor];
        [_tableView setTableFooterView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 21)]];
        [_tableView setTableHeaderView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 0.01f)]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSCommunityDetailTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSCommunityDetailTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSCommunityCommentTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSCommunityCommentTableCell.class)];
    }
    return _tableView;
}
- (WSCommunityComBottomView *)comBottomView {
    if (!_comBottomView) {
        _comBottomView = [WSCommunityComBottomView CommunityVBottomView];
        [self.view addSubview:_comBottomView];
        [_comBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(34+KBottomSafeHeight);
        }];
    }
    return _comBottomView;
}
@end
