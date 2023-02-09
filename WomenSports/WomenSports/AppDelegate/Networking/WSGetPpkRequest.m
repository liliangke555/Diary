//
//  WSGetPpkRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/20.
//

#import "WSGetPpkRequest.h"

@implementation WSGetPpkRequest
- (NSString *)uri {
    return @"config/getPpk";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSGetPpkModel class];
}
@end

@implementation WSGetPpkModel

@end
