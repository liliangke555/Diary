//
//  WSTrainCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSTrainCollectionCell.h"

@interface WSTrainCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@end

@implementation WSTrainCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageViewArray = [NSMutableArray array];
    
    [self.layer setCornerRadius:8];
    [self setClipsToBounds:YES];
}
- (void)setIndex:(NSInteger)index {
    _index = index;
    if (index == 0) {
        [self.titleLabel setText:@"Faster"];
        [self.subTitleLabel setText:@"30-40 minutes of training every day"];
    } else if (index == 1) {
        [self.titleLabel setText:@"Medium"];
        [self.subTitleLabel setText:@"20-30 minutes of training every day"];
    } else {
        [self.titleLabel setText:@"Slower"];
        [self.subTitleLabel setText:@"10-20 minutes of training every day"];
    }
    __block UIImageView *lastImageView = nil;
    for (NSInteger i = 0; i < 3 - index; i ++) {
        UIImageView *imageView = [UIImageView.alloc init];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.right.equalTo(self.contentView.mas_right).mas_offset(-15);
            } else {
                make.right.equalTo(lastImageView.mas_left).mas_offset(-11);
            }
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        lastImageView = imageView;
        [imageView setImage:[UIImage imageNamed:@"lightning_icon"]];
        
        [self.imageViewArray addObject:imageView];
    }
    
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor k_colorWithHex:0xF1ECFEFF]];
        [self.titleLabel setTextColor:K_TextBuleColor];
        [self.subTitleLabel setTextColor:[UIColor k_colorWithHex:0x9E7CFAFF]];
        
        for (UIImageView *imageView in self.imageViewArray) {
            [imageView setImage:[UIImage imageNamed:@"lightning_highlight_icon"]];
        }
    } else {
        [self.contentView setBackgroundColor:[UIColor k_colorWithHex:0xF4F4F7FF]];
        [self.titleLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
        [self.subTitleLabel setTextColor:[UIColor k_colorWithHex:0x8D95AEFF]];
        for (UIImageView *imageView in self.imageViewArray) {
            [imageView setImage:[UIImage imageNamed:@"lightning_icon"]];
        }
    }
}
@end
