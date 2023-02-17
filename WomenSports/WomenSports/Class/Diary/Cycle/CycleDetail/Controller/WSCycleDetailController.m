//
//  WSCycleDetailController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSCycleDetailController.h"
#import "WSCycleImageTableCell.h"
#import "WSCycleCotentTableCell.h"
#import "WSCommunityCommentTableCell.h"
#import "WSCommunityComBottomView.h"
#import "WSPersonPController.h"
#import "WSAddOrEditCommentRequest.h"
#import "WSCycleDetailRequest.h"
#import "WSLikeCycleRequest.h"
#import "WSCancelLikeRequest.h"
#import "WSFollowingRequest.h"
#import "WSCheckFollowRequest.h"
#import "WSCancelFollowRequest.h"
#import "WSSheetView.h"
#import "WSBlackListRepoRequest.h"
#import "WSGiftPopupView.h"
#import "WSSendGiftRequest.h"

@interface WSCycleDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *personView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL imageDetail;
@property (nonatomic, strong) WSCommunityComBottomView *comBottomView;
@end

@implementation WSCycleDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backItem = [UIBarButtonItem.alloc initWithCustomView:self.backButton];
    UIBarButtonItem *personItem = [UIBarButtonItem.alloc initWithCustomView:self.personView];
    self.navigationItem.leftBarButtonItems = @[backItem,personItem];
    if (![self.detailModel.userId isEqualToString:kUser.uid] && [self.detailModel.data8 integerValue] != 1) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.moreButton];
    }
    
    CKWeakify(self);
    self.tableView.mj_header = [CKRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf reloadDetail];
    }];
    [weakSelf.tableView.mj_header beginRefreshing];
}
- (void)reloadDetail {
    WSCycleDetailRequest *request = [WSCycleDetailRequest.alloc init];
    request.id = self.detailModel.id;
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.detailModel = response.data;
        [weakSelf.comBottomView setModel:weakSelf.detailModel];
        [weakSelf.tableView reloadData];
    } failHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)sendCommentWithString:(NSString *)string {
    WSAddOrEditCommentRequest *request = [WSAddOrEditCommentRequest.alloc init];
    request.data1 = kUser.headerUrl;
    request.data2 = kUser.name;
    request.data3 = string;
    request.data4 = 0;
    request.packageName = WSPackageName;
    request.deviceType = WSDeviceType;
    request.pid = self.detailModel.id;
//    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf reloadDetail];
        [MBProgressHUD showSuccessfulWithMessage:@"Comment succeeded"];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)likeCycleWithModel:(WSCycleDetailModel *)model {
    WSLikeCycleRequest *request = [WSLikeCycleRequest.alloc init];
    request.auditTreeDataId = model.id;
    request.type = @"1";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        model.data11 = model.data11 + 1;
        NSMutableArray *array = [NSMutableArray arrayWithArray:model.listActionType];
        [array addObject:@1];
        model.listActionType = array;
        [weakSelf.comBottomView setModel:model];
        [weakSelf uploadDetailWithModel:model];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)cancelLikeWithModel:(WSCycleDetailModel *)model {
    WSCancelLikeRequest *request = [WSCancelLikeRequest.alloc init];
    request.auditTreeDataId = model.id;
    request.type = @"1";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        model.data11 = model.data11 - 1;
        NSMutableArray *array = [NSMutableArray arrayWithArray:model.listActionType];
        [array removeObject:@1];
        model.listActionType = array;
        [weakSelf.comBottomView setModel:model];
        [weakSelf uploadDetailWithModel:model];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)uploadDetailWithModel:(WSCycleDetailModel *)model {
    WSCycleAddOrEditRequest *request = [WSCycleAddOrEditRequest mj_objectWithKeyValues:model.mj_keyValues];
    request.hideLoadingView = YES;
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)likeCommentWithModel:(WSCycleDetailChildModel *)model {
    WSLikeCycleRequest *request = [WSLikeCycleRequest.alloc init];
    request.auditTreeDataId = model.id;
    request.type = @"1";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        model.data4 = model.data4 + 1;
        NSMutableArray *array = [NSMutableArray arrayWithArray:model.listActionType];
        [array addObject:@1];
        model.listActionType = array;
        [weakSelf.tableView reloadData];
        [weakSelf uploadCommentWithModel:model];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)cancelCommentLikeWithModel:(WSCycleDetailChildModel *)model {
    WSCancelLikeRequest *request = [WSCancelLikeRequest.alloc init];
    request.auditTreeDataId = model.id;
    request.type = @"1";
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        model.data4 = model.data4 - 1;
        NSMutableArray *array = [NSMutableArray arrayWithArray:model.listActionType];
        [array removeObject:@1];
        model.listActionType = array;
        [weakSelf.tableView reloadData];
        [weakSelf uploadCommentWithModel:model];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)uploadCommentWithModel:(WSCycleDetailChildModel *)model {
    WSAddOrEditCommentRequest *request = [WSAddOrEditCommentRequest mj_objectWithKeyValues:model.mj_keyValues];
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
//        [weakSelf reloadDetail];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)followingUser {
    WSFollowingRequest *request = [WSFollowingRequest.alloc init];
    request.userId = self.detailModel.userId;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)checkFollow {
    WSCheckFollowRequest *request = [WSCheckFollowRequest.alloc init];
    request.userId = self.detailModel.userId;
//    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        BOOL isFollow = [response.data boolValue];
        [weakSelf showAlterViewFollow:isFollow];

    } failHandler:^(BaseResponse * _Nonnull response) {
    }];
}
- (void)cancelFollow {
    WSCancelFollowRequest *requet = [WSCancelFollowRequest.alloc init];
    requet.userId = self.detailModel.userId;
    [requet asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
    } failHandler:^(BaseResponse * _Nonnull response) {
    }];
}
- (void)repoWithUserContent:(NSString *)content {
    WSBlackListRepoRequest *request = [WSBlackListRepoRequest.alloc init];
    request.userId = self.detailModel.userId;
    request.content = content;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [MBProgressHUD showSuccessfulWithMessage:@""];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)sendGiftGiftModel:(WSGiftModel *)giftModel {
    WSSendGiftRequest *request = [WSSendGiftRequest.alloc init];
    request.userId = self.detailModel.userId;
    request.giftId = giftModel.id;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSSendGiftModel *sendModel = response.data;
        if (sendModel.enough == 0) {
            [MBProgressHUD showMessage:@"Fee deduction failed"];
        } else {
            weakSelf.detailModel.data13 = weakSelf.detailModel.data13 + 1;
            [weakSelf.tableView reloadData];
            [weakSelf uploadDetailWithModel:weakSelf.detailModel];
            [MBProgressHUD showSuccessfulWithMessage:@""];
        }
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
#pragma mark - IBAction
- (void)showAlterViewFollow:(BOOL)isFowoll {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 1) {
            [weakSelf showReportSheet];
        } else {
            if (isFowoll) {
                [weakSelf cancelFollow];
            } else {
                [weakSelf followingUser];
            }
        }
    };
    NSArray *items = @[MMItemMake(@"Follow", MMItemTypeNormal, block),
                       MMItemMake(@"Report complaints", MMItemTypeNormal, block)];
    if (isFowoll) {
        items = @[MMItemMake(@"Unfollow", MMItemTypeNormal, block),
                           MMItemMake(@"Report complaints", MMItemTypeNormal, block)];
    }
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    [view show];
}
- (void)showReportSheet {
    CKWeakify(self);
    MMPopupItemHandler block = ^(NSInteger index){
        NSString *string = @"Other";
        if (index == 0) {
            string = @"Pornographic vulgar";
        } else if (index == 1) {
            string = @"Advertising fraud";
        } else if (index == 2) {
            string = @"Politically sensitive";
        } else if (index == 3) {
            string = @"Bloody terror";
        } else if (index == 4) {
            string = @"Incite war and abuse";
        }
        [weakSelf repoWithUserContent:string];
    };
    NSArray *items = @[MMItemMake(@"Pornographic vulgar", MMItemTypeNormal, block),
                       MMItemMake(@"Advertising fraud", MMItemTypeNormal, block),
                       MMItemMake(@"Politically sensitive", MMItemTypeNormal, block),
                       MMItemMake(@"Bloody terror", MMItemTypeNormal, block),
                       MMItemMake(@"Incite war and abuse", MMItemTypeNormal, block),
                       MMItemMake(@"Other", MMItemTypeNormal, block),
    ];
    WSSheetView *view = [WSSheetView.alloc initWithItem:items];
    [view show];
}
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)moreButtonAction:(UIButton *)sender {
    [self checkFollow];
}
- (void)personPageAction:(UITapGestureRecognizer *)sender {
    if ([self.detailModel.data8 integerValue] == 1) {
        return;
    }
    WSPersonPController *vc = [WSPersonPController.alloc init];
    vc.userIdString = self.detailModel.userId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)giftViewShow {
    
    WSGiftPopupView *view = [WSGiftPopupView.alloc init];
    CKWeakify(self);
    [view setDidSendGift:^(WSGiftModel * _Nonnull giftModel) {
        [weakSelf sendGiftGiftModel:giftModel];
    }];
    
    [view show];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.detailModel.data6.length > 0) {
            return 2;
        }
        return 1;
    }
    return self.detailModel.child.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.detailModel.data6.length > 0 && indexPath.row == 0) {
            WSCycleImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSCycleImageTableCell.class)];
            [cell.pimageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.data6]];
            return cell;
        }
        WSCycleCotentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSCycleCotentTableCell.class)];
        [cell.titleLabel setText:self.detailModel.data4];
        [cell.contentLabel setText:self.detailModel.data5];
        [cell.timeLabel setText:self.detailModel.createTimeString];
        return cell;
    }
    WSCommunityCommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(WSCommunityCommentTableCell.class)];
    [cell setModel:self.detailModel.child[indexPath.row]];
    CKWeakify(self);
    [cell setDidClickLike:^(WSCycleDetailChildModel * _Nonnull model, BOOL isLike) {
        if (isLike) {
            [weakSelf likeCommentWithModel:model];
        } else {
            [weakSelf cancelCommentLikeWithModel:model];
        }
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.detailModel.data6.length > 0 && indexPath.row == 0) {
        [self showBrowerWithIndex:0 data:@[self.detailModel.data6] view:nil];
    }
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
        [label setFont:KSFProRoundedRegularFont(14)];
        [label setTextColor:K_BlackColor];
        
        UILabel *numLabel = [UILabel.alloc init];
        [view addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).mas_offset(5);
            make.centerY.equalTo(label.mas_centerY);
        }];
        [numLabel setText:[NSString stringWithFormat:@"%ld",self.detailModel.child.count]];
        [numLabel setTextColor:K_TextLightGrayColor];
        [numLabel setFont:KSFProRoundedRegularFont(14)];
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
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 49+KBottomSafeHeight, 0));
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:K_SepLineColor];
        [_tableView setBackgroundColor:UIColor.clearColor];
        [_tableView setTableFooterView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 21)]];
        [_tableView setTableHeaderView:[UIView.alloc initWithFrame:CGRectMake(0, 0, CK_WIDTH, 0.01f)]];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSCycleImageTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSCycleImageTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSCycleCotentTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSCycleCotentTableCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(WSCommunityCommentTableCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(WSCommunityCommentTableCell.class)];
    }
    return _tableView;
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton k_buttonWithTarget:self action:@selector(backButtonAction:)];
        [_backButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_backButton setImage:[UIImage imageNamed:@"navigation_back_white"] forState:UIControlStateNormal];
    }
    return _backButton;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton k_buttonWithTarget:self action:@selector(moreButtonAction:)];
        [_moreButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_moreButton setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
    }
    return _moreButton;
}
- (UIView *)personView {
    if (!_personView) {
        _personView = [UIView.alloc init];
        
        UIImageView *imageView= [UIImageView.alloc init];
        [_personView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(_personView).insets(UIEdgeInsetsZero);
            make.height.width.mas_equalTo(40);
        }];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView.layer setCornerRadius:20];
        [imageView setClipsToBounds:YES];
