//
//  WSDataTargetView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSDataTargetView : UIView
@property (nonatomic, copy) void(^didClickRecord)(void);
@property (nonatomic, copy) void(^didClickRightButton)(void);
+ (instancetype)dataTargetView;
@end

NS_ASSUME_NONNULL_END
