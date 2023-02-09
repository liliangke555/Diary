//
//  WSRechageListConfigRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSRechageListConfigRequest.h"

@implementation WSRechageListConfigRequest
- (NSString *)uri {
    return @"recharge/listConfig";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSRechageListConfigModel class];
}
@end

@implementation WSRechageListConfigModel

@end
