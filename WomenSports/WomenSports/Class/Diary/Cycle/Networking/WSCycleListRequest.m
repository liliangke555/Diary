//
//  WSCycleListRequest.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "WSCycleListRequest.h"

@implementation WSCycleListRequest
- (NSString *)uri {
    return [NSString stringWithFormat:@"%@/findPage%@TreeData",@"diary",@"cycle"];
}

- (NSString *)requestMethod {
    return @"POST";
}

- (Class)responseDataClass {
    return [WSCycleListModel class];
}
@end

@implementation WSCycleDetailChildModel
- (void)setCreateTime:(NSString *)createTime {
    _createTime = createTime;
    NSTimeInterval timeInt = [createTime integerValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInt];
    NSDateFormatter *formatter = [NSDateFormatter.alloc init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *time = [formatter stringFromDate:date];
    _createTimeString = time;
}
@end

@implementation WSCycleDetailModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"child" : [WSCycleDetailChildModel class]};
}
- (void)setCreateTime:(NSString *)createTime {
    _createTime = createTime;
    NSTimeInterval timeInt = [createTime integerValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInt];
    NSDateFormatter *formatter = [NSDateFormatter.alloc init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *time = [formatter stringFromDate:date];
    _createTimeString = time;
}
@end

@implementation WSCycleListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"data" : [WSCycleDetailModel class]};
}

@end
