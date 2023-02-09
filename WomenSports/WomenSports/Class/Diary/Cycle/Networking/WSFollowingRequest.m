//
//  WSFollowingRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "WSFollowingRequest.h"

@implementation WSFollowingRequest
- (NSString *)uri {
    return @"followers/following";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSFollowingModel class];
}
@end

@implementation WSFollowingModel

@end
