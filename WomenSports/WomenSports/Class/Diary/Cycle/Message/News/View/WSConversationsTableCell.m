//
//  WSConversationsTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/2/2.
//

#import "WSConversationsTableCell.h"

@implementation WSConversationsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, CK_WIDTH, 0, 0)];
    
    [self.headerImageBackView.layer setCornerRadius:27];
    [self.headerImageBackView.layer setBorderWidth:1];
    [self.headerImageBackView.layer setBorderColor:K_BlackColor.CGColor];
    [self.headerImageBackView setClipsToBounds:YES];
    
    [self.headerImageView.layer setCornerRadius:25];
    [self.headerImageView setClipsToBounds:YES];
    
    [self.bageView.layer setCornerRadius:8];
    [self.bageView setClipsToBounds:YES];
    [self.bageView setBackgroundColor:[UIColor k_colorWithHex:0x11D7E1FF]];
    
    [self.nameLabel setFont:KSFProRoundedMediumFont(16)];
    [self.nameLabel setTextColor:K_BlackColor];
    
    [self.contentLabel setFont:KSFProRoundedMediumFont(14)];
    [self.contentLabel setTextColor:K_TextDrakGrayColor];
    
    [self.timeLabel setFont:KSFProRoundedMediumFont(12)];
    [self.timeLabel setTextColor:[UIColor k_colorWithHex:0xD9D9D9FF]];
    
    [self.bageLabel setFont:KSFProRoundedMediumFont(11)];
    [self.bageLabel setTextColor:UIColor.whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
