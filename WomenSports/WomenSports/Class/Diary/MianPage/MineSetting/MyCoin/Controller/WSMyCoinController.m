//
//  WSMyCoinController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSMyCoinController.h"
#import "WSMyCoinCollectionCell.h"
#import "WSGetMyAssetRequest.h"
#import "WSRechageListConfigRequest.h"
#import "WSAppleCheckBillRequest.h"

//导入文件：
#import <StoreKit/StoreKit.h>

@interface WSMyCoinController ()<UICollectionViewDelegate,UICollectionViewDataSource,SKPaymentTransactionObserver, SKProductsRequestDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) NSMutableArray *dataSouce;
@property (nonatomic, strong) WSRechageListConfigModel *selectedModel;
@end

@implementation WSMyCoinController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary *textAttributes = @{
        NSFontAttributeName : KSFProRoundedBoldFont(18),
        NSForegroundColorAttributeName : K_WhiteColor,
    };
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        barApp.titleTextAttributes = textAttributes;
        barApp.backgroundColor = UIColor.clearColor;
        barApp.shadowColor = UIColor.clearColor;
        barApp.backgroundEffect = nil;
        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
        self.navigationController.navigationBar.standardAppearance = barApp;
    } else  {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage k_imageWithColor:UIColor.clearColor] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    }
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Recharge";
    self.dataSouce = [NSMutableArray array];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem.alloc initWithCustomView:self.backButton];
    [self headerView];
    
    UILabel *titleLabel = [UILabel.alloc init];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).mas_offset(20);
        make.left.equalTo(self.view.mas_left).mas_offset(15);
    }];
    [titleLabel setTextColor:K_TextDrakGrayColor];
    [titleLabel setFont:KSFProRoundedBoldFont(16)];
    [titleLabel setText:@"Recharge Amount"];
    
    [self loadData];
    [self loadListData];
    
    //设置支付服务
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
//结束后一定要销毁
- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
- (void)loadData {
    WSGetMyAssetRequest *request = [WSGetMyAssetRequest.alloc init];
    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSGetMyAssetModel *model = response.data;
        [weakSelf.coinLabel setText:model.amount];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}
- (void)loadListData {
    WSRechageListConfigRequest *request = [WSRechageListConfigRequest.alloc init];
    request.type = @"2";
    request.first = @"0";
    request.pkgName = WSPackageName;
    request.rechargeType = @"1";
//    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [weakSelf.dataSouce removeAllObjects];
        [weakSelf.dataSouce addObjectsFromArray:response.data];
        [weakSelf.collectionView reloadData];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}

- (void)checkApplePay:(NSString *)dicData {
    WSAppleCheckBillRequest *request = [WSAppleCheckBillRequest.alloc init];
    request.billNo = dicData;
    request.pkgName = WSPackageName;
//    request.hideLoadingView = YES;
    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        [MBProgressHUD showSuccessfulWithMessage:@""];
        [weakSelf loadData];
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}

//请求苹果后台商品
- (void)getRequestAppleProductID:(NSString *)productID {
    //ApplePayInPurchase对应着苹果后台的商品ID,他们是通过这个ID进行联系的
    NSArray *product = [[NSArray alloc] initWithObjects:productID , nil];
    NSSet *nsset = [NSSet setWithArray:product];
    //初始化请求
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    //开始请求
    [request start];
}
#pragma mark - IBAction
-(void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    //服务器没有产品
    if ([product count] == 0) {
        NSLog(@"服务器没有产品");
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:@"No such product"];
        });
        
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showLoadingWithMessage:@""];
    });
    SKProduct *requestProduct = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        //如果后台消费条目的ID与我这里需要请求的一样（用于确保订单的正确性）
        if ([pro.productIdentifier isEqualToString:self.selectedModel.code]) {
            requestProduct = pro;
        }
    }
    //发送购买请求
    SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
#pragma mark -- SKRequestDelegate
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"请求失败error: %@", error);
}
//反馈请求的产品信息结束后
- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"信息反馈结束");
}
#pragma mark -- SKPaymentTransactionObserver
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased://购买成功
                NSLog(@"交易完成");
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing://正在处理
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored://恢复购买
                NSLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
                
            default:
                break;
        }
    }
}

