//
//  WSDiaryMoreCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/17.
//

#import "WSDiaryMoreCollectionCell.h"

@implementation WSDiaryMoreCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titleLabel setTextColor:K_BlackColor];
    [self.titleLabel setFont:KSFProRoundedMediumFont(13)];
}

@end
