//
//  WSLoginNavigationController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSLoginNavigationController.h"

@interface WSLoginNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation WSLoginNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *textAttributes = @{
        NSFontAttributeName : KSFProRoundedBoldFont(18),
        NSForegroundColorAttributeName : K_TextMainColor,
    };
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        barApp.titleTextAttributes = textAttributes;
        barApp.backgroundColor = K_MainColor;
        barApp.shadowColor = nil;
        barApp.backgroundEffect = nil;
        navigationBarAppearance.scrollEdgeAppearance = barApp;
        navigationBarAppearance.standardAppearance = barApp;
    } else  {
        [navigationBarAppearance setBackgroundImage:[UIImage k_imageWithColor:K_MainColor] forBarMetrics:UIBarMetricsDefault];
        [navigationBarAppearance setShadowImage:[UIImage k_imageWithColor:K_MainColor]];
        [navigationBarAppearance setTitleTextAttributes:textAttributes];
    }
    navigationBarAppearance.translucent = NO;
    self.delegate = self;
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

- (void)backController {
    [self popViewControllerAnimated:YES];
    //如果栈顶控制器是首页就显示tabbar
    if (self.viewControllers.count == 1) {
//        self.tabBarController.tabBar.hidden = NO;
    }
    
}
#pragma mark - Override
/// 跳转下一页事件
/// @param viewController 跳转的视图控制器
/// @param animated 是否动画
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
//        self.tabBarController.tabBar.hidden = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button sizeToFit];
        button.frame = CGRectMake(0, 0, 44, 44);
        [button setTitle:@"  " forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"navigation_back_white"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigation_back_white"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(backController) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    [super pushViewController:viewController animated:animated];
}
#pragma mark - ovrrideMethod
+ (void)initialize {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        textAttributes = @{
            NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0f],
            NSForegroundColorAttributeName : [UIColor whiteColor],
        };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        textAttributes = @{
            UITextAttributeFont : [UIFont boldSystemFontOfSize:18.0f],
            UITextAttributeTextColor : [UIColor whiteColor],
            UITextAttributeTextShadowColor : [UIColor clearColor],
            UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
        };
#endif
    }
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

@end
