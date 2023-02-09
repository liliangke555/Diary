//
//  WSMainPageView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSMainPageView : UIView
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dayLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, copy) void(^didClickRecord)(void);
@property (nonatomic, copy) void(^didClickDetail)(void);
@end

NS_ASSUME_NONNULL_END
