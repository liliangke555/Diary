//
//  WSDiaryDetailRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "WSDiaryDetailRequest.h"

@implementation WSDiaryDetailRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/get%@TreeDataById",@"diary",@"diary"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSDiaryDetailModel class];
}
@end
