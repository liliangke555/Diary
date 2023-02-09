//
//  WSAddOrEditUserInfoRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSAddOrEditUserInfoRequest : BaseRequest
CopyStringProperty id;
CopyStringProperty packageName;
CopyStringProperty deviceType;
CopyStringProperty data1;//头像
CopyStringProperty data2;//名字
CopyStringProperty data3;//匿名头像
CopyStringProperty data4;//匿名名字
@end

@interface WSUserInfoModel : NSObject
CopyStringProperty id;
CopyStringProperty packageName;
CopyStringProperty deviceType;
CopyStringProperty userId;
CopyStringProperty data1;//头像
CopyStringProperty data2;//名字
CopyStringProperty data3;//匿名头像
CopyStringProperty data4;//匿名名字
CopyStringProperty createTime;
@end

NS_ASSUME_NONNULL_END
