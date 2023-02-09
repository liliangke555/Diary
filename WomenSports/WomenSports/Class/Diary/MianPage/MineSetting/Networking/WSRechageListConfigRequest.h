//
//  WSRechageListConfigRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSRechageListConfigRequest : BaseRequest
CopyStringProperty type;
CopyStringProperty first;
CopyStringProperty pkgName;
CopyStringProperty rechargeType;
@end

@interface WSRechageListConfigModel : NSObject
CopyStringProperty activity;
CopyStringProperty code;
CopyStringProperty description;
CopyStringProperty gold;
CopyStringProperty highlight;

CopyStringProperty id;
CopyStringProperty price;
CopyStringProperty rechargeType;
CopyStringProperty serialNum;
CopyStringProperty subscribGoldPerDay;

CopyStringProperty type;
@end

NS_ASSUME_NONNULL_END
