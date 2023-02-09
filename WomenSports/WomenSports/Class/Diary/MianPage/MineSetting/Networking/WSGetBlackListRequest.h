//
//  WSGetBlackListRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/1.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSGetBlackListRequest : BaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger size;
@end

@interface WSGetBlackModel : NSObject
CopyStringProperty anchorRate;
CopyStringProperty brokerRate;
CopyStringProperty brokerType;
CopyStringProperty chatStatus;
CopyStringProperty easemobStatus;

CopyStringProperty email;
CopyStringProperty gender;
CopyStringProperty header;
CopyStringProperty id;
CopyStringProperty nickname;

CopyStringProperty profileStatus;
CopyStringProperty reviewScore;
CopyStringProperty subscribStatus;
CopyStringProperty talkingGoldPerMin;
CopyStringProperty userType;
@end

@interface WSGetBlackListModel : NSObject
AssignProperty NSInteger currentPage;
StrongProperty NSArray <WSGetBlackModel *>*data;
AssignProperty NSInteger pageSize;
AssignProperty NSInteger totalPages;
@end

NS_ASSUME_NONNULL_END
