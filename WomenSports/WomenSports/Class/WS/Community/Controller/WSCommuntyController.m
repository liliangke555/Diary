//
//  WSCommuntyController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSCommuntyController.h"
#import "WSCommunityTableCell.h"
#import "WSSheetView.h"
#import "WSReportController.h"
#import "WSCommunityDetailController.h"
#import "WSPushCommunityController.h"

@interface WSCommuntyController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *pushButton;
@end

@implementation WSCommuntyController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Community";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.rightButton];
    [self tableView];
    [self pushButton];
}
#pragma mark - IBAction
- (void)rightButtonAction:(UIButton *)sender {
    
}
- (void)pushButtonAction:(UIButton *)sender {
    WSPushCommunityController *vc = [WSPushCommunityController.alloc init];
    [self.navigationController pushViewController:vc animated:YES];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCommunityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSCommunityTableCell.class)];
    CKWeakify(self);
    [cell setDidClickMore:^{
        [weakSelf showAlterView];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WSCommunityDetailController *vc = [WSCommunityDetailController.alloc init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Getter
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton k_buttonWithTarget:self action:@selector(rightButtonAction:)];
        [_rightButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_rightButton setImage:[UIImage imageNamed:@"community_ling_icon"] forState:UIControlStateNormal];
    }
    return _rightButton;
}
- (UIButton *)pushButton {
    if (!_pushButton) {
        _pushButton = [UIButton k_buttonWithTarget:self action:@selector(pushButtonAction:)];
        [self.view insertSubview:_pushButton aboveSubview:self.tableView];
        [_pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(-74-KBottomSafeHeight);
            make.right.equalTo(self.view.mas_right).mas_offset(-15);
        }];
        [_pushButton setImage:[UIImage imageNamed:@"community_push_icon"] forState:UIControlStateNormal];
    }
    return _pushButton;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(KNavBarAndStatusBarHeight, 0, 0, 0));
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
