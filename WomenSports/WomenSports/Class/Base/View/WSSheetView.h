//
//  WSSheetView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/7.
//

#import "MMPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSSheetView : MMPopupView
@property (nonatomic, strong) UIColor *cancelColor;
- (instancetype)initWithItem:(NSArray *)items;
@end

NS_ASSUME_NONNULL_END
