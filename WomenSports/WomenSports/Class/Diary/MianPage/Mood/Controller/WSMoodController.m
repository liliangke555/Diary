//
//  WSMoodController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import "WSMoodController.h"
#import "WSMoodCollectionCell.h"
#import "WSDiaryEditController.h"

@interface WSMoodController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *manImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectedWeather;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *nextButton;


@end

@implementation WSMoodController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.nextButton];
    [self titleLabel];
    [self manImageView];
    [self collectionView];
    [self pageControl];
    self.selectedWeather = -1;
}

#pragma mark - IBAction
- (void)nextButtonAction:(UIButton *)sender {
    WSDiaryEditController *vc = [WSDiaryEditController.alloc init];
    vc.saveRequest = self.saveRequest;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)valueChanged:(UIPageControl *)sender {
    NSInteger index = sender.currentPage;
    [self.collectionView setContentOffset:CGPointMake(CK_WIDTH * index, 0) animated:YES];
}
- (void)submitButtonAction:(UIButton *)sender {
    if (self.selectedWeather < 0) {
        [MBProgressHUD showMessage:@"Please select mood!"];
        return;
    }
    WSDiaryEditController *vc = [WSDiaryEditController.alloc init];
    vc.saveRequest = self.saveRequest;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSMoodCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSMoodCollectionCell.class) forIndexPath:indexPath];
    UIImage *backImage = [[UIImage imageNamed:@"mood_background_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cell.bImageView setImage:backImage];
    [cell.titleLabel setText:self.titleArray[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedWeather = indexPath.item;
    self.saveRequest.data2 = self.titleArray[indexPath.item];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / CK_WIDTH;
    [self.pageControl setCurrentPage:index];
}
#pragma mark - Setter
- (void)setSelectedWeather:(NSInteger)selectedWeather {
    _selectedWeather = selectedWeather;
    if (selectedWeather < 0) {
        [self.submitButton setTitle:@"Mood" forState:UIControlStateNormal];
    } else {
        [self.submitButton setTitle:@"Enrich" forState:UIControlStateNormal];
    }
}
#pragma mark - Getter
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton k_buttonWithTarget:self action:@selector(nextButtonAction:)];
        [_nextButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
        [_nextButton.titleLabel setFont:KSFProRoundedMediumFont(14)];
        [_nextButton setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
    }
    return _nextButton;
}
- (UIImageView *)manImageView {
    if (!_manImageView) {
        _manImageView = [UIImageView.alloc init];
        [self.view addSubview:_manImageView];
        [_manImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(10*CK_HEIGHT_Sales);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(175*CK_HEIGHT_Sales);
        }];
        [_manImageView setImage:[UIImage imageNamed:@"mood_man_icon"]];
    }
    return _manImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel.alloc init];
        [self.view addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).mas_offset(20*CK_HEIGHT_Sales);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        [_titleLabel setText:@"Hello\nwhat's your mood today"];
        [_titleLabel setTextColor:K_BlackColor];
        [_titleLabel setFont:KSFProRoundedMediumFont(16)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setNumberOfLines:0];
    }
    return _titleLabel;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 18*CK_WIDTH_Sales, 0, 18*CK_WIDTH_Sales)];
        [flowLayout setMinimumInteritemSpacing:20];
        [flowLayout setMinimumLineSpacing:35*CK_WIDTH_Sales];
        [flowLayout setItemSize:CGSizeMake(90, 48)];
        [flowLayout setSectionHeadersPinToVisibleBounds:YES];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.top.equalTo(self.manImageView.mas_bottom).mas_offset(30*CK_HEIGHT_Sales);
            make.height.mas_equalTo(116*CK_HEIGHT_Sales);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setPagingEnabled:YES];
        [_collectionView setBackgroundColor:K_WhiteColor];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSMoodCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSMoodCollectionCell.class)];
    }
    return _collectionView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [UIPageControl.alloc init];
        [self.view addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).mas_offset(37*CK_HEIGHT_Sales);
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(10);
        }];
        [_pageControl setNumberOfPages:2];
        [_pageControl setCurrentPage:0];
        [_pageControl setCurrentPageIndicatorTintColor:K_BlackColor];
        [_pageControl setPageIndicatorTintColor:[UIColor k_colorWithHex:0xD9D9D9FF]];
        _pageControl.defersCurrentPageDisplay = YES;
        [_pageControl updateCurrentPageDisplay];
        [_pageControl addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _pageControl;
}
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton k_buttonWithTarget:self action:@selector(submitButtonAction:)];
        [self.view addSubview:_submitButton];
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pageControl.mas_bottom).mas_offset(30*CK_HEIGHT_Sales);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(52);
            make.width.mas_equalTo(180);
        }];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"button_line_icon"] forState:UIControlStateNormal];
        [_submitButton setTitle:@"Select Weather" forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:KSFProRoundedMediumFont(18)];
        [_submitButton setTitleColor:K_BlackColor forState:UIControlStateNormal];
    }
    return _submitButton;
}
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"Happy",@"Sad",@"Enrich",
        @"Angry",@"Surprise",@"Irritable",
        @"Happiness",@"Wronged",@"Lonely",
        @"Despair",@"Awkward",@"Exhausted"];
    }
    return _titleArray;
}
@end
