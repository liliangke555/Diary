//
//  WSAppleCheckBillRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "WSAppleCheckBillRequest.h"

@implementation WSAppleCheckBillRequest
- (NSString *)uri {
    return @"recharge/appleCheckBill";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSAppleCheckBillModel class];
}
@end

@implementation WSAppleCheckBillModel


@end
