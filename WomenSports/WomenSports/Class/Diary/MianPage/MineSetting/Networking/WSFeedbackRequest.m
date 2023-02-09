//
//  WSFeedbackRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "WSFeedbackRequest.h"

@implementation WSFeedbackRequest
- (NSString *)uri {
    return @"users/feedback";
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSFeedbackModel class];
}
@end

@implementation WSFeedbackModel

@end
