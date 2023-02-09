//
//  WSCalendarView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/14.
//

#import "MMPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSCalendarView : MMPopupView
//@property (nonatomic, assign) NSInteger year; //!< 所属年份
//@property (nonatomic, assign) NSInteger month; //!< 当前月份
//@property (nonatomic, assign) NSInteger day;   //每天所在的位置
@property (nonatomic, copy) void(^selectedDate)(NSInteger year,NSInteger month,NSInteger day);

- (instancetype)initYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end

NS_ASSUME_NONNULL_END
