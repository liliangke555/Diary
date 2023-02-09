//
//  WSDiaryFindRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/29.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSDiaryFindRequest : BaseRequest
CopyStringProperty deviceType;
CopyStringProperty packageName;
CopyStringProperty userId;
AssignProperty NSInteger size;
AssignProperty NSInteger page;

StrongProperty NSArray *sort;
CopyStringProperty data20;// 1:日记 2:圈子
@end

@interface WSDiaryDetailModel : NSObject
CopyStringProperty userId;
AssignProperty NSInteger pid;
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
CopyStringProperty code;
CopyStringProperty data20;// 1:日记 2:圈子
@end

@interface WSDiaryFindModel : NSObject
AssignProperty NSInteger currentPage;
StrongProperty NSArray <WSDiaryDetailModel *>*data;
AssignProperty NSInteger pageSize;
AssignProperty NSInteger totalPages;
@end

NS_ASSUME_NONNULL_END
