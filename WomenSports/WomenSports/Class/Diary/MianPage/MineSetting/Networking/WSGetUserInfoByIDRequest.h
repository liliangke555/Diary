//
//  WSGetUserInfoByIDRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "BaseRequest.h"
#import "WSAddOrEditUserInfoRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSGetUserInfoByIDRequest : BaseRequest
CopyStringProperty userId;
@end

NS_ASSUME_NONNULL_END
