//
//  WSCommunityTableCell.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSCommunityTableCell : UITableViewCell
@property (nonatomic, assign) BOOL videoDetail;
@property (nonatomic, copy) void(^didClickMore)(void);
@property (nonatomic, assign, getter=isNoMore) BOOL noMore;
@end

NS_ASSUME_NONNULL_END
