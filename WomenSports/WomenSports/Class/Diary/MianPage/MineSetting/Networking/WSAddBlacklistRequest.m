//
//  WSAddBlacklistRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSAddBlacklistRequest.h"

@implementation WSAddBlacklistRequest
- (NSString *)uri {
    return @"blacklists/addBlacklist";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSAddBlacklistModel class];
}
@end

@implementation WSAddBlacklistModel

@end
