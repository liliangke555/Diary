//
//  WSGetUpgradeInfoRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "WSGetUpgradeInfoRequest.h"

@implementation WSGetUpgradeInfoRequest
- (NSString *)uri {
    return @"config/getUpgradeInfo";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSGetUpgradeInfoModel class];
}
@end

@implementation WSGetUpgradeInfoModel

@end
