//
//  WSCheckFollowRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSCheckFollowRequest : BaseRequest
CopyStringProperty userId;
@end

@interface WSCheckFollowModel : NSObject

@end

NS_ASSUME_NONNULL_END
