//
//  WSPersonPageView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import <UIKit/UIKit.h>
#import "WSGetUserInfoByIDRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSPersonPageView : UIView
+ (instancetype)persenPageView;
@property (nonatomic, strong) WSUserInfoModel *userModel;
@property (nonatomic, assign, getter=isFollow) BOOL followUser;
@property (nonatomic, copy) void(^didClickFollow)(BOOL isFollowing);
@property (nonatomic, copy) void(^didClickMessage)(WSUserInfoModel *model);
@end

NS_ASSUME_NONNULL_END
