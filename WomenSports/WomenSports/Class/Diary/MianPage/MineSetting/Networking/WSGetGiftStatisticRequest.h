//
//  WSGetGiftStatisticRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSGetGiftStatisticRequest : BaseRequest
CopyStringProperty userId;
@end

@interface WSGetGiftStatisticModel : NSObject
CopyStringProperty id;
CopyStringProperty imgUrl;
CopyStringProperty name;
CopyStringProperty num;
CopyStringProperty price;
@end

NS_ASSUME_NONNULL_END
