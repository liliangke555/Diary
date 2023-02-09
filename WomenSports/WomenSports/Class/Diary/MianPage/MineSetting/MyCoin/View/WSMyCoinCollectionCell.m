//
//  WSMyCoinCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSMyCoinCollectionCell.h"

@interface WSMyCoinCollectionCell ()


@end

@implementation WSMyCoinCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView setBackgroundColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
    [self.contentView.layer setCornerRadius:8];
    [self.contentView setClipsToBounds:YES];
    
    [self.coinLabel setTextColor:[UIColor k_colorWithHex:0x1F1E25FF]];
    [self.coinLabel setFont:KSDINBoldFont(22)];
    
    [self.bLabel setTextColor:[UIColor k_colorWithHex:0x8D95AEFF]];
    [self.bLabel setFont:KSDINBoldFont(11)];
    
    [self.moneyLabel setTextColor:[UIColor k_colorWithHex:0x8D95AEFF]];
    [self.moneyLabel setFont:KSDINBoldFont(14)];
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor k_colorWithHex:0x1F1E25FF]];
        [self.coinLabel setTextColor:K_WhiteColor];
        [self.bLabel setTextColor:K_WhiteColor];
        [self.moneyLabel setTextColor:K_WhiteColor];
    } else {
        [self.contentView setBackgroundColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
        [self.coinLabel setTextColor:[UIColor k_colorWithHex:0x1F1E25FF]];
        [self.bLabel setTextColor:[UIColor k_colorWithHex:0x8D95AEFF]];
        [self.moneyLabel setTextColor:[UIColor k_colorWithHex:0x8D95AEFF]];
    }
}
@end
