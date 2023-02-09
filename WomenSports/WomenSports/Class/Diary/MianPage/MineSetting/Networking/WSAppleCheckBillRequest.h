//
//  WSAppleCheckBillRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSAppleCheckBillRequest : BaseRequest
CopyStringProperty billNo;
CopyStringProperty pkgName;
@end

@interface WSAppleCheckBillModel : NSObject

@end

NS_ASSUME_NONNULL_END
