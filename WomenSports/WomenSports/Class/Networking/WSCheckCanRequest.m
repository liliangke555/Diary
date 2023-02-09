//
//  WSCheckCanRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/7.
//

#import "WSCheckCanRequest.h"

@implementation WSCheckCanRequest
- (NSString *)uri {
    return @"http://47.109.51.24/api/v1/rack";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [NSArray class];
}
@end
