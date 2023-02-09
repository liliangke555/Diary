//
//  WSMoreTextAlterView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/12.
//

#import "WSMoreTextAlterView.h"

@interface WSMoreTextAlterView ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UITextView     *detailTextView;
@property (nonatomic, strong) UIView      *buttonView;
@property (nonatomic, strong) NSArray     *actionItems;
@end

@implementation WSMoreTextAlterView

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail
{
    self = [super init];
    if (self) {
        self.type = MMPopupTypeAlert;
        self.layer.cornerRadius = 12;
        self.clipsToBounds = YES;
        self.backgroundColor = K_WhiteColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CK_WIDTH- 30);
        }];
        
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        
        if ( title.length > 0 )
        {
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(22);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            self.titleLabel.textColor = K_BlackColor;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = KSFProRoundedBoldFont(18);
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.backgroundColor = self.backgroundColor;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleLabel.mas_bottom;
            
        }
        
        if ( detail.length > 0 )
        {
            self.detailTextView = [UITextView new];
            [self addSubview:self.detailTextView];
            [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(16);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
                make.height.mas_equalTo(370*CK_HEIGHT_Sales);
            }];
            self.detailTextView.textColor = K_TextBlackColor;
            self.detailTextView.font = KSFProRoundedMediumFont(16);
            self.detailTextView.backgroundColor = self.backgroundColor;
            [self.detailTextView setAttributedText:detail];
            self.detailTextView.delegate = self;
            
            lastAttribute = self.detailTextView.mas_bottom;
        }
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(16);
            make.left.right.equalTo(self);
        }];
        [self.buttonView setBackgroundColor:K_WhiteColor];
        
        UIButton *button = [UIButton k_blackButtonWithTarget:self action:@selector(buttonAction:)];
        [self.buttonView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.buttonView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(48);
            make.bottom.equalTo(self.buttonView.mas_bottom);
        }];
        [button setTitle:@"I Agree" forState:UIControlStateNormal];
        [button.layer setCornerRadius:24];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.buttonView.mas_bottom).mas_offset(20);
            
        }];
    }
    return self;
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if([textView isFirstResponder]){
        return YES;
    }
    return NO;
}
- (void)buttonAction:(UIButton *)sender {
    [self hide];
}
@end
