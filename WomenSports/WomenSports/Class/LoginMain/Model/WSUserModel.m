//
//  WSUserModel.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/20.
//

#import "WSUserModel.h"

@implementation WSUserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"userGold":@"newUserGold",
             @"uid":@"id",
    };
}
- (NSString *)headerUrl {
    if (self.changeHeaderUrl.length > 0) {
        return _changeHeaderUrl;
    } else {
        return _header;
    }
}
- (NSString *)name {
    if (self.changeName.length > 0) {
        return _changeName;
    } else {
        return _nickname;
    }
}
@end
