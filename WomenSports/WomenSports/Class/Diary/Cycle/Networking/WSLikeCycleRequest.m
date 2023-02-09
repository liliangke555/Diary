//
//  WSLikeCycleRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "WSLikeCycleRequest.h"

@implementation WSLikeCycleRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/action%@TreeData",@"diary",@"cycle"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSLikeCycleModel class];
}
@end

@implementation WSLikeCycleModel

@end
