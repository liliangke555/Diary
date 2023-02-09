//
//  WSSendGiftRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "WSSendGiftRequest.h"

@implementation WSSendGiftRequest
- (NSString *)uri {
    return @"gift/deduction";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSSendGiftModel class];
}
@end

@implementation WSSendGiftModel

@end
