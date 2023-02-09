//
//  WSCycleAddOrEditRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSCycleAddOrEditRequest : BaseRequest
CopyStringProperty id;
//CopyStringProperty pid;
CopyStringProperty packageName;
CopyStringProperty deviceType;
AssignProperty NSInteger ignoreEditNullParam;

CopyStringProperty data1;//!<天气 weather
CopyStringProperty data2;//!< 心情 mood
CopyStringProperty data3;//!< 时间 diaryTime
CopyStringProperty data4;//!< title
CopyStringProperty data5; //!<detail
CopyStringProperty data6; //!<image

CopyStringProperty data7; //synchronize
CopyStringProperty data8; //anonymous
CopyStringProperty data9; //用户头像
CopyStringProperty data10; //用户名字
AssignProperty NSInteger data11; //点赞数量
AssignProperty NSInteger data12; //评论数量
AssignProperty NSInteger data13; //礼物数量
CopyStringProperty data20;// 1:日记 2:圈子
@end

@interface WSCycleAddOrEditModel : NSObject

@end

NS_ASSUME_NONNULL_END
