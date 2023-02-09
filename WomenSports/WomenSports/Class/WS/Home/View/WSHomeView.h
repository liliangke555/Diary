//
//  WSHomeView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSHomeView : UIView
@property (nonatomic, copy) void(^didSelectedYoga)(void);
@property (nonatomic, copy) void(^didSelectedMeditate)(void);
@property (nonatomic, copy) void(^didSelectedRealx)(void);
@property (nonatomic, copy) void(^didSelectedShap)(void);
@property (nonatomic, copy) void(^didSelectedTarget)(void);
@end

NS_ASSUME_NONNULL_END
