//
//  WSPersonPostTableCell.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import <UIKit/UIKit.h>
#import "WSCycleListRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSPersonPostTableCell : UITableViewCell
@property (nonatomic, strong) WSCycleDetailModel *model;
@property (nonatomic, copy) void(^didClickMore)(WSCycleDetailModel *detailModel);
@end

NS_ASSUME_NONNULL_END
