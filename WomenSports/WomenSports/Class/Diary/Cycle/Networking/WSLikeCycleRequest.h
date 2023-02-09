//
//  WSLikeCycleRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/30.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSLikeCycleRequest : BaseRequest
CopyStringProperty auditTreeDataId;
CopyStringProperty type; // 1: 一点赞 2:
@end

@interface WSLikeCycleModel : NSObject

@end

NS_ASSUME_NONNULL_END
