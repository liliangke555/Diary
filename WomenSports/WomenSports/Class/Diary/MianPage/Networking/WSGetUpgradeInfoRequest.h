//
//  WSGetUpgradeInfoRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSGetUpgradeInfoRequest : BaseRequest
CopyStringProperty deviceType;
CopyStringProperty version;
CopyStringProperty packageName;
@end

@interface WSGetUpgradeInfoModel : NSObject
CopyStringProperty needUpgrade;
CopyStringProperty latestVersion;
CopyStringProperty isForceUpgrade;
CopyStringProperty upgradeUrl;
CopyStringProperty upgradeDescription;
@end

NS_ASSUME_NONNULL_END
