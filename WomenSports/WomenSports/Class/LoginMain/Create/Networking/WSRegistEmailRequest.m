//
//  WSRegistEmailRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/20.
//

#import "WSRegistEmailRequest.h"

@implementation WSRegistEmailRequest
- (NSString *)uri {
    return @"users/registUserByEmail";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSRegistEmailModel class];
}
@end

@implementation WSRegistEmailModel

@end
