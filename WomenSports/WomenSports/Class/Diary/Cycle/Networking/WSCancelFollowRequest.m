//
//  WSCancelFollowRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "WSCancelFollowRequest.h"

@implementation WSCancelFollowRequest
- (NSString *)uri {
    return @"followers/cancelFollowing";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSCancelFollowModel class];
}
@end

@implementation WSCancelFollowModel

@end
