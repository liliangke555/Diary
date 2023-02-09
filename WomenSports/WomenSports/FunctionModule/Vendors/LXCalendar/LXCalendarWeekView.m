//
//  LXCalendarWeekView.m
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXCalendarWeekView.h"

@implementation LXCalendarWeekView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}
-(void)setWeekTitles:(NSArray *)weekTitles{
    _weekTitles = weekTitles;
    
//    CGFloat width = CGRectGetWidth(self.frame) /weekTitles.count;
    
    __block UILabel *lastLabel =nil;
    for (int i = 0; i< weekTitles.count; i++) {
        UILabel *weekLabel =[[UILabel alloc]init];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.text = weekTitles[i];
        weekLabel.backgroundColor = K_WhiteColor;
//        weekLabel.frame= CGRectMake(i * width, 0, width, CGRectGetHeight(self.frame));
        weekLabel.font = KSFProRoundedMediumFont(14);
        if (i == 0) {
            weekLabel.textColor = K_BlackColor;
        } else {
            weekLabel.textColor = K_TextGrayColor;
        }
        weekLabel.backgroundColor =[UIColor whiteColor];
        [self addSubview:weekLabel];
        [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(self.mas_left);
            } else {
                make.left.equalTo(lastLabel.mas_right);
                make.width.equalTo(lastLabel.mas_width);
            }
            make.top.bottom.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        lastLabel = weekLabel;
    }
    [lastLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
    }];
}
@end
