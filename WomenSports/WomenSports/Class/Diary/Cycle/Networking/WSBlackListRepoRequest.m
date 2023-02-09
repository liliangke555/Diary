//
//  WSBlackListRepoRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "WSBlackListRepoRequest.h"

@implementation WSBlackListRepoRequest
- (NSString *)uri {
    return @"blacklists/report";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSBlackListRepoModel class];
}
@end

@implementation WSBlackListRepoModel

@end
