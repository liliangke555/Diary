//
//  WSMyPersentCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSMyPersentCollectionCell.h"

@implementation WSMyPersentCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.tnumberLabel setFont:KSFProRoundedMediumFont(12)];
    [self.tnumberLabel setTextColor:K_BlackColor];
}

@end
