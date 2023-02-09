//
//  WSCalendarView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/14.
//

#import "WSCalendarView.h"
#import "LXCalendarView.h"

@implementation WSCalendarView

- (instancetype)initYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    self = [super init];
    if (self) {
        self.type = MMPopupTypeCustom;
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        self.backgroundColor = K_WhiteColor;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CK_WIDTH);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
//        MASViewAttribute *lastAttribute = self.mas_top;
        
        LXCalendarView *view = [LXCalendarView.alloc init];
        view.currentMonthTitleColor = [UIColor k_colorWithHex:0x222222FF];
        view.year = year;
        view.month = month;
        view.day = day;
        view.isHaveAnimation = YES;
        view.isCanScroll = YES;
        view.isShowLastAndNextBtn = YES;
        view.todayTitleColor = K_TextOrangeColor;
        view.selectBackColor = K_BlackColor;
        view.isShowLastAndNextDate = YES;
        
        [view dealData];
        
        view.backgroundColor =[UIColor whiteColor];
        [self addSubview:view];
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        
        CKWeakify(self);
        view.selectBlock = ^(NSInteger year, NSInteger month, NSInteger day) {
            NSLog(@"%ld年 - %02ld月 - %02ld日",year,month,day);
            if (weakSelf.selectedDate) {
                weakSelf.selectedDate(year, month, day);
            }
            [weakSelf hide];
        };
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.mas_bottom);
        }];
    }
    return self;
}


- (MMPopupBlock)customShowAnimation {
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        if ( !self.superview )
        {
            [self.attachedView.mm_dimBackgroundView addSubview:self];
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.attachedView);
                make.top.equalTo(self.attachedView.mas_top).mas_offset(-self.attachedView.frame.size.width);
            }];
            [self.superview layoutIfNeeded];
        }
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:1.5
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(self.attachedView.mas_top).mas_offset(0);
                             }];
                             
                             [self.superview layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)customHideAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(self.attachedView.mas_top).mas_offset(-self.attachedView.frame.size.width);
                             }];
                             
                             [self.superview layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             if ( finished )
                             {
                                 [self removeFromSuperview];
                             }
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self, finished);
                             }
                         }];
    };
    
    return block;
}
@end
