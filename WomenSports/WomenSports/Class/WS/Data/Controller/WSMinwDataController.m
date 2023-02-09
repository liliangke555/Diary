//
//  WSMinwDataController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSMinwDataController.h"
#import "WSDataTimeCollectionCell.h"
#import "WSDataTargetView.h"
#import "MMAlertView.h"
#import "WSTargetController.h"
#import "WSModifyTargetController.h"

@interface WSMinwDataController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger weekNum;
@property (nonatomic, strong) WSDataTargetView *targetView;
@end

@implementation WSMinwDataController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Shaping";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.rightButton];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //获取当前时间日期展示字符串 如：2019-05-23-13:58:59
    //下面是单独获取每项的值
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    //星期 注意星期是从周日开始计算
    NSInteger week = [comps weekday];
    self.weekNum = week;
    [self collectionView];
    CKWeakify(self);
    [self.targetView setDidClickRecord:^{
        [weakSelf showAlterView];
    }];
    [self.targetView setDidClickRightButton:^{
        WSTargetController *vc= [WSTargetController.alloc init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)showAlterView {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 1) {
            
        }
    };
    NSArray *items = @[MMItemMake(@"Cancel", MMItemTypeNormal, block),
                       MMItemMake(@"Ok", MMItemTypeHighlight, block),];
    MMAlertView *view = [MMAlertView.alloc initWithInputTitle:@"Modify weight" detail:nil placeholder:@"Please enter your weight" handler:^(NSString *text) {
        
    }];
    [view show];
}
#pragma mark - IBAction

- (void)rightButtonAction:(UIButton *)sender {
    WSModifyTargetController *vc = [WSModifyTargetController.alloc init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSDataTimeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSDataTimeCollectionCell.class) forIndexPath:indexPath];
    [cell setWeekNum:self.weekNum];
    [cell setIndex:indexPath.item];
    return cell;
}
#pragma mark - Getter
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton k_buttonWithTarget:self action:@selector(rightButtonAction:)];
        _rightButton.frame = CGRectMake(0, 0, 44, 44);
        [_rightButton setImage:[UIImage imageNamed:@"data_edit_icon"] forState:UIControlStateNormal];
    }
    return _rightButton;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 12, 10, 12)];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:0];
        [flowLayout setItemSize:CGSizeMake((CK_WIDTH - 24)/ 7.0f, 80)];
        [flowLayout setSectionHeadersPinToVisibleBounds:YES];
        _collectionView = [UICollectionView.alloc initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).mas_offset(KNavBarAndStatusBarHeight);
            make.left.right.equalTo(self.view).with.insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(100);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:UIColor.clearColor];
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSDataTimeCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSDataTimeCollectionCell.class)];
    }
    return _collectionView;
}
- (WSDataTargetView *)targetView {
    if (!_targetView) {
        _targetView = [WSDataTargetView dataTargetView];
        [self.view addSubview:_targetView];
        [_targetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(356);
        }];
    }
    return _targetView;
}
@end
