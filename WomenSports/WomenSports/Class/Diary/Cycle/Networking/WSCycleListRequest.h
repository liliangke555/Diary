//
//  WSCycleListRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSCycleListRequest : BaseRequest
CopyStringProperty deviceType;
CopyStringProperty packageName;
CopyStringProperty userId;
AssignProperty NSInteger size;
AssignProperty NSInteger page;

StrongProperty NSArray *sort;
CopyStringProperty data20;// 1:日记 2:圈子
CopyStringProperty data8;
CopyStringProperty data10;
@end

@interface WSCycleDetailChildModel : NSObject
CopyStringProperty id;
CopyStringProperty pid;
CopyStringProperty packageName;
CopyStringProperty deviceType;
//AssignProperty NSInteger ignoreEditNullParam;

CopyStringProperty data1;//!< 头像
CopyStringProperty data2;//!< 名字
CopyStringProperty data3;//!< 内容
AssignProperty NSInteger data4;//!< 点赞数
//! 时间错
CopyStringProperty createTime;
CopyStringProperty createTimeString;

StrongProperty NSArray *listActionType;
@end

@interface WSCycleDetailModel : NSObject
CopyStringProperty userId;
CopyStringProperty pid;
CopyStringProperty packageName;
CopyStringProperty level;
CopyStringProperty id;

CopyStringProperty deviceType;
CopyStringProperty data9; //用户头像
CopyStringProperty data10; //用户名字
CopyStringProperty data8;
CopyStringProperty data7;
CopyStringProperty data6;
CopyStringProperty data5;

CopyStringProperty data4;
CopyStringProperty data3;
CopyStringProperty data2;
CopyStringProperty data1;

CopyStringProperty createTime;
CopyStringProperty createTimeString;
CopyStringProperty code;
CopyStringProperty data20;// 1:日记 2:圈子

AssignProperty NSInteger data11; //点赞数量
AssignProperty NSInteger data12; //评论数量
AssignProperty NSInteger data13; //礼物数量

StrongProperty NSArray *listActionType;

StrongProperty NSArray <WSCycleDetailChildModel *>*child;
@end

@interface WSCycleListModel : NSObject
AssignProperty NSInteger currentPage;
StrongProperty NSArray <WSCycleDetailModel *>*data;
AssignProperty NSInteger pageSize;
AssignProperty NSInteger totalPages;
@end

NS_ASSUME_NONNULL_END
