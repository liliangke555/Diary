//
//  WSBlackListTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSBlackListTableCell.h"

@interface WSBlackListTableCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end

@implementation WSBlackListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.headerView.layer setCornerRadius:30];
    [self.headerView.layer setBorderWidth:1];
    [self.headerView.layer setBorderColor:[UIColor k_colorWithHex:0x222222FF].CGColor];
    [self.headerView setClipsToBounds:YES];
    
    [self.headerImageView.layer setCornerRadius:28];
    [self.headerImageView setClipsToBounds:YES];
    
    [self.nameLabel setTextColor:[UIColor k_colorWithHex:0x222222FF]];
    [self.nameLabel setFont:KSFProRoundedMediumFont(16)];
    
    [self.removeButton.layer setCornerRadius:16];
    [self.removeButton.layer setBorderWidth:1];
    [self.removeButton.layer setBorderColor:K_BlackColor.CGColor];
    [self.removeButton.titleLabel setFont:KSFProRoundedMediumFont(14)];
    [self.removeButton setTitleColor:K_BlackColor forState:UIControlStateNormal];
    [self.removeButton setClipsToBounds:YES];
}
- (IBAction)removeButtonAction:(UIButton *)sender {
    if (self.didClickRemove) {
        self.didClickRemove(self.model);
    }
}
- (void)setModel:(WSGetBlackModel *)model {
    _model = model;
    if (model) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.header]
                                placeholderImage:[UIImage imageNamed:@"set_header_icon"]];
        [self.nameLabel setText:model.nickname];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
