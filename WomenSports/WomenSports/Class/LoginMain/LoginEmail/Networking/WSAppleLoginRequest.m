//
//  WSAppleLoginRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "WSAppleLoginRequest.h"

@implementation WSAppleLoginRequest
- (NSString *)uri {
    return @"users/getUser";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSUserModel class];
}
@end
