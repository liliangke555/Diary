//
//  WSCycleAddOrEditRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "WSCycleAddOrEditRequest.h"

@implementation WSCycleAddOrEditRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/addOrEdit%@TreeData",@"diary",@"cycle"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSCycleAddOrEditModel class];
}
@end

@implementation WSCycleAddOrEditModel

@end
