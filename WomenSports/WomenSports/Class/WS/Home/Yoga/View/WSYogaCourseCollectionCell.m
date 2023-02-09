//
//  WSYogaCourseCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/5.
//

#import "WSYogaCourseCollectionCell.h"

@interface WSYogaCourseCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pImageView;
@property (weak, nonatomic) IBOutlet UILabel *playNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bageView;
@property (weak, nonatomic) IBOutlet UILabel *bageLabel;

@end

@implementation WSYogaCourseCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.pImageView.layer setCornerRadius:8];
    [self.pImageView setClipsToBounds:YES];
    
    [self.bageView.layer setCornerRadius:4];
    [self.bageView setClipsToBounds:YES];
}
- (void)setAdvanced:(BOOL)advanced {
    _advanced = advanced;
    if (advanced) {
        [self.bageView setBackgroundColor:K_TextOrangeSubColor];
        [self.bageLabel setTextColor:K_TextOrangeColor];
        [self.bageLabel setText:@"Advanced"];
    } else {
        [self.bageView setBackgroundColor:K_TextBuleSubColor];
        [self.bageLabel setTextColor:K_TextBuleColor];
        [self.bageLabel setText:@"Zero-based"];
    }
}
@end
