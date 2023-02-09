//
//  WSBaseController.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSBaseController : UIViewController
- (void)animation;
/// 图片 视频预览
/// @param index 当前图片index
/// @param data 图片数组
/// @param view 展示的View
- (void)showBrowerWithIndex:(NSInteger)index data:(NSArray *)data view:(id)view;
@end

NS_ASSUME_NONNULL_END
