//
//  WSCancelLikeRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "WSCancelLikeRequest.h"

@implementation WSCancelLikeRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/unAction%@TreeData",@"diary",@"cycle"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSCancelLikeModel class];
}
@end

@implementation WSCancelLikeModel

@end
