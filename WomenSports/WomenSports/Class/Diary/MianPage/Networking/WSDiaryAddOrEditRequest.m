//
//  WSDiaryAddOrEditRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/29.
//

#import "WSDiaryAddOrEditRequest.h"

@implementation WSDiaryAddOrEditRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/addOrEdit%@TreeData",@"diary",@"diary"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSDiaryAddOrEditModel class];
}
@end

@implementation WSDiaryAddOrEditModel

@end
