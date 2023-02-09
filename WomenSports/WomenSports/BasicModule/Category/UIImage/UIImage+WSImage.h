//
//  UIImage+WSImage.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WSImage)
+ (UIImage *)k_imageWithColor:(UIColor *)color;

/**
 *  修改图片size
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage *)image byScalingToSize:(CGSize)targetSize;

+ (UIImage *)getSubImage:(UIImage *)originImage Rect:(CGRect)rect imageOrientation:(UIImageOrientation)imageOrientation;

+ (UIImage *)scaleImage:(UIImage *)Image toScale:(float)scaleSize;
@end

NS_ASSUME_NONNULL_END
