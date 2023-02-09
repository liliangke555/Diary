//
//  WSCycleImageTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/18.
//

#import "WSCycleImageTableCell.h"

@implementation WSCycleImageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSeparatorInset:UIEdgeInsetsMake(0, CK_WIDTH, 0, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
