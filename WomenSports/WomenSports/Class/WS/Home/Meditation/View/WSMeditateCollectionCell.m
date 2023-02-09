//
//  WSMeditateCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/6.
//

#import "WSMeditateCollectionCell.h"

@interface WSMeditateCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pImageView;
@property (weak, nonatomic) IBOutlet UILabel *playNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTextLabel;
@property (weak, nonatomic) IBOutlet UIView *oneBageView;
@property (weak, nonatomic) IBOutlet UIView *twoBageView;
@property (weak, nonatomic) IBOutlet UILabel *oneBageLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoBageLabel;

@end

@implementation WSMeditateCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.pImageView.layer setCornerRadius:8];
    [self.pImageView setClipsToBounds:YES];
    
    [self.oneBageView.layer setCornerRadius:4];
    [self.oneBageView setClipsToBounds:YES];
    
    [self.twoBageView.layer setCornerRadius:4];
    [self.twoBageView setClipsToBounds:YES];
}
- (void)setRealxPage:(BOOL)realxPage {
    _realxPage = realxPage;
    [self.subTextLabel setHidden:!realxPage];
}
@end
