//
//  WSDeleteUsersRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSDeleteUsersRequest.h"

@implementation WSDeleteUsersRequest
- (NSString *)uri {
    return @"users/delete";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSDeleteUsersModel class];
}
@end

@implementation WSDeleteUsersModel

@end
