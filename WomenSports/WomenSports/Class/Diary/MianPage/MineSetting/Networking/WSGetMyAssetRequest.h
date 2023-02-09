//
//  WSGetMyAssetRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSGetMyAssetRequest : BaseRequest

@end

@interface WSGetMyAssetModel : NSObject
CopyStringProperty amount;
CopyStringProperty commissionAmount;
CopyStringProperty freeNumber;
CopyStringProperty subscribStatus;
CopyStringProperty userId;
@end

NS_ASSUME_NONNULL_END
