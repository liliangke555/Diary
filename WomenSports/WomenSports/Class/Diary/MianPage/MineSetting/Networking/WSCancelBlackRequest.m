//
//  WSCancelBlackRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSCancelBlackRequest.h"

@implementation WSCancelBlackRequest
- (NSString *)uri {
    return @"blacklists/cancelBlacklist";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSCancelBlackModel class];
}
@end

@implementation WSCancelBlackModel

@end
