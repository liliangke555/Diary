//
//  WSRegistUserRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/28.
//

#import "WSRegistUserRequest.h"

@implementation WSRegistUserRequest
- (NSString *)uri {
    return @"users/registUserByEmail";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSUserModel class];
}
@end

@implementation WSRegistUserModel

@end
