//
//  WSGetBlackListRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSGetBlackListRequest.h"

@implementation WSGetBlackListRequest
- (NSString *)uri {
    return @"blacklists/listBlacklist";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSGetBlackListModel class];
}
@end

@implementation WSGetBlackModel

@end

@implementation WSGetBlackListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"data" : [WSGetBlackModel class]};
}
@end
