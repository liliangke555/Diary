//
//  WSTabbarController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSTabbarController.h"
#import "WSHomeController.h"
#import "WSCommuntyController.h"
#import "WSMinwDataController.h"

@interface WSTabbarController ()

@end

@implementation WSTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarItem *item1 = [UITabBarItem.alloc initWithTitle:@""
                                                      image:[[UIImage imageNamed:@"tabbar_home_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *item2 = [UITabBarItem.alloc initWithTitle:@""
                                                      image:[[UIImage imageNamed:@"tabbar_comm_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"tabbar_comm_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *item3 = [UITabBarItem.alloc initWithTitle:@""
                                                      image:[[UIImage imageNamed:@"tabbar_mine_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    WSHomeController *home = [WSHomeController.alloc init];
    home.tabBarItem = item1;
    WSNavigationController *homeNav = [WSNavigationController.alloc initWithRootViewController:home];
    
    WSCommuntyController *community = [WSCommuntyController.alloc init];
    community.tabBarItem = item2;
    WSNavigationController *communityNav = [WSNavigationController.alloc initWithRootViewController:community];
    
    WSMinwDataController *data = [WSMinwDataController.alloc init];
    data.tabBarItem = item3;
    WSNavigationController *dataNav = [WSNavigationController.alloc initWithRootViewController:data];
    
    
    [self setViewControllers:@[homeNav,communityNav,dataNav]];
    
    self.tabBar.layer.backgroundColor = K_WhiteColor.CGColor;
    self.tabBar.layer.shadowColor = [UIColor k_colorWithHex:0xBFE0FD12].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(2,-6);
    self.tabBar.layer.shadowOpacity = 1;
    self.tabBar.layer.shadowRadius = 8;
    self.tabBar.layer.masksToBounds = NO;
    
    
//    [self.tabBar setItems:@[item1,item2,item3]];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
