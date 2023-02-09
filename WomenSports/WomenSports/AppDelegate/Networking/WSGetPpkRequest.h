//
//  WSGetPpkRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/20.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSGetPpkRequest : BaseRequest
CopyStringProperty version;
CopyStringProperty type;
CopyStringProperty pkgName;
@end

@interface WSGetPpkModel : NSObject
CopyStringProperty content;
CopyStringProperty content2;
AssignProperty NSInteger customNum;
@end

NS_ASSUME_NONNULL_END
