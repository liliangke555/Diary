//
//  AppDelegate.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, copy) NSString *inviteeUid;
- (void)initEaIMKit;
- (void)registEasIMWithName:(NSString *)name password:(NSString *)password;
- (void)loginIMWithUsername:(NSString *)userName password:(NSString *)password;
- (void)setIMUrlWithurl:(NSString *)urlString name:(NSString *)name;
@end

