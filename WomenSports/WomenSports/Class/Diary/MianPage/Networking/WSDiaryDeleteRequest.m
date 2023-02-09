//
//  WSDiaryDeleteRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/29.
//

#import "WSDiaryDeleteRequest.h"

@implementation WSDiaryDeleteRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/delete%@TreeData/%@",@"diary",@"diary",self.id];
}

- (NSString *)requestMethod {
    return @"DELETE";
}

- (Class)responseDataClass {
    return [WSDiaryDeleteModel class];
}
@end

@implementation WSDiaryDeleteModel

@end
