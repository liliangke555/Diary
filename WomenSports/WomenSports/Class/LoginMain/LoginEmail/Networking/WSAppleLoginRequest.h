//
//  WSAppleLoginRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSAppleLoginRequest : BaseRequest
CopyStringProperty appId;
CopyStringProperty allAppId;
CopyStringProperty deviceType;
CopyStringProperty packageName;
CopyStringProperty version;
CopyStringProperty thirdId;
CopyStringProperty appleCode;
CopyStringProperty nickname;
@end

NS_ASSUME_NONNULL_END
