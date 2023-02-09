//
//  UIColor+WSColor.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (WSColor)
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

// UIColor 转UIImage
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIColor *)k_colorWithHex:(NSUInteger)hex;

@end

NS_ASSUME_NONNULL_END
