//
//  WSFollowManTableCell.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/4.
//

#import <UIKit/UIKit.h>
#import "WSFollowingListRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSFollowManTableCell : UITableViewCell
@property (nonatomic, assign) BOOL follower;
@property (nonatomic, strong) WSFollowDetailModel *model;
@property (nonatomic, copy) void(^didClickUnfollow)(WSFollowDetailModel *detailModel);
@end

NS_ASSUME_NONNULL_END
