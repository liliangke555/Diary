//
//  WSCycleCotentTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSCycleCotentTableCell.h"

@implementation WSCycleCotentTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titleLabel setFont:KSFProRoundedBoldFont(16)];
    [self.titleLabel setTextColor:K_BlackColor];
    
    [self.contentLabel setFont:KSFProRoundedRegularFont(16)];
    [self.contentLabel setTextColor:K_TextDrakGrayColor];
    
    [self.timeLabel setFont:KSFProRoundedRegularFont(12)];
    [self.timeLabel setTextColor:[UIColor k_colorWithHex:0xD9D9D9FF]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