//        [imageView setImage:[UIImage imageNamed:@"set_header_icon"]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.data9] placeholderImage:[UIImage imageNamed:@"set_header_icon"]];
        
        UILabel *nameLabel = [UILabel.alloc init];
        [_personView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).mas_offset(12);
            make.right.equalTo(_personView.mas_right);
            make.centerY.equalTo(imageView.mas_centerY);
        }];
        [nameLabel setTextColor:K_TextGrayColor];
        [nameLabel setFont:KSFProRoundedMediumFont(14)];
        [nameLabel setText:self.detailModel.data10];
        
        [_personView addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:self action:@selector(personPageAction:)]];
    }
    return _personView;
}
- (WSCommunityComBottomView *)comBottomView {
    if (!_comBottomView) {
        _comBottomView = [WSCommunityComBottomView CommunityVBottomView];
        [self.view addSubview:_comBottomView];
        [_comBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(49+KBottomSafeHeight);
        }];
        CKWeakify(self);
        [_comBottomView setDidSendComment:^(NSString * _Nonnull string) {
            [weakSelf sendCommentWithString:string];
        }];
        [_comBottomView setDidClickGift:^{
            [MBProgressHUD showMessage:@"Under development..."];
//            [weakSelf giftViewShow];
        }];
        [_comBottomView setDidClickLike:^(BOOL isLike) {
            if (isLike) {
                [weakSelf likeCycleWithModel:weakSelf.detailModel];
            } else {
                [weakSelf cancelLikeWithModel:weakSelf.detailModel];
            }
        }];
    }
    return _comBottomView;
}
@end
