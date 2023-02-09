//
//  WSDeleteCycleRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "WSDeleteCycleRequest.h"

@implementation WSDeleteCycleRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/delete%@TreeData/%@",@"diary",@"cycle",self.id];
}

- (NSString *)requestMethod {
    return @"DELETE";
}

- (Class)responseDataClass {
    return [WSDeleteCycleModel class];
}
@end

@implementation WSDeleteCycleModel

@end
