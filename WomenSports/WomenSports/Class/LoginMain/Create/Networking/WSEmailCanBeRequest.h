//
//  WSEmailCanBeRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/20.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSEmailCanBeRequest : BaseRequest
CopyStringProperty email;
CopyStringProperty deviceType;
CopyStringProperty packageName;
@end

@interface WSEmailCanBeModel : NSObject
AssignProperty BOOL content;
@end

NS_ASSUME_NONNULL_END
