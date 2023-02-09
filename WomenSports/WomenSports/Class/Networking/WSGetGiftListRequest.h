//
//  WSGetGiftListRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/31.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSGetGiftListRequest : BaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger size;
@end

@interface WSGiftModel : NSObject
CopyStringProperty id;
CopyStringProperty imgUrl;
CopyStringProperty name;
CopyStringProperty price;
@end

@interface WSGetGiftListModel : NSObject
AssignProperty NSInteger currentPage;
AssignProperty NSInteger totalPages;
StrongProperty NSArray <WSGiftModel *>*data;
@end

NS_ASSUME_NONNULL_END
