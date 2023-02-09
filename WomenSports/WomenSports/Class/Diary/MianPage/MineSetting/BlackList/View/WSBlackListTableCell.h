//
//  WSBlackListTableCell.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import <UIKit/UIKit.h>
#import "WSGetBlackListRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSBlackListTableCell : UITableViewCell
@property (nonatomic, strong) WSGetBlackModel *model;
@property (nonatomic, copy) void(^didClickRemove)(WSGetBlackModel *model);
@end

NS_ASSUME_NONNULL_END
