//
//  WSReportTableCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/8.
//

#import "WSReportTableCell.h"

@interface WSReportTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;


@end

@implementation WSReportTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [self.selectedImageView setImage:[UIImage imageNamed:@"community_selected_icon"]];
    } else {
        [self.selectedImageView setImage:[UIImage imageNamed:@"community_normal_icon"]];
    }
}

@end
