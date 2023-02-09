//
//  WSFollowerListRequest.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import "BaseRequest.h"
#import "WSFollowingListRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSFollowerListRequest : BaseRequest
AssignProperty NSInteger page;
AssignProperty NSInteger size;
StrongProperty NSArray *sort;
@end

NS_ASSUME_NONNULL_END
