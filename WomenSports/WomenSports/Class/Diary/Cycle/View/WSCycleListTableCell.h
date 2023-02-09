//
//  WSCycleListTableCell.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/17.
//

#import <UIKit/UIKit.h>
#import "WSCycleListRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSCycleListTableCell : UITableViewCell
@property (nonatomic, strong) WSCycleDetailModel *model;
@property (nonatomic, copy) void(^didClickGift)(WSCycleDetailModel *detailModel);
@property (nonatomic, copy) void(^didClickMore)(WSCycleDetailModel *detailModel);
@property (nonatomic, copy) void(^didClickLike)(WSCycleDetailModel *detailModel,BOOL liked);
@end

NS_ASSUME_NONNULL_END
