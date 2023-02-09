//
//  WSMIneSettingView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/10.
//

#import "WSMIneSettingView.h"

@interface WSMIneSettingView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation WSMIneSettingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.type = MMPopupTypeCustom;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CK_HEIGHT);
            make.width.mas_equalTo(278);
        }];
        
        [MMPopupWindow sharedWindow].touchWildToHide = YES;
        
        [self setBackgroundColor:K_WhiteColor];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        
        UIImageView *imageView = [UIImageView.alloc init];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).mas_offset(KStatusBarHeight);
            make.left.equalTo(self.mas_left).mas_offset(15);
            make.width.height.mas_equalTo(44);
        }];
        [imageView sd_setImageWithURL:[NSURL URLWithString:kUser.headerUrl] placeholderImage:[UIImage imageNamed:@"set_header_icon"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView.layer setCornerRadius:22];
        [imageView setClipsToBounds:YES];
        
        UIButton *button = [UIButton mm_buttonWithTarget:self action:@selector(headerButtonAction:)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).mas_offset(10);
            make.centerY.equalTo(imageView.mas_centerY);
        }];
        [button.titleLabel setFont:KSFProRoundedBoldFont(18)];
        [button setTitle:[NSString stringWithFormat:@"%@ ",kUser.name] forState:UIControlStateNormal];
        [button setTitleColor:K_TextMainColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"target_right_icon"] forState:UIControlStateNormal];
        [button setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        self.imageArray = @[@"mine_coins_icon",@"mine_post_icon",@"mine_collect_icon",@"mine_present_icon",@"mine_about_icon",@"mine_privacy_icon",@"mine_delete_icon",@"mine_logout_icon"];
        self.titleArray = @[@"My Coins",@"My Post",@"Blacklist",@"My Present",@"Terms of Use",@"Privacy Policy",@"Delete Account",@"Log Out"];
        
        UITableView *tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom);
            make.left.right.bottom.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setRowHeight:60];
        [tableView setTableHeaderView:[UIView.alloc initWithFrame:CGRectMake(0, 0, 278, 15)]];
        [tableView setSeparatorColor:K_WhiteColor];
        [tableView setBackgroundColor:K_WhiteColor];
//        self.showAnimation = [self customShowAnimation];
//        self.hideAnimation = [self customHideAnimation];
        
        self.animationDuration = 0.25f;
    }
    return self;
}
- (void)headerButtonAction:(UIButton *)sender {
    if (self.didClickPerson) {
        self.didClickPerson();
    }
    [self hide];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.textLabel setTextColor:[UIColor k_colorWithHex:0x1F1E25FF]];
        [cell.textLabel setFont:KSFProRoundedRegularFont(16)];
    }
    [cell.textLabel setText:self.titleArray[indexPath.row]];
    [cell.imageView setImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didClickContent) {
        self.didClickContent(indexPath.row);
    }
    [self hide];
}

- (MMPopupBlock)customShowAnimation {
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        if ( !self.superview )
        {
            [self.attachedView.mm_dimBackgroundView addSubview:self];
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.attachedView);
                make.left.equalTo(self.attachedView.mas_left).mas_offset(-self.attachedView.frame.size.width);
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
                                 make.left.equalTo(self.attachedView.mas_left).mas_offset(0);
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
                                 make.left.equalTo(self.attachedView.mas_left).mas_offset(-self.attachedView.frame.size.width);
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
