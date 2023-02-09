//
//  WSSingleCache.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/20.
//

#import "WSSingleCache.h"
NSString * const WSTokenKey = @"WSTokenKey";
NSString *const WSSingleKeyStringCurrentUser = @"WSSingleKeyStringCurrentUser";
@implementation WSSingleCache
@synthesize userModel = _userModel;
@synthesize token = _token;

//创建单例对象
+ (instancetype)shareSingleCache {
    
    static WSSingleCache *singleCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleCache = [[WSSingleCache alloc] init];
    });
    return singleCache;
}
+ (void)clean {
    kUser = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults dictionaryRepresentation];
    for (id key in dict) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

- (WSUserModel *)userModel {
    if (!_userModel) {
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] valueForKey:WSSingleKeyStringCurrentUser];
        if (userDic) {
            _userModel = [[WSUserModel alloc] mj_setKeyValues:userDic];
        }
    }
    return _userModel;
}

- (void)setUserModel:(WSUserModel *)userModel {
    if (!userModel) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:WSSingleKeyStringCurrentUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (_userModel != userModel) {
        _userModel = userModel;
        NSMutableDictionary *dic = [_userModel mj_keyValues];
        [[NSUserDefaults standardUserDefaults] setValue:dic forKey:WSSingleKeyStringCurrentUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)token {
    _token = [[NSUserDefaults standardUserDefaults] objectForKey:WSTokenKey];
    return _token;
}
- (void)setToken:(NSString *)token {
    _token = token;
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:WSTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)checkLoginState {
    if (self.token.length <= 0) {
        return NO;
    }
    return YES;
}
@end
