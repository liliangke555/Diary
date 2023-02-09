//
//  WSSheetView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/7.
//

#import "WSSheetView.h"

@interface WSSheetView ()
@property (nonatomic, strong) NSArray     *actionItems;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation WSSheetView

- (instancetype)initWithItem:(NSArray *)items
{
    self = [super init];
    if (self) {
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        self.type = MMPopupTypeSheet;
        self.actionItems = items;
        self.backgroundColor = K_WhiteColor;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CK_WIDTH);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        [self.layer setCornerRadius:12];
        [self setClipsToBounds:YES];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < items.count; ++i ) {
            MMPopupItem *item = items[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            [self addSubview:btn];
            btn.tag = i;
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                make.height.mas_equalTo(60);
                
                if ( !firstButton ) {
                    firstButton = btn;
                    make.top.equalTo(lastAttribute);
                } else {
                    make.top.equalTo(lastButton.mas_bottom);
                    make.height.equalTo(firstButton);
                }
                
                lastButton = btn;
            }];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:K_WhiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:K_TextGrayColor] forState:UIControlStateDisabled];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:K_TextOrangeSubColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight?K_TextRedColor:item.disabled?K_TextOrangeSubColor:K_BlackColor forState:UIControlStateNormal];
            btn.titleLabel.font = KSFProRoundedMediumFont(16);
            btn.enabled = !item.disabled;
        }
        
        UIView *lineView = [UIView.alloc init];
        [self addSubview:lineView ];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastButton.mas_bottom);
            make.left.right.equalTo(self).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(1);
        }];
        [lineView setBackgroundColor:K_SepLineColor];
        
        UIButton *cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(cancelButtonAction:)];
        [self addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom);
            make.left.right.equalTo(self).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(60);
        }];
        [cancelButton setBackgroundColor:K_WhiteColor];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:KSFProRoundedMediumFont(16)];
        [cancelButton setTitleColor:K_BlackColor forState:UIControlStateNormal];
        self.cancelButton = cancelButton;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cancelButton.mas_bottom).mas_offset(KBottomSafeHeight);
        }];
    }
    return self;
}
- (void)actionButton:(UIButton *)sender {
    MMPopupItem *item = self.actionItems[sender.tag];
    
    [self hide];
    
    if ( item.handler ) {
        item.handler(sender.tag);
    }
}
- (void)cancelButtonAction:(UIButton *)sender {
    [self hide];
}
- (void)setCancelColor:(UIColor *)cancelColor {
    _cancelColor = cancelColor;
    [self.cancelButton setTitleColor:cancelColor forState:UIControlStateNormal];
}
@end
