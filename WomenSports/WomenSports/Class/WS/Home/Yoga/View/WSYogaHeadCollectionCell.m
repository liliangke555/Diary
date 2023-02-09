//
//  WSYogaHeadCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSYogaHeadCollectionCell.h"

@implementation WSYogaHeadCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.pImageView.layer setCornerRadius:8];
    [self.pImageView setClipsToBounds:YES];
}

@end
