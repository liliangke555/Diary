//
//  WSRTCTokenRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/3.
//

#import "WSRTCTokenRequest.h"

@implementation WSRTCTokenRequest
- (NSString *)uri {
    return @"token/rtc";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSRTCTokenModel class];
}
@end

@implementation WSRTCTokenModel

@end
