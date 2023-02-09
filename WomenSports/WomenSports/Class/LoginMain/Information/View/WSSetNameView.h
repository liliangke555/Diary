//
//  WSSetNameView.h
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSSetNameView : UIView<UITextFieldDelegate>
@property (nonatomic, copy) void(^didClickHeader)(void);
@property (nonatomic, copy) void(^didEndEdit)(NSString *string);
@property (nonatomic, strong) UIButton *headerButton;
@property (nonatomic, strong) UITextField *textView;
@end

NS_ASSUME_NONNULL_END
