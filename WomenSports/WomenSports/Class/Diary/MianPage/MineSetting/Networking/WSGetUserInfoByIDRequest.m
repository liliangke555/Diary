//
//  WSGetUserInfoByIDRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "WSGetUserInfoByIDRequest.h"


@implementation WSGetUserInfoByIDRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/get%@UserExtByUserId",@"diary",@"diary"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSUserInfoModel class];
}
@end
