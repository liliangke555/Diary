//
//  WSCommunityComBottomView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import "WSCommunityComBottomView.h"

@interface WSCommunityComBottomView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *textbackView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *giftButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldRight;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation WSCommunityComBottomView
+ (instancetype)CommunityVBottomView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WSCommunityComBottomView" owner:nil options:@{}] lastObject];
}
- (IBAction)giftButtonAction:(UIButton *)sender {
    if (self.didClickGift) {
        self.didClickGift();
    }
}
- (IBAction)commentButtonAction:(UIButton *)sender {
}
- (IBAction)likeButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.didClickLike) {
        self.didClickLike(sender.isSelected);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.shadowColor = [UIColor k_colorWithHex:0xBFE0FD12].CGColor;
    self.layer.shadowOffset = CGSizeMake(2,-6);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 8;
    [self setClipsToBounds:YES];
    self.layer.masksToBounds = NO;
    
    [self.textbackView.layer setCornerRadius:18];
    [self.textbackView setClipsToBounds:YES];
    
    self.textField.delegate = self;
    
    self.sendButton.hidden = YES;
    [self.sendButton.layer setCornerRadius:15];
    [self.sendButton setClipsToBounds:YES];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardDidShow {
    self.sendButton.hidden = NO;
    [self.giftButton setHidden:YES];
    [self.commentButton setHidden:YES];
    [self.likeButton setHidden:YES];
    CKWeakify(self);
    [UIView animateWithDuration:0.25f animations:^{
        weakSelf.textFieldRight.constant = - CK_WIDTH / 4.0f;
    }];
}
- (void)keyboardDidHide {
    self.sendButton.hidden = YES;
    [self.giftButton setHidden:NO];
    [self.commentButton setHidden:NO];
    [self.likeButton setHidden:NO];
    CKWeakify(self);
    [UIView animateWithDuration:0.25f animations:^{
        weakSelf.textFieldRight.constant = 0;
    }];
}
- (IBAction)sendButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    if (self.didSendComment) {
        self.didSendComment(self.textField.text);
    }
    [self.textField setText:@""];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.didSendComment) {
        self.didSendComment(textField.text);
    }
    
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}
- (void)setModel:(WSCycleDetailModel *)model {
    _model = model;
    if (model) {
        [self.giftButton setTitle:[NSString stringWithFormat:@"  %ld",model.data13] forState:UIControlStateNormal];
        [self.commentButton setTitle:[NSString stringWithFormat:@"  %ld",model.child.count] forState:UIControlStateNormal];
        [self.likeButton setTitle:[NSString stringWithFormat:@"  %ld",model.data11] forState:UIControlStateNormal];
        if ([model.listActionType containsObject:@1]) {
            [self.likeButton setSelected:YES];
        } else {
            [self.likeButton setSelected:NO];
        }
    }
}
@end
