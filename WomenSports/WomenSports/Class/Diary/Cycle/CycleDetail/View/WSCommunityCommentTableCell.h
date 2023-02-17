//
//  WSCommunityCommentTableCell.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import <UIKit/UIKit.h>
#import "WSCycleListRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSCommunityCommentTableCell : UITableViewCell
@property (nonatomic, strong) WSCycleDetailChildModel *model;
@property (nonatomic, copy) void(^didClickLike)(WSCycleDetailChildModel *model, BOOL isLike);
@end

NS_ASSUME_NONNULL_END
