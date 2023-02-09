//
//  WSGetUserInfoRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "WSGetUserInfoRequest.h"


@implementation WSGetUserInfoRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/getCurUser%@Ext",@"diary",@"diary"];
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSUserInfoModel class];
}
@end

