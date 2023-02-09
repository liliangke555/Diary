//
//  WSEmailCanBeRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/20.
//

#import "WSEmailCanBeRequest.h"

@implementation WSEmailCanBeRequest
- (NSString *)uri {
    return @"users/checkEmailCanBeRegisted";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSEmailCanBeModel class];
}
@end

@implementation WSEmailCanBeModel

@end
