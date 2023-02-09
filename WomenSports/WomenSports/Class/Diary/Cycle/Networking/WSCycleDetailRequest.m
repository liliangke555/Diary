//
//  WSCycleDetailRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "WSCycleDetailRequest.h"

@implementation WSCycleDetailRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/get%@TreeDataById",@"diary",@"cycle"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSCycleDetailModel class];
}
@end
