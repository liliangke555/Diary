//
//  WSCheckFollowRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "WSCheckFollowRequest.h"

@implementation WSCheckFollowRequest
- (NSString *)uri {
    return @"followers/checkAuthor";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSCheckFollowModel class];
}
@end

@implementation WSCheckFollowModel

@end
