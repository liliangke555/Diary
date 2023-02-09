//
//  WSReportController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import "WSReportController.h"
#import "WSReportTableCell.h"

@interface WSReportController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) NSArray *dataShource;
@end

@implementation WSReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Report";
    self.dataShource = @[@"Advertise",@"Harassment/abuse",@"uncivilized chat",@"Pornographic and vulgar",@"Unable to contact"];
    [self titleLabel];
    [self tableView];
    [self confirmButton];
}
- (void)confirmButtonAction:(UIButton *)sender {
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataShource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSReportTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSReportTableCell.class)];
    [cell.titleLabel setText:self.dataShource[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
#pragma mark - Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel.alloc init];
        [self.view addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).mas_offset(20);
            make.left.equalTo(self.view.mas_left).mas_offset(15);
        }];
        [_titleLabel setText:@"Please select the reason for reporting"];
        [_titleLabel setFont:KMediumFont(16)];
        [_titleLabel setTextColor:K_TextDrakGrayColor];
    }
    return _titleLabel;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton k_mainButtonWithTarget:self action:@selector(confirmButtonAction:)];
        [self.view addSubview:_confirmButton];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).mas_offset(-5-KBottomSafeHeight);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(48);
        }];
        [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    }
    return _confirmButton;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(15);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(40*self.dataShource.count + 20);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:K_WhiteColor];
        [_tableView setTableHeaderView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 10)]];
        [_tableView setTableFooterView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 10)]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSReportTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSReportTableCell.class)];
        [_tableView setScrollEnabled:NO];
        [_tableView setBackgroundColor:K_WhiteColor];
        _tableView.layer.shadowColor = [UIColor k_colorWithHex:0x17015512].CGColor;
        _tableView.layer.shadowOffset = CGSizeMake(0,0);
        _tableView.layer.shadowOpacity = 1;
        _tableView.layer.shadowRadius = 8;
        _tableView.layer.cornerRadius = 8;
        [_tableView setClipsToBounds:YES];
        _tableView.layer.masksToBounds = NO;
    }
    return _tableView;
}
@end
