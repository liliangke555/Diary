//
//  WSFollowingRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSFollowingListRequest : BaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger size;
StrongProperty NSArray *sort;
@end

@interface WSFollowDetailModel : NSObject
CopyStringProperty anchorRate;
CopyStringProperty brokerRate;
CopyStringProperty brokerType;
CopyStringProperty chatStatus;
CopyStringProperty easemobStatus;

CopyStringProperty email;
CopyStringProperty followTime;
CopyStringProperty following;
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

@interface WSFollowingListModel : NSObject
AssignProperty NSInteger currentPage;
StrongProperty NSArray <WSFollowDetailModel *>*data;
AssignProperty NSInteger pageSize;
AssignProperty NSInteger totalPages;
@end

NS_ASSUME_NONNULL_END
