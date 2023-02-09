//
//  WSWeatherController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import "WSWeatherController.h"
#import "WSWeatherCollectionCell.h"
#import "WSMoodController.h"

@interface WSWeatherController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *manImageView;
@property (nonatomic, strong) NSArray *normalImages;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, assign) NSInteger selectedWeather;

@property (nonatomic, strong) NSArray *weatherNames;
@end

@implementation WSWeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.nextButton];
    
    [self setupView];
    [self collectionView];
    [self pageControl];
    self.selectedWeather = -1;
}

- (void)setupView {
    UIImageView *imageView = [UIImageView.alloc init];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).mas_offset(15);
        make.height.mas_equalTo(159*CK_HEIGHT_Sales);
        make.right.equalTo(self.view.mas_centerX);
    }];
    [imageView setImage:[UIImage imageNamed:@"record_weather_top"]];
    self.manImageView = imageView;
    
    UILabel *label = [UILabel.alloc init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).mas_offset(20);
        make.centerY.equalTo(imageView.mas_centerY);
        make.right.equalTo(self.view.mas_right).mas_offset(-13);
    }];
    [label setText:@"Hello\nI don't know where the\nweather is like"];
    [label setTextColor:K_BlackColor];
    [label setFont:KSFProRoundedMediumFont(16)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
}

#pragma mark - IBAction
- (void)nextButtonAction:(UIButton *)sender {
    WSMoodController *vc = [WSMoodController.alloc init];
    vc.saveRequest = self.saveRequest;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)valueChanged:(UIPageControl *)sender {
    NSInteger index = sender.currentPage;
    [self.collectionView setContentOffset:CGPointMake(CK_WIDTH * index, 0) animated:YES];
}
- (void)submitButtonAction:(UIButton *)sender {
    if (self.selectedWeather < 0) {
        [MBProgressHUD showMessage:@"Please select the weather!"];
        return;
    }
    WSMoodController *vc = [WSMoodController.alloc init];
    vc.saveRequest = self.saveRequest;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.normalImages.count;
}
-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSWeatherCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSWeatherCollectionCell.class) forIndexPath:indexPath];
    UIImage *backImage = [[UIImage imageNamed:@"weather_background_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *pImage = [[UIImage imageNamed:self.normalImages[indexPath.item]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [cell.pImageView setImage:backImage];
    [cell.wImageView setImage:pImage];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedWeather = indexPath.item;
    self.saveRequest.data1 = self.weatherNames[indexPath.item];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / CK_WIDTH;
    [self.pageControl setCurrentPage:index];
}
#pragma mark - Setter
- (void)setSelectedWeather:(NSInteger)selectedWeather {
    _selectedWeather = selectedWeather;
    if (selectedWeather < 0) {
        [self.submitButton setTitle:@"Select Weather" forState:UIControlStateNormal];
    } else {
        [self.submitButton setTitle:@"Partly Cloudy" forState:UIControlStateNormal];
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
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 19*CK_WIDTH_Sales, 0, 19*CK_WIDTH_Sales)];
        [flowLayout setMinimumInteritemSpacing:20];
        [flowLayout setMinimumLineSpacing:37*CK_WIDTH_Sales];
        [flowLayout setItemSize:CGSizeMake(88, 82)];
        [flowLayout setSectionHeadersPinToVisibleBounds:YES];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.top.equalTo(self.manImageView.mas_bottom).mas_offset(49*CK_HEIGHT_Sales);
            make.height.mas_equalTo(196*CK_HEIGHT_Sales);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setPagingEnabled:YES];
        [_collectionView setBackgroundColor:K_WhiteColor];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSWeatherCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSWeatherCollectionCell.class)];
    }
    return _collectionView;
}
- (NSArray *)normalImages {
    if (!_normalImages) {
        _normalImages = @[@"weather_sunny_icon",@"weather_light_rain",@"weather_overcast_icon",
        @"weather_cloud_rain",@"weather_sunny_night",@"weather_cloudy_night",
        @"weather_heavy_rain",@"weather_snow_sun",@"weather_thunderstorm_icon",
        @"weather_major_snow",@"weather_minor_snow",@"weather_hail_icon"];
    }
    return _normalImages;
}
- (NSArray *)weatherNames {
    if (!_weatherNames) {
        _weatherNames = @[@"sunny",@"light rain",@"Cloudy Weather",
                          @"Rain turns sunny",@"night",@"cloudy night",
                          @"heavy rain",@"snow turns sunny",@"thunderstorm",
                          @"Moderate snow",@"light snow",@"hail"];
    }
    return _weatherNames;
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
- (WSDiaryAddOrEditRequest *)saveRequest {
    if (!_saveRequest) {
        _saveRequest = [WSDiaryAddOrEditRequest.alloc init];
        _saveRequest.packageName = WSPackageName;
        _saveRequest.deviceType = WSDeviceType;
        _saveRequest.data9 = kUser.headerUrl;
        _saveRequest.data10 = kUser.name;
        _saveRequest.data20 = @"1";
    }
    return _saveRequest;
}
@end
