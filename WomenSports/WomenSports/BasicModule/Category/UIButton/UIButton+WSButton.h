//
//  UIButton+WSButton.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (WSButton)
+ (instancetype) k_buttonWithTarget:(id)target action:(SEL)sel;
+ (instancetype)k_mainButtonWithTarget:(id)target action:(SEL)sel;
+ (instancetype)k_whiteButtonWithTarget:(id)target action:(SEL)sel;
+ (instancetype)k_blackButtonWithTarget:(id)target action:(SEL)sel;
@end

NS_ASSUME_NONNULL_END
