//
//  WSGiftCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import "WSGiftCollectionCell.h"

@implementation WSGiftCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView.layer setCornerRadius:8];
    [self.contentView.layer setBorderWidth:1];
    [self.contentView.layer setBorderColor:UIColor.clearColor.CGColor];
    [self.contentView setClipsToBounds:YES];
    [self.contentView setBackgroundColor:UIColor.clearColor];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self.contentView.layer setBorderColor:K_BlackColor.CGColor];
        [self.contentView setBackgroundColor:[UIColor k_colorWithHex:0xF6F6F6FF]];
    } else {
        [self.contentView.layer setBorderColor:UIColor.clearColor.CGColor];
        [self.contentView setBackgroundColor:UIColor.clearColor];
    }
}

@end
