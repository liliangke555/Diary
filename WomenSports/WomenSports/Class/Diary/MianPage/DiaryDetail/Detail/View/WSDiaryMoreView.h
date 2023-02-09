//
//  WSDiaryMoreView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/17.
//

#import "MMPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSDiaryMoreView : MMPopupView
@property (nonatomic, copy) void(^didClickItem)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
