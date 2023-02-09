//
//  WSAddOrEditCommentRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSAddOrEditCommentRequest : BaseRequest
CopyStringProperty id;
CopyStringProperty pid;
CopyStringProperty packageName;
CopyStringProperty deviceType;
AssignProperty NSInteger ignoreEditNullParam;

CopyStringProperty data1;//!< 头像
CopyStringProperty data2;//!< 名字
CopyStringProperty data3;//!< 内容
AssignProperty NSInteger data4;//!< 点赞数

@end

@interface WSAddOrEditCommentModel : NSObject

@end

NS_ASSUME_NONNULL_END
