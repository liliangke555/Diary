//
//  WSDiaryFindRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/29.
//

#import "WSDiaryFindRequest.h"

@implementation WSDiaryFindRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/findPage%@TreeData",@"diary",@"diary"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSDiaryFindModel class];
}
@end

@implementation WSDiaryDetailModel

@end

@implementation WSDiaryFindModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"data" : [WSDiaryDetailModel class]};
}
@end
