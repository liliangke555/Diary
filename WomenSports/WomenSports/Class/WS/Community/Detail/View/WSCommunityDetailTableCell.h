//
//  WSCommunityDetailTableCell.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSCommunityDetailTableCell : UITableViewCell
@property (nonatomic, copy) void(^didClickMore)(void);
@end

NS_ASSUME_NONNULL_END
