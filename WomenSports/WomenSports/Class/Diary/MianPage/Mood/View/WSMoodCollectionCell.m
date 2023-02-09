//
//  WSMoodCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import "WSMoodCollectionCell.h"

@implementation WSMoodCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.titleLabel setFont:KSFProRoundedMediumFont(16)];
    [self.titleLabel setTextColor:[UIColor k_colorWithHex:0x222222FF]];
    
    [self.bImageView setTintColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self.titleLabel setTextColor:K_WhiteColor];
        [self.bImageView setTintColor:[UIColor k_colorWithHex:0x1F1E25FF]];
    } else {
        [self.titleLabel setTextColor:[UIColor k_colorWithHex:0x222222FF]];
        [self.bImageView setTintColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
    }
}
@end
