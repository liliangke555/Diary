//
//  WSCycleHeaderView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSCycleHeaderView : UIView
@property (nonatomic, copy) void(^didClickSearch)(NSString *str);
@end

NS_ASSUME_NONNULL_END
