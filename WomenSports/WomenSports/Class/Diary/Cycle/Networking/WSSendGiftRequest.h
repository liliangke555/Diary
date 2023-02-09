//
//  WSSendGiftRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSSendGiftRequest : BaseRequest
CopyStringProperty giftId;
CopyStringProperty userId;
@end

@interface WSSendGiftModel : NSObject
CopyStringProperty userId;
CopyStringProperty amount;
CopyStringProperty enough;
@end

NS_ASSUME_NONNULL_END
