//
//  AppDelegate+WSAppDelegate.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (WSAppDelegate)<CYLTabBarControllerDelegate>
- (void)setLaunchView;
- (void)setLoginView;
- (void)setTabbarView;
@end

NS_ASSUME_NONNULL_END
