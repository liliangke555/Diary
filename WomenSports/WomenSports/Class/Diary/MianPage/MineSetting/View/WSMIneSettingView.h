//
//  WSMIneSettingView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/10.
//

#import "MMPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSMIneSettingView : MMPopupView
@property (nonatomic, copy) void(^didClickPerson)(void);
@property (nonatomic, copy) void(^didClickContent)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
