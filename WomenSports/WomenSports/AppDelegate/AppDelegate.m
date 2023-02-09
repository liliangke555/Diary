//
//  AppDelegate.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "AppDelegate.h"
#import "AppDelegate+WSAppDelegate.h"
#import <EaseCallUIKit.h>
#import "WSRTCTokenRequest.h"

@interface AppDelegate ()<EaseCallDelegate>

@property (nonatomic, copy) NSString *sendVideoUid;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //1.获取网络权限 根据权限进行人机交互
    [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [UIWindow.alloc initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyWindow];
    if (kUser.token.length > 0) {
        [self setTabbarView];
        [self initEaIMKit];
        
        [self loginIMWithUsername:kUser.uid password:kUser.uid];
        
        
    } else {
        [self setLoginView];
    }
    return YES;
}
- (void)initEaIMKit {
    NSString *emKey = [[NSUserDefaults standardUserDefaults] objectForKey:WSEmKey];
    if (emKey) {
        // appkey 替换成你在环信即时通讯 IM 管理后台注册应用中的 App Key
        EMOptions *options = [EMOptions optionsWithAppkey:emKey];
//        [options setIsAutoLogin:YES];
        options.apnsCertName = nil;
        [[EMClient sharedClient] initializeSDKWithOptions:options];
    } else {
        [MBProgressHUD showMessage:@"Error getting information"];
    }
}
/**
 实时检查当前网络状态
 */
- (void)addReachabilityManager:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                break;
            }
            default:
                break;
        }
    }];
      
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
}
//把以前写在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions里面的一些初始化操作放在该方法
- (void)getInfo_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //发送通知给APP首屏页面，让其有网络时重新请求
    [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)initEaseCallKit {
    NSString *agKey = [[NSUserDefaults standardUserDefaults] objectForKey:WSAgKey];
    if (agKey) {
        EaseCallConfig* config = [[EaseCallConfig alloc] init];
        EaseCallUser* usr = [[EaseCallUser alloc] init];
        usr.nickName = kUser.name;
        usr.headImage = [NSURL URLWithString:kUser.headerUrl?:@""];
        config.users = [NSMutableDictionary dictionaryWithDictionary:@{kUser.uid:usr}];
        config.enableRTCTokenValidate = YES;
        config.agoraAppId = agKey;
        [[EaseCallManager sharedManager] initWithConfig:config delegate:self];
    }
}
- (void)registEasIMWithName:(NSString *)name password:(NSString *)password {
    // 异步方法
    [self loginIMWithUsername:name password:password];
}
- (void)loginIMWithUsername:(NSString *)userName password:(NSString *)password {
    // 异步方法
    CKWeakify(self);
    [[EMClient sharedClient] loginWithUsername:userName
                                         password:password
                                       completion:^(NSString *aUsername, EMError *aError) {
        if (aError) {
            [weakSelf initEaseCallKit];
            //注册推送
            [self registerRemoteNotification];
        } else {
        }
    }];

}
- (void)setIMUrlWithurl:(NSString *)urlString name:(NSString *)name {
    EaseCallUser* user = [EaseCallUser userWithNickName:name image:[NSURL URLWithString:urlString]];
    [[[EaseCallManager sharedManager] getEaseCallConfig] setUser:kUser.uid info:user];
    [[[EMClient sharedClient] userInfoManager] updateOwnUserInfo:urlString withType:EMUserInfoTypeAvatarURL completion:^(EMUserInfo*aUserInfo,EMError *aError) {
        if(!aError) {
            [[UserInfoStore sharedInstance] setUserInfo:aUserInfo forId:[EMClient sharedClient].currentUsername];
        }else {
        }
    }];
    [[EMClient sharedClient].pushManager updatePushDisplayName:name completion:^(NSString * _Nonnull aDisplayName, EMError * _Nonnull aError) {
        if (!aError) {
        } else {
        }
    }];
    [[[EMClient sharedClient] userInfoManager] updateOwnUserInfo:name withType:EMUserInfoTypeNickName completion:^(EMUserInfo* aUserInfo,EMError *aError) {
        if(!aError) {
            [[UserInfoStore sharedInstance] setUserInfo:aUserInfo forId:[EMClient sharedClient].currentUsername];
        }else{
        }
    }];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}
// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [MBProgressHUD showMessage:error.description];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[EMClient sharedClient] application:application didReceiveRemoteNotification:userInfo];
}
//当应用收到环信推送透传消息时，此方法会被调用 注意这里是使用环信推送功能的透传消息
- (void)emDidRecivePushSilentMessage:(NSDictionary *)messageDic {
    NSLog(@"emDidRecivePushSilentMessage : %@",messageDic);
}
//注册远程通知
- (void)registerRemoteNotification {
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[EMLocalNotificationManager sharedManager] launchWithDelegate:self];
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
#endif
            }
        }];
        return;
    }
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}
#pragma mark - EaseCallDelegate
- (void)callDidReceive:(EaseCallType)aType inviter:(NSString*_Nonnull)user ext:(NSDictionary*)aExt {
    self.sendVideoUid = user;
    EaseCallUser* user2 = [[EaseCallUser alloc] init];
    user2.nickName = aExt[@"SendName"];
    user2.headImage = [NSURL URLWithString:aExt[@"SendUrl"]];
    [[[EaseCallManager sharedManager] getEaseCallConfig] setUser:user info:user2];
}
- (void)callDidJoinChannel:(NSString*_Nonnull)aChannelName uid:(NSUInteger)aUid {
    //此时，可以获取当前频道中已有用户的声网 ID 与环信 ID 的映射表，并将映射表设置到 `EaseCallKit`，同时也可以更新用户的头像和昵称。
}
-(void)remoteUserDidJoinChannel:( NSString*_Nonnull)aChannelName uid:(NSInteger)aUid username:(NSString*_Nullable)aUserName {
    // 此时，可以获取当前频道中已有用户的声网 RTC UID 与环信 ID 的映射表，并将映射表设置到 `EaseCallKit`，同时也可以更新用户的头像和昵称。
}
- (void)callDidRequestRTCTokenForAppId:(NSString *)aAppId channelName:(NSString *)aChannelName account:(NSString *)aUserAccount uid:(NSInteger)aAgoraUid {
    [self reloadTokenWithRoomid:aChannelName];
}
// 通话结束回调。
// aChannelName  通话使用的声网频道名称，用户可以根据频道名称，到声网 Console 的水晶球查询通话质量。
// aTm    通话时长，单位为秒。
// aCallType  通话类型。
- (void)callDidEnd:(NSString*)aChannelName reason:(EaseCallEndReason)aReason time:(int)aTm type:(EaseCallType)aCallType {
    NSString* msg = @"";
    switch (aReason) {
        case EaseCallEndReasonHandleOnOtherDevice:
            msg = @"Processed on another device.";//已在其他设备处理。
            break;
        case EaseCallEndReasonBusy:
            msg = @"busy.";//对方忙。
//            [self sendCallEndMessage:msg isSender:NO];
            break;
        case EaseCallEndReasonRefuse:
            msg = @"refused to answer.";//对方拒绝接听
//            [self sendCallEndMessage:msg isSender:NO];
            break;
        case EaseCallEndReasonCancel:
            msg = @"cancels the call.";//您已取消通话。
//            [self sendCallEndMessage:msg isSender:YES];
            break;
        case EaseCallEndReasonRemoteCancel:
            msg = @"cancels the call.";//对方取消通话。
//            [self sendCallEndMessage:msg isSender:NO];
            break;
        case EaseCallEndReasonRemoteNoResponse:
            msg = @"did not respond.";//对方无响应。
//            [self sendCallEndMessage:msg isSender:YES];
            break;
        case EaseCallEndReasonNoResponse:
            msg = @"not answer.";//您未接听。
//            [self sendCallEndMessage:msg isSender:NO];
            break;
        case EaseCallEndReasonHangup:
            msg = [NSString stringWithFormat:@"Call ended, call duration: %d seconds",aTm];//通话已结束，通话时长：5秒
            [self sendCallEndMessage:msg isSender:YES];
            break;
        default:
            break;
    }
    if([msg length] > 0)
       [MBProgressHUD showMessage:msg];
  }
- (void)callDidOccurError:(EaseCallError *)aError {
    if (aError) {
    } else {
    }
}
- (void)multiCallDidInvitingWithCurVC:(UIViewController * _Nonnull)vc excludeUsers:(NSArray<NSString *> * _Nullable)users ext:(NSDictionary * _Nullable)aExt {
}
- (void)reloadTokenWithRoomid:(NSString *)roomID {
    WSRTCTokenRequest *request = [WSRTCTokenRequest.alloc init];
    request.userId = kUser.uid;
    request.channelName = roomID;
    request.type = @"2";
    request.hideLoadingView = YES;
//    CKWeakify(self);
    [request asyncRequestWithsuccessHandler:^(BaseResponse * _Nonnull response) {
        WSRTCTokenModel *model = response.data;
        [[EaseCallManager sharedManager] setRTCToken:model.token channelName:model.channelName uid:[model.userId integerValue]];
    } failHandler:^(BaseResponse * _Nonnull response) {
    }];
}
- (void)sendCallEndMessage:(NSString *)string isSender:(BOOL)sender {
    // 创建一条文本消息，`content` 为消息文字内容，`toChatUsername` 为对方用户或者群聊的 ID，`fromChatUsername` 为发送方用户或群聊的 ID，`textMessageBody` 为消息体，`messageExt` 为消息扩展，后文皆是如此。
    EMTextMessageBody *textMessageBody = [[EMTextMessageBody alloc] initWithText:string];
    EMChatMessage *message = [[EMChatMessage alloc] initWithConversationID:self.inviteeUid
                                                                      from:kUser.uid
                                                                        to:self.inviteeUid
                                                                      body:textMessageBody ext:nil];
    // 构造消息时需设置 `EMChatMessage` 类的 `ChatType` 属性，可设置为 `EMChatTypeChat`、`EMChatTypeGroupChat` 和 `EMChatTypeChatRoom`，即单聊、群聊或聊天室消息，默认为单聊。
    message.chatType = EMChatTypeChat;
    // 发送消息，异步方法。
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WSSendMessage" object:message];
    CKWeakify(self);
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMChatMessage * _Nullable message, EMError * _Nullable error) {
        weakSelf.inviteeUid = nil;
        weakSelf.sendVideoUid = nil;
    }];
}
@end
