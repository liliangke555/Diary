//
//  AppDelegate+WSAppDelegate.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "AppDelegate+WSAppDelegate.h"
#import "WSLaunchController.h"
#import "WSLoginController.h"
#import "WSLoginNavigationController.h"
#import "WSTabbarController.h"

#import "WSMainPageController.h"
#import "WSDiaryCycleController.h"
#import "WSPushButton.h"
#import "WSCYLTabbarController.h"

@implementation AppDelegate (WSAppDelegate)
- (void)setLaunchView {
    WSLaunchController *view = [WSLaunchController.alloc init];
    [self.window setRootViewController:view];
}
- (void)setLoginView {
    WSLoginController *view = [WSLoginController.alloc init];
    WSLoginNavigationController *nav = [WSLoginNavigationController.alloc initWithRootViewController:view];
    
    [self.window setRootViewController:nav];
}

- (void)setTabbarView {
//    WSTabbarController *vc = [WSTabbarController.alloc init];
    
    [WSPushButton registerPlusButton];
    WSCYLTabbarController *tabbar = [WSCYLTabbarController.alloc init];
    tabbar.delegate = self;
    
    [self.window setRootViewController:tabbar];
}

@end
