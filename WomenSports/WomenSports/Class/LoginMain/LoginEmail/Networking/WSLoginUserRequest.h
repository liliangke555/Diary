//
//  WSLoginUserRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/28.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSLoginUserRequest : BaseRequest
CopyStringProperty appId;
CopyStringProperty allAppId;
CopyStringProperty deviceType;
CopyStringProperty packageName;
CopyStringProperty version;
CopyStringProperty email;
CopyStringProperty password;
@end

NS_ASSUME_NONNULL_END
