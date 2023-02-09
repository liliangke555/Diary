//
//  WSAddOrEditUserInfoRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "WSAddOrEditUserInfoRequest.h"

@implementation WSAddOrEditUserInfoRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/addOrEdit%@UserExt",@"diary",@"diary"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSUserInfoModel class];
}
@end

@implementation WSUserInfoModel

@end
