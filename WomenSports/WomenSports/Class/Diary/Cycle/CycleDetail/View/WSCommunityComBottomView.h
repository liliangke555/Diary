//
//  WSCommunityComBottomView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import <UIKit/UIKit.h>
#import "WSCycleListRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSCommunityComBottomView : UIView
+ (instancetype)CommunityVBottomView;
@property (nonatomic, copy) void(^didClickGift)(void);
@property (nonatomic, copy) void(^didClickLike)(BOOL isLike);
@property (nonatomic, copy) void(^didSendComment)(NSString *string);
@property (nonatomic, strong) WSCycleDetailModel *model;
@end

NS_ASSUME_NONNULL_END
