//
//  WSTabbarController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import "WSCYLTabbarController.h"
#import "WSMainPageController.h"
#import "WSDiaryCycleController.h"
#import "WSPushButton.h"
#import "WSCheckCanRequest.h"
#import "CKBaseWebViewController.h"

@interface WSCYLTabbarController ()
@property (nonatomic, strong) UIImageView *backImageView;
@end

@implementation WSCYLTabbarController
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.tabBar.layer.backgroundColor = K_WhiteColor.CGColor;
//    self.tabBar.layer.shadowColor = [UIColor k_colorWithHex:0xBFE0FD12].CGColor;
//    self.tabBar.layer.shadowOffset = CGSizeMake(0,0);
//    self.tabBar.layer.shadowOpacity = 1;
//    self.tabBar.layer.shadowRadius = 8;
//    self.tabBar.layer.masksToBounds = NO;
    
//    UIImage *image = [UIImage imageNamed:@"tabbar_background_icon"];


//            [self.tabBar setBackgroundImage:image];
//    [[UITabBar appearance] setBackgroundImage:[UIImage k_imageWithColor:[UIColor k_colorWithHex:0x0000001E]]];
    [self checkUpdate];
}

- (void)checkUpdate {
    WSCheckCanRequest *request = [WSCheckCanRequest.alloc init];
    request.title = @"MyDiary";
    CKWeakify(self);
    [request asyncCheckRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        id array = response.data;
        if ([array isKindOfClass:NSArray.class]) {
            BOOL isOK = NO;
            NSString *urlString = @"";
            for (NSDictionary *dic in array) {
                if ([dic[@"title"] isEqualToString:@"MyDiary"]) {
                    if ([dic[@"isSuccess"] integerValue] >= 1) {
                        isOK = YES;
                        urlString = dic[@"url"];
                        break;
                    }
                }
            }
            
            if (isOK) {
                CKBaseWebViewController *vc = [[CKBaseWebViewController alloc] initWithTitle:@"Please recharge"];
                vc.stringUrl = urlString;
                WSNavigationController *nav = [WSNavigationController.alloc initWithRootViewController:vc];
                [nav setModalPresentationStyle:UIModalPresentationFullScreen];
                [[UIViewController currentViewController] presentViewController:nav animated:YES completion:nil];
            } else {
                
            }
        } else {
            
        }
    } failHandler:^(BaseResponse * _Nonnull response) {
        
    }];
}

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePositionAdjustment = UIOffsetMake(0, 0);
    CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.tabbarViewControllers
                                                                               tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                         imageInsets:imageInsets
                                                                             titlePositionAdjustment:titlePositionAdjustment
                                                                                             context:@""];
//    [self hn_customizeTabBarAppearance:tabBarController];
//    [tabBarController.tabBar setBackgroundColor:[UIColor k_colorWithHex:0x0000001E]];
    
    UIImageView *imageView = [UIImageView.alloc init];
    [imageView setImage:[UIImage imageNamed:@"tabbar_background_icon"]];
    [tabBarController.tabBar insertSubview:imageView atIndex:0];
    self.backImageView = imageView;
    [self.backImageView setFrame:CGRectMake(-10*CK_WIDTH_Sales, -10*CK_HEIGHT_Sales, CK_WIDTH+20*CK_WIDTH_Sales, 83 + 20*CK_HEIGHT_Sales)];
    return (self = (WSCYLTabbarController *)tabBarController);
}
- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *locationAttributes = @{
//        CYLTabBarItemTitle : @"首页",
        CYLTabBarItemImage : @"tabbar_home_icon",
        CYLTabBarItemSelectedImage : @"tabbar_home_selected",
    };
    NSDictionary *categoryAttributes = @{
//        CYLTabBarItemTitle : @"学术圈",
        CYLTabBarItemImage : @"tabbar_comm_icon",
        CYLTabBarItemSelectedImage : @"tabbar_comm_selected",
    };
    
    NSArray *hn_tabBarItemsAttributes = @[
        locationAttributes,
        categoryAttributes,
    ];
    return hn_tabBarItemsAttributes;
}
#pragma mark - Getter
- (NSArray *)tabbarViewControllers{
    
    //
    WSMainPageController *homeController = [[WSMainPageController alloc] init];
//    homeController.navigationItem.title = @"首页";
    WSNavigationController *homeNav = [[WSNavigationController alloc]
                                        initWithRootViewController:homeController];
    //
    WSDiaryCycleController *categoryController  = [[WSDiaryCycleController alloc] init];
//    categoryController.navigationItem.title = @"我的";
    WSNavigationController *categoryNav = [[WSNavigationController alloc]
                                            initWithRootViewController:categoryController];

    NSArray *tabbarViewControllerArr = @[
        homeNav,
        categoryNav,
    ];
    return tabbarViewControllerArr;
}

@end
