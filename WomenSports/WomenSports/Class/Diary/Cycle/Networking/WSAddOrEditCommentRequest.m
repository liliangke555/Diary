//
//  WSAddOrEditCommentRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "WSAddOrEditCommentRequest.h"

@implementation WSAddOrEditCommentRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/addOrEdit%@TreeData",@"diary",@"cycle"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSAddOrEditCommentModel class];
}
@end
@implementation WSAddOrEditCommentModel

@end
