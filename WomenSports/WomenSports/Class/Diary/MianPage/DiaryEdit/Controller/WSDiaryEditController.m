//
//  WSDiaryEditController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import "WSDiaryEditController.h"
#import "WSCalendarView.h"
#import "WSUploadFileRequest.h"
#import "WSDiaryFindRequest.h"
#import "WSCycleAddOrEditRequest.h"

@interface WSDiaryEditController ()<UITextViewDelegate>
{
    dispatch_group_t _group;
}
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, assign, getter=isShowDateView) BOOL showDateView;
@property (nonatomic, strong) WSCalendarView *calendatView;
@property (nonatomic, strong) UILabel *placeholdLabel;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIImage *contentImage;

@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, assign) NSInteger year; //!< 所属年份
@property (nonatomic, assign) NSInteger month; //!< 当前月份
@property (nonatomic, assign) NSInteger day;   //每天所在的位置

@property (nonatomic, assign, getter=isEditData) BOOL editData;
@end

@implementation WSDiaryEditController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isShowDateView) {
        [self.calendatView hide];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maxPhoto = 1;
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.saveButton];
    [self.navigationItem setTitleView:self.centerButton];
    
    if (self.saveRequest.data3.length > 0) {
        self.editData = YES;
        NSArray *array = [self.saveRequest.data3 componentsSeparatedByString:@"-"];
        if (array.count == 3) {
            self.year = [array[0] integerValue];
            self.month = [array[1] integerValue];
            self.day = [array[2] integerValue];
            [self.centerButton setAttributedTitle:[self timeStringWithYearAndMonth:[NSString stringWithFormat:@"%@-%@",array[0],array[1]] day:[NSString stringWithFormat:@"%@",array[2]]] forState:UIControlStateNormal];
        }
    } else {
        NSDate *date = [NSDate date];
        //下面是单独获取每项的值
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
        comps = [calendar components:unitFlags fromDate:date];
        NSInteger year = [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        self.year = year;
        self.month = month;
        self.day = day;
        
        [self.centerButton setAttributedTitle:[self timeStringWithYearAndMonth:[NSString stringWithFormat:@"%ld-%ld",year,month] day:[NSString stringWithFormat:@"%ld",day]] forState:UIControlStateNormal];
        self.saveRequest.data3 = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    }
    
    [self setupView];
}
- (void)uploadImage {
    WSUploadFileRequest *request = [WSUploadFileRequest.alloc init];
    NSData *imageData;
    NSString *mimetype;
    if (UIImagePNGRepresentation(self.contentImage) != nil) {
        mimetype = @"image/png";
        imageData = UIImagePNGRepresentation(self.contentImage);
    }else{
        mimetype = @"image/jpeg";
        imageData = UIImageJPEGRepresentation(self.contentImage, 1);
    }
    CKWeakify(self);
    [MBProgressHUD showLoadingWithMessage:@"Uploading..."];
    [request uploadWitImagedData:imageData uploadName:@"file" progress:^(NSProgress * _Nonnull progress) {
        
    } successHandler:^(BaseResponse * _Nonnull response) {
        weakSelf.saveRequest.data6 = response.data;
        [weakSelf.deleteButton setHidden:NO];
        [weakSelf.imageButton sd_setImageWithURL:[NSURL URLWithString:response.data] forState:UIControlStateNormal];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)saveDiaryRequest {
    if (self.titleTextField.text.length <= 0) {
        [MBProgressHUD showMessage:@"Give this diary a title!"];
        return;
    }
    if (self.contentTextView.text.length <= 0) {
        [MBProgressHUD showMessage:@"Please fill in the diary!"];
        return;
    }
    self.saveRequest.data4 = self.titleTextField.text;
    self.saveRequest.data5 = self.contentTextView.text;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [self.saveRequest asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [MBProgressHUD showSuccessfulWithMessage:@""];
        if (weakSelf.didReloadList) {
            weakSelf.didReloadList();
        }
        dispatch_group_leave(self->_group);
    } failHandler:^(BaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
- (void)saveCycleRequest {
    if (self.titleTextField.text.length <= 0) {
        [MBProgressHUD showMessage:@"Give this a title!"];
        return;
    }
    if (self.contentTextView.text.length <= 0) {
        [MBProgressHUD showMessage:@"Please fill in the content!"];
        return;
    }
    WSCycleAddOrEditRequest *request = [WSCycleAddOrEditRequest.alloc init];
    request.data20 = @"2";
    request.packageName = WSPackageName;
    request.deviceType = WSDeviceType;

    request.data3 = self.saveRequest.data3;
    request.data4 = self.titleTextField.text;
    request.data5 = self.contentTextView.text;
    request.data6 = self.saveRequest.data6;
    if ([self.saveRequest.data8 integerValue] == 1) {
        request.data9 = kUser.anonymousHeaderUrl;
        request.data10 = kUser.anonymousName;
    } else {
        request.data9 = kUser.headerUrl;
        request.data10 = kUser.name;
    }
    request.data8 = self.saveRequest.data8;
    request.id = self.saveRequest.id;
    request.hideLoadingView = YES;
    CKWeakify(self);
    dispatch_group_enter(_group);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    } failHandler:^(BaseResponse * _Nonnull response) {
        dispatch_group_leave(self->_group);
    }];
}
#pragma mark -
- (void)refreshView {
    if (self.photoSource.count > 0) {
        self.contentImage = self.photoSource[0];
        [self uploadImage];
    }
}
#pragma mark - SetupView
- (void)setupView {
    UITextField *textField = [UITextField.alloc init];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).mas_offset(10);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.height.mas_equalTo(40);
    }];
    [textField setFont:KSFProRoundedRegularFont(16)];
    [textField setTextColor:K_BlackColor];
    
    NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:@"Give this diary a title"];
    [attString addAttribute:NSForegroundColorAttributeName value:K_TextDrakGrayColor range:NSMakeRange(0, @"Give this diary a title".length)];
    [textField setAttributedPlaceholder:attString];
    
    [textField setTextAlignment:NSTextAlignmentCenter];
    [textField setText:self.saveRequest.data4];
    self.titleTextField = textField;
    
    UIView *lineView = [UIView.alloc init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom).mas_offset(10);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.height.mas_equalTo(0.5);
    }];
    [lineView setBackgroundColor:K_SepLineColor];
    
    
    UIView *itemView = [UIView.alloc init];
    [self.view addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    __block UIView *lastItemView = nil;
    NSArray *nameArray = [NSArray arrayWithObjects:self.saveRequest.data1,self.saveRequest.data2, nil];
    for (NSString *string in nameArray) {
        UIView *view = [UIView.alloc init];
        [itemView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastItemView) {
                make.left.equalTo(itemView.mas_left);
            } else {
                make.left.equalTo(lastItemView.mas_right).mas_offset(10);
            }
            make.height.mas_equalTo(24);
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
    
    UITextView *textView = [UITextView.alloc init];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemView.mas_bottom).mas_offset(20*CK_HEIGHT_Sales);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.height.mas_equalTo(140*CK_HEIGHT_Sales);
    }];
    textView.delegate = self;
    [textView setFont:KSFProRoundedRegularFont(16)];
    [textView setTextColor:K_BlackColor];
    
    self.contentTextView = textView;
    
    UILabel *placeholdLabel = [UILabel.alloc init];
    [self.view addSubview:placeholdLabel];
    [placeholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_top).mas_offset(5);
        make.left.equalTo(textView.mas_left).mas_offset(5);
        make.right.equalTo(textView.mas_right).mas_offset(-5);
    }];
    [placeholdLabel setText:@"I like you who take notes seriously, tell me how your day is going"];
    [placeholdLabel setNumberOfLines:0];
    [placeholdLabel setFont:KSFProRoundedRegularFont(16)];
    [placeholdLabel setTextColor:K_TextDrakGrayColor];
    if (self.saveRequest.data5.length > 0) {
        [textView setText:self.saveRequest.data5];
        [placeholdLabel setHidden:YES];
    }
    self.placeholdLabel = placeholdLabel;
    
    UIButton *imageButton = [UIButton k_buttonWithTarget:self action:@selector(imageButtonAction:)];
    [self.view addSubview:imageButton];
    [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).mas_equalTo(10*CK_HEIGHT_Sales);
        make.left.equalTo(self.view.mas_left).mas_offset(15);
        make.width.height.mas_equalTo(88);
    }];
    [imageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageButton.layer setCornerRadius:8];
    [imageButton setClipsToBounds:YES];
    [imageButton setBackgroundColor:K_TextLightGrayColor];
    self.imageButton = imageButton;
    
    
    UIButton *deleteButton = [UIButton k_buttonWithTarget:self action:@selector(deleteImageAction:)];
    [self.view addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageButton.mas_top);
        make.right.equalTo(imageButton.mas_right);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(28);
    }];
    [deleteButton setImage:[UIImage imageNamed:@"diary_delete_icon"] forState:UIControlStateNormal];
    
    self.deleteButton = deleteButton;
    
    if (self.saveRequest.data6.length > 0) {
        [imageButton sd_setImageWithURL:[NSURL URLWithString:self.saveRequest.data6] forState:UIControlStateNormal];
        [deleteButton setHidden:NO];
    } else {
        [imageButton setImage:[UIImage imageNamed:@"add_image_icon"] forState:UIControlStateNormal];
        [deleteButton setHidden:YES];
    }
    
    {
        UILabel *synLabel = [UILabel.alloc init];
        [self.view addSubview:synLabel];
        [synLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageButton.mas_bottom).mas_offset(34*CK_HEIGHT_Sales);
            make.left.equalTo(self.view.mas_left).mas_offset(15);
        }];
        [synLabel setText:@"Synchronize"];
        [synLabel setFont:KSFProRoundedMediumFont(16)];
        [synLabel setTextColor:[UIColor k_colorWithHex:0x484A49FF]];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(synButtonAction:)];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(synLabel.mas_centerY);
            make.right.equalTo(self.view.mas_right).mas_offset(-15);
        }];
        [button setImage:[UIImage imageNamed:@"switch_off_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"switch_on_icon"] forState:UIControlStateSelected];
        [button setSelected:[self.saveRequest.data7 integerValue] == 1];
    }
    {
        UILabel *synLabel = [UILabel.alloc init];
        [self.view addSubview:synLabel];
        [synLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageButton.mas_bottom).mas_offset(90*CK_HEIGHT_Sales);
            make.left.equalTo(self.view.mas_left).mas_offset(15);
        }];
        [synLabel setText:@"Turn on anonymity"];
        [synLabel setFont:KSFProRoundedMediumFont(16)];
        [synLabel setTextColor:[UIColor k_colorWithHex:0x484A49FF]];
        
        UIButton *button = [UIButton k_buttonWithTarget:self action:@selector(turnButtonAction:)];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(synLabel.mas_centerY);
            make.right.equalTo(self.view.mas_right).mas_offset(-15);
        }];
        [button setImage:[UIImage imageNamed:@"switch_off_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"switch_on_icon"] forState:UIControlStateSelected];
        [button setSelected:[self.saveRequest.data8 integerValue] == 1];
    }
}
#pragma mark - IBAction
- (void)saveButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.isShowDateView) {
        [self.calendatView hide];
    }
    _group = dispatch_group_create();
    [self saveDiaryRequest];
    if ([self.saveRequest.data7 integerValue] == 1) {
        [self saveCycleRequest];
    }
    CKWeakify(self);
    dispatch_group_notify(self->_group, dispatch_get_main_queue(), ^{
        if (self.isEditData) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    });
}
- (void)centerButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.isShowDateView) {
        [self.calendatView hide];
        self.showDateView = NO;
        return;
    }
    [self.calendatView show];
    self.showDateView = YES;
}
- (void)imageButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self addImage];
}
- (void)deleteImageAction:(UIButton *)sender {
    self.saveRequest.data6 = @"";
    [sender setHidden:YES];
    [self.imageButton setImage:[UIImage imageNamed:@"add_image_icon"] forState:UIControlStateNormal];
}
- (void)synButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.saveRequest.data7 = sender.isSelected?@"1":@"0";
}
- (void)turnButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.saveRequest.data8 = sender.isSelected?@"1":@"0";
}
- (NSAttributedString *)timeStringWithYearAndMonth:(NSString *)yearMont day:(NSString *)day {
    NSMutableAttributedString *attString = [NSMutableAttributedString.alloc initWithString:[NSString stringWithFormat:@"%@ %@  ",day,yearMont]];
    [attString addAttribute:NSFontAttributeName value:KSFProRoundedMediumFont(18) range:NSMakeRange(0, day.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:K_BlackColor range:NSMakeRange(0, day.length)];
    
    return attString;
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    if (pointLength > 0) {
        self.placeholdLabel.hidden = YES;
    } else {
        self.placeholdLabel.hidden = NO;
    }
    return YES;
}
#pragma mark - Getter
- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton k_buttonWithTarget:self action:@selector(saveButtonAction:)];
        [_saveButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [_saveButton.titleLabel setFont:KSFProRoundedMediumFont(14)];
        [_saveButton setTitleColor:K_BlackColor forState:UIControlStateNormal];
        [_saveButton setTitleColor:K_TextLightGrayColor forState:UIControlStateDisabled];
//        [_saveButton setEnabled:NO];
    }
    return _saveButton;
}
- (UIButton *)centerButton {
    if (!_centerButton) {
        _centerButton = [UIButton k_buttonWithTarget:self action:@selector(centerButtonAction:)];
        [_centerButton setFrame:CGRectMake(0, 0, 120, 44)];
        [_centerButton setTitle:@"12 2023-01  " forState:UIControlStateNormal];
        [_centerButton.titleLabel setFont:KSFProRoundedMediumFont(14)];
        [_centerButton setTitleColor:K_TextGrayColor forState:UIControlStateNormal];
        [_centerButton setTitleColor:K_TextLightGrayColor forState:UIControlStateDisabled];
        [_centerButton setImage:[UIImage imageNamed:@"down_point_icon"] forState:UIControlStateNormal];
        [_centerButton setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
    }
    return _centerButton;
}
- (WSCalendarView *)calendatView {
    if (!_calendatView) {
        _calendatView = [WSCalendarView.alloc initYear:self.year month:self.month day:self.day];
        _calendatView.attachedView = self.view;
//        [_calendatView show];
        CKWeakify(self);
        [_calendatView setSelectedDate:^(NSInteger year, NSInteger month, NSInteger day) {
            weakSelf.year = year;
            weakSelf.month = month;
            weakSelf.day = day;
            [weakSelf.centerButton setAttributedTitle:[weakSelf timeStringWithYearAndMonth:[NSString stringWithFormat:@"%ld-%ld",year,month] day:[NSString stringWithFormat:@"%ld",day]] forState:UIControlStateNormal];
            weakSelf.saveRequest.data3 = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
        }];
        
        [_calendatView setHideCompletionBlock:^(MMPopupView *view, BOOL isFinsh) {
            if (isFinsh) {
                weakSelf.showDateView = NO;
            }
        }];
    }
    return _calendatView;
}
@end
