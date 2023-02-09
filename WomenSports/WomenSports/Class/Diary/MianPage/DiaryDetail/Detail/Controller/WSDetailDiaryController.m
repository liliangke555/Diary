//
//  WSDetailDiaryController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/15.
//

#import "WSDetailDiaryController.h"
#import "WSDiaryMoreView.h"
#import "WSDiaryDeleteRequest.h"
#import "WSDiaryEditController.h"
#import "WSDiaryDetailRequest.h"

@interface WSDetailDiaryController ()
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *lastView;
@end

@implementation WSDetailDiaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.moreButton];
    [self.navigationItem setTitleView:self.centerLabel];
    
    [self reloadDetail];
}
- (NSAttributedString *)timeStringWithYearAndMonth:(NSString *)yearMont day:(NSString *)day {
    NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:[NSString stringWithFormat:@"%@ %@  ",day,yearMont]];
    [attString addAttribute:NSFontAttributeName value:KSFProRoundedMediumFont(18) range:NSMakeRange(0, day.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:K_BlackColor range:NSMakeRange(0, day.length)];
    
    return attString;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.contentView.frame = CGRectMake(0, 0, CK_WIDTH, CGRectGetMaxY(self.lastView.frame) + 10 +KBottomSafeHeight);
    [self.scrollView setContentSize:self.contentView.mj_size];
}
- (void)deleteDiary {
    WSDiaryDeleteRequest *request = [WSDiaryDeleteRequest.alloc init];
    request.id = self.detailModel.id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [MBProgressHUD showSuccessfulWithMessage:@"Delete succeeded"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)reloadDetail {
    WSDiaryDetailRequest *request = [WSDiaryDetailRequest.alloc init];
    request.id = self.detailModel.id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        weakSelf.detailModel = response.data;
        
        NSArray *array = [weakSelf.detailModel.data3 componentsSeparatedByString:@"-"];
        if (array.count > 2) {
            [weakSelf.centerLabel setAttributedText:[weakSelf timeStringWithYearAndMonth:[NSString stringWithFormat:@"%@-%@",array[0],array[1]] day:[NSString stringWithFormat:@"%@",array[2]]]];
        }
        [weakSelf setupView];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)setupView {
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIScrollView *scrollView = [UIScrollView.alloc init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    self.scrollView = scrollView;
    
    UIView *contentView = [UIView.alloc init];
    [scrollView addSubview:contentView];
    self.contentView = contentView;
    contentView.frame = CGRectMake(0, 0, CK_WIDTH, CK_HEIGHT);
    
    UILabel *titleLabel = [UILabel.alloc init];
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).mas_offset(20);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    [titleLabel setFont:KSFProRoundedMediumFont(16)];
    [titleLabel setTextColor:K_BlackColor];
    [titleLabel setText:self.detailModel.data4];
    
    UIView *lineView = [UIView.alloc init];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).mas_offset(10);
        make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.height.mas_equalTo(0.5);
    }];
    [lineView setBackgroundColor:K_SepLineColor];
    
    
    UIView *itemView = [UIView.alloc init];
    [contentView addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    __block UIView *lastItemView = nil;
    NSArray *nameArray = [NSArray arrayWithObjects:self.detailModel.data1,self.detailModel.data2, nil];
    for (NSString *string in nameArray) {
        UIView *view = [UIView.alloc init];
        [itemView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastItemView) {
                make.left.equalTo(itemView.mas_left);
            } else {
                make.left.equalTo(lastItemView.mas_right).mas_offset(10);
            }
//            make.height.mas_equalTo(24);
            make.top.bottom.equalTo(itemView).insets(UIEdgeInsetsMake(15, 0, 0, 0));
        }];
        [view.layer setCornerRadius:12];
        [view.layer setBorderWidth:1];
        [view.layer setBorderColor:[UIColor k_colorWithHex:0x222222FF].CGColor];
        lastItemView = view;
        
        UILabel *label = [UILabel.alloc init];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.right.equalTo(view).insets(UIEdgeInsetsMake(0, 14, 0, 14));
        }];
        [label setText:string];
        [label setFont:KSFProRoundedRegularFont(12)];
        [label setTextColor:[UIColor k_colorWithHex:0x222222FF]];
    }
    if (lastItemView) {
        [lastItemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(itemView.mas_right);
        }];
        [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
    } else {
        [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    UILabel *detailLabel = [UILabel.alloc init];
    [contentView addSubview: detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemView.mas_bottom).mas_offset(20*CK_HEIGHT_Sales);
        make.left.right.equalTo(contentView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    [detailLabel setFont:KSFProRoundedMediumFont(16)];
    [detailLabel setTextColor:K_TextDrakGrayColor];
    [detailLabel setNumberOfLines:0];
    [detailLabel setText:self.detailModel.data5];
    
    self.lastView = detailLabel;
    
    MASViewAttribute *lastAttribute = detailLabel.mas_bottom;
    
    if (self.detailModel.data6.length > 0) {
        UIImageView *imageView = [UIImageView.alloc init];
        [contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).mas_offset(15);
            make.top.equalTo(detailLabel.mas_bottom).mas_offset(20*CK_HEIGHT_Sales);
            make.width.height.mas_equalTo(219*CK_HEIGHT_Sales);
        }];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView.layer setCornerRadius:12];
        [imageView setClipsToBounds:YES];
        [imageView setBackgroundColor:K_TextLightGrayColor];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.data6]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(imageReviewAction:)]];
        
        lastAttribute = imageView.mas_bottom;
        self.lastView = imageView;
    }
}
- (void)imageReviewAction:(UITapGestureRecognizer *)sender {
    [self showBrowerWithIndex:0 data:@[self.detailModel.data6] view:sender.view];
}
#pragma mark - IBAction
- (void)moreButtonAction:(UIButton *)sender {
    WSDiaryMoreView *view = [WSDiaryMoreView.alloc init];
    CKWeakify(self);
    [view setDidClickItem:^(NSInteger index) {
        if (index == 0) {
            WSDiaryEditController *vc = [WSDiaryEditController.alloc init];
            vc.saveRequest = [WSDiaryAddOrEditRequest mj_objectWithKeyValues:weakSelf.detailModel.mj_keyValues];
            [vc setDidReloadList:^{
                [weakSelf reloadDetail];
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [weakSelf deleteDiary];
        }
    }];
    [view show];
}

#pragma mark - Getter
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton k_buttonWithTarget:self action:@selector(moreButtonAction:)];
        _moreButton.frame = CGRectMake(0, 0, 44, 44);
        [_moreButton setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
    }
    return _moreButton;
}
- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [UILabel.alloc init];
        _centerLabel.frame = CGRectMake(0, 0, 120, 44);
        [_centerLabel setFont:KSFProRoundedMediumFont(14)];
        [_centerLabel setTextColor:K_TextDrakGrayColor];
        [_centerLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _centerLabel;
}
@end
