//
//  WSComImageCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/7.
//

#import "WSComImageCollectionCell.h"



@implementation WSComImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.pImageView.layer setCornerRadius:8];
    [self.pImageView setClipsToBounds:YES];
}

@end
