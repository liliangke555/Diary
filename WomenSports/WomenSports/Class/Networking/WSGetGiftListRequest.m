//
//  WSGetGiftListRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "WSGetGiftListRequest.h"

@implementation WSGetGiftListRequest
- (NSString *)uri {
    return @"gift";
}

- (NSString *)requestMethod {
    return @"GET";
}

- (Class)responseDataClass {
    return [WSGetGiftListModel class];
}
@end

@implementation WSGiftModel

@end

@implementation WSGetGiftListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"data" : [WSGiftModel class]};
}
@end
