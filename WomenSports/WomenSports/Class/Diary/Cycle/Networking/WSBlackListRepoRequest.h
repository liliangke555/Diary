//
//  WSBlackListRepoRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSBlackListRepoRequest : BaseRequest
CopyStringProperty userId;
CopyStringProperty content;
@end

@interface WSBlackListRepoModel : NSObject

@end

NS_ASSUME_NONNULL_END
