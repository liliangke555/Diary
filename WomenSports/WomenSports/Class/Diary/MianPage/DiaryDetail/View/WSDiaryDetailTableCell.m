//
//  WSDiaryDetailTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/15.
//

#import "WSDiaryDetailTableCell.h"

@interface WSDiaryDetailTableCell ()
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation WSDiaryDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.detailView.layer setCornerRadius:8];
    [self.detailView.layer setBorderWidth:2];
    [self.detailView.layer setBorderColor:K_BlackColor.CGColor];
    
    [self.detailTitleLabel setFont:KSFProRoundedMediumFont(16)];
    [self.detailTitleLabel setTextColor:[UIColor k_colorWithHex:0x1F1E25FF]];
    
    [self.timeLabel setFont:KSFProRoundedRegularFont(14)];
    [self.timeLabel setTextColor:K_TextDrakGrayColor];
    
    [self.dayLabel setFont:KSFProRoundedRegularFont(22)];
    [self.dayLabel setTextColor:[UIColor k_colorWithHex:0x1F1E25FF]];
    
    [self.dateLabel setFont:KSFProRoundedRegularFont(13)];
    [self.dateLabel setTextColor:K_TextDrakGrayColor];
    
    [self.typeLabel setFont:KSFProRoundedRegularFont(11)];
}
- (void)setModel:(WSDiaryDetailModel *)model {
    _model = model;
    if (model) {
        NSArray *array = [model.data3 componentsSeparatedByString:@"-"];
        [self.dayLabel setText:array.lastObject];
        [self.dateLabel setText:model.data3];
        if ([model.data7 boolValue]) {
            [self.typeLabel setText:@"Published"];
            [self.typeLabel setTextColor:K_BlackColor];
        } else {
            [self.typeLabel setText:@"Unpublished"];
            [self.typeLabel setTextColor:K_TextLightGrayColor];
        }
        [self.timeLabel setText:model.data3];
        [self.detailTitleLabel setText:model.data4];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"EEE"];
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        formatter2.dateFormat = @"yyyy-MM-dd";
        NSDate *endDate = [formatter2 dateFromString:model.data3];
        NSString *theWeek = [dateFormat stringFromDate:endDate];
        [self.dateLabel setText:[NSString stringWithFormat:@"%@/%@",array[1],theWeek]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
