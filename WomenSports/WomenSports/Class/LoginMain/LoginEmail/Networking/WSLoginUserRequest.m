//
//  WSLoginUserRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/28.
//

#import "WSLoginUserRequest.h"

@implementation WSLoginUserRequest
- (NSString *)uri {
    return @"users/loginUserByEmail";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSUserModel class];
}
@end
