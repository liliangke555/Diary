//
//  WSGetAppKeyRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSGetAppKeyRequest : BaseRequest
CopyStringProperty version;
CopyStringProperty type;
CopyStringProperty pkgName;
CopyStringProperty encryptParam;
@end

@interface WSGetAppKeyModel : NSObject
CopyStringProperty ad3ux826;
CopyStringProperty curTimeStamp;
CopyStringProperty customJson;
CopyStringProperty fileDomain;
CopyStringProperty hfiveUrl;

CopyStringProperty hfiveVersion;
CopyStringProperty key;
CopyStringProperty rechargeLotteryStatus;
CopyStringProperty svr8y778;
CopyStringProperty token;

CopyStringProperty emKey;
CopyStringProperty agKey;
@end

NS_ASSUME_NONNULL_END
