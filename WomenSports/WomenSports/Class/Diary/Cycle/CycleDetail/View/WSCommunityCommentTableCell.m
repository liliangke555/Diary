//
//  WSCommunityCommentTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import "WSCommunityCommentTableCell.h"

@interface WSCommunityCommentTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation WSCommunityCommentTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.pimageView.layer setCornerRadius:18];
    [self.pimageView setClipsToBounds:YES];
    
    [self.nameLabel setFont:KSFProRoundedMediumFont(14)];
    [self.nameLabel setTextColor:K_TextGrayColor];
    
    [self.detailLabel setFont:KSFProRoundedMediumFont(16)];
    [self.detailLabel setTextColor:K_TextDrakGrayColor];
    
    [self.timeLabel setFont:KSFProRoundedRegularFont(11)];
    [self.timeLabel setTextColor:K_TextLightGrayColor];
    
    [self.likeButton setTitleColor:K_TextLightGrayColor forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor k_colorWithHex:0x11D7E1FF] forState:UIControlStateSelected];
    [self.likeButton.titleLabel setFont:KSFProRoundedRegularFont(12)];
}
- (void)setModel:(WSCycleDetailChildModel *)model {
    _model = model;
    if (model) {
        [self.pimageView sd_setImageWithURL:[NSURL URLWithString:model.data1]];
        [self.nameLabel setText:model.data2];
        [self.detailLabel setText:model.data3];
        [self.likeButton setTitle:[NSString stringWithFormat:@"  %ld",model.data4] forState:UIControlStateNormal];
        [self.timeLabel setText:model.createTimeString];
        if ([model.listActionType containsObject:@1]) {
            [self.likeButton setSelected:YES];
        } else {
            [self.likeButton setSelected:NO];
        }
    }
}
- (IBAction)likeButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.didClickLike) {
        self.didClickLike(self.model, sender.isSelected);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
