//
//  WSWeatherCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/13.
//

#import "WSWeatherCollectionCell.h"

@implementation WSWeatherCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.pImageView setTintColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
    [self.wImageView setTintColor:[UIColor k_colorWithHex:0x222222FF]];
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self.pImageView setTintColor:[UIColor k_colorWithHex:0x1F1E25FF]];
        [self.wImageView setTintColor:K_WhiteColor];
    } else {
        [self.pImageView setTintColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
        [self.wImageView setTintColor:[UIColor k_colorWithHex:0x222222FF]];
    }
}
@end
