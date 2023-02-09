//
//  WSFollowingRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "WSFollowingListRequest.h"

@implementation WSFollowingListRequest
- (NSString *)uri {
    return @"followers/listFollowing";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSFollowingListModel class];
}
@end

@implementation WSFollowDetailModel


@end

@implementation WSFollowingListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"data" : [WSFollowDetailModel class]};
}
@end
