//
//  WSConversationsTableCell.h
//  WomenSports
//
//  Created by 李良科 on 2023/2/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WSConversationsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *headerImageBackView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bageView;
@property (weak, nonatomic) IBOutlet UILabel *bageLabel;

@end

NS_ASSUME_NONNULL_END