//交易结束,当交易结束后还要去appstore上验证支付信息是否都正确,只有所有都正确后,我们就可以给用户方法我们的虚拟物品了
- (void) completeTransaction:(SKPaymentTransaction *)transaction {
    NSString *str = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSString *environment = [self environmentForReceipt:str];
    NSLog(@"----- 完成交易调用的方法completeTransaction 1--------%@",environment);
    //验证凭据，获取到苹果返回的交易凭据
       NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
       //从沙盒中获取到购买凭据
       NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
       //BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
       //BASE64是可以编码和解码的
       NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//       NSString *sendString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
//       NSLog(@"_____%@",sendString);
//       NSURL *StoreURL=nil;
//       if ([environment isEqualToString:@"environment=Sandbox"]) {
//           StoreURL = [[NSURL alloc] initWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
//       }else {
//           StoreURL = [[NSURL alloc] initWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
//       }
//       //这个二进制数据由服务器进行验证；zl
//       NSData *postData = [NSData dataWithBytes:[sendString UTF8String] length:[sendString length]];
//       NSLog(@"++++++%@",postData);
//       NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:StoreURL];
//       [connectionRequest setHTTPMethod:@"POST"];
//       [connectionRequest setTimeoutInterval:50.0];//120.0---50.0zl
//       [connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
//       [connectionRequest setHTTPBody:postData];
//       //开始请求
//       NSError *error=nil;
//       NSData *responseData=[NSURLConnection sendSynchronousRequest:connectionRequest returningResponse:nil error:&error];
//       if (error) {
//           NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
//           return;
//       }
//       NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//       NSLog(@"请求成功后的数据:%@",dic);
       
       //这里可以等待上面请求的数据完成后并且state = 0 验证凭据成功来判断后进入自己服务器逻辑的判断,也可以直接进行服务器逻辑的判断,验证凭据也就是一个安全的问题。楼主这里没有用state = 0 来判断。
    [self checkApplePay:encodeStr];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
       NSString *product = transaction.payment.productIdentifier;
       NSLog(@"transaction.payment.productIdentifier++++%@",product);
       if ([product length] > 0) {
           NSArray *tt = [product componentsSeparatedByString:@"."];
           NSString *bookid = [tt lastObject];
           if([bookid length] > 0) {
               NSLog(@"打印bookid%@",bookid);
               //这里可以做操作吧用户对应的虚拟物品通过自己服务器进行下发操作,或者在这里通过判断得到用户将会得到多少虚拟物品,在后面（[self getApplePayDataToServerRequsetWith:transaction];的地方）上传上面自己的服务器。
           }
       }
       //此方法为将这一次操作上传给我本地服务器,记得在上传成功过后一定要记得销毁本次操作。调用[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
   //    [self getApplePayDataToServerRequsetWith:transaction];
       NSLog(@"--->> %@", transaction);
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(NSString * )environmentForReceipt:(NSString * )str {
    str= [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray * arr=[str componentsSeparatedByString:@";"];
    //存储收据环境的变量
    NSString * environment=arr[2];
    return environment;
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSouce.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSMyCoinCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WSMyCoinCollectionCell.class) forIndexPath:indexPath];
    WSRechageListConfigModel *model = self.dataSouce[indexPath.row];
    [cell.coinLabel setText:model.gold];
    [cell.moneyLabel setText:[NSString stringWithFormat:@"%.2f",[model.price floatValue]]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    WSRechageListConfigModel *model = self.dataSouce[indexPath.row];
    self.selectedModel = model;
    [self getRequestAppleProductID:model.code];
}
#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        [flowLayout setMinimumInteritemSpacing:10];
        [flowLayout setMinimumLineSpacing:20];
        [flowLayout setItemSize:CGSizeMake((CK_WIDTH - 50) / 3.0f, 80)];
        [flowLayout setSectionHeadersPinToVisibleBounds:YES];
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.top.equalTo(self.headerView.mas_bottom).mas_offset(60);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setPagingEnabled:YES];
        [_collectionView setBackgroundColor:K_WhiteColor];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(WSMyCoinCollectionCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(WSMyCoinCollectionCell.class)];
    }
    return _collectionView;
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton k_buttonWithTarget:self action:@selector(backButtonAction:)];
        [_backButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_backButton setImage:[UIImage imageNamed:@"person_back_icon"] forState:UIControlStateNormal];
    }
    return _backButton;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView.alloc init];
        [self.view addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(170*CK_HEIGHT_Sales);
        }];
        
        UIImageView *imageView = [UIImageView.alloc init];
        [_headerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_headerView).with.insets(UIEdgeInsetsZero);
        }];
        [imageView setImage:[UIImage imageNamed:@"coin_header_icon"]];
        
        UIImageView *hImageView = [UIImageView.alloc init];
        [_headerView addSubview:hImageView];
        [hImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.equalTo(_headerView).insets(UIEdgeInsetsMake(0, 15, 20, 0));
            make.height.width.mas_equalTo(44);
        }];
        [hImageView setContentMode:UIViewContentModeScaleAspectFill];
        [hImageView.layer setCornerRadius:22];
        [hImageView.layer setBorderWidth:2];
        [hImageView.layer setBorderColor:K_WhiteColor.CGColor];
//        [hImageView setImage:[UIImage imageNamed:@"set_header_icon"]];
        [hImageView sd_setImageWithURL:[NSURL URLWithString:kUser.headerUrl] placeholderImage:[UIImage imageNamed:@"set_header_icon"]];
        [hImageView setClipsToBounds:YES];
        
        UILabel *nameLabel = [UILabel.alloc init];
        [_headerView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hImageView.mas_right).mas_offset(10);
            make.centerY.equalTo(hImageView.mas_centerY);
        }];
        [nameLabel setTextColor:K_WhiteColor];
        [nameLabel setFont:KSFProRoundedMediumFont(14)];
        [nameLabel setText:kUser.name];
        
        UILabel *coinNum = [UILabel.alloc init];
        [_headerView addSubview:coinNum];
        [coinNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView.mas_right).mas_offset(-15);
            make.centerY.equalTo(hImageView.mas_centerY);
        }];
        [coinNum setTextColor:K_WhiteColor];
        [coinNum setFont:KSDINBoldFont(22)];
        [coinNum setText:@"--"];
        self.coinLabel = coinNum;
        
        UILabel *coinTitle = [UILabel.alloc init];
        [_headerView addSubview:coinTitle];
        [coinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(coinNum.mas_left).mas_offset(-5);
            make.centerY.equalTo(hImageView.mas_centerY);
        }];
        [coinTitle setTextColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
        [coinTitle setFont:KSFProRoundedMediumFont(16)];
        [coinTitle setText:@"My coins:"];
    }
    return _headerView;
}
@end
