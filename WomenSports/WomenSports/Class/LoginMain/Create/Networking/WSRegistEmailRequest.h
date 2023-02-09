//
//  WSRegistEmailRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/20.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSRegistEmailRequest : BaseRequest
CopyStringProperty email;
@end

@interface WSRegistEmailModel : NSObject

@end

NS_ASSUME_NONNULL_END
