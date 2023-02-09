//
//  WSGetGiftStatisticRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSGetGiftStatisticRequest.h"

@implementation WSGetGiftStatisticRequest
- (NSString *)uri {
    return @"gift/getGiftStatistic";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSGetGiftStatisticModel class];
}
@end

@implementation WSGetGiftStatisticModel

@end
