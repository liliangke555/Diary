//
//  WSFollowerListRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "WSFollowerListRequest.h"

@implementation WSFollowerListRequest
- (NSString *)uri {
    return @"followers/listFollower";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSFollowingListModel class];
}
@end
