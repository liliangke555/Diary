//
//  WSTargetChartCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/6.
//

#import "WSTargetChartCollectionCell.h"
//#import "AAChartKit.h"

@interface WSTargetChartCollectionCell ()
//@property (nonatomic, strong) AAChartView *aaChartView;
@end

@implementation WSTargetChartCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setBackgroundColor:K_WhiteColor];
    self.layer.shadowColor = [UIColor k_colorWithHex:0x17015512].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 8;
    self.layer.cornerRadius = 8;
    [self setClipsToBounds:YES];
    self.layer.masksToBounds = NO;
    
    [self.contentView.layer setCornerRadius:8];
    [self.contentView setClipsToBounds:YES];
    
    
//    self.aaChartView = [[AAChartView alloc]init];
//    //_aaChartView.scrollEnabled = NO;
//    [self.contentView addSubview:self.aaChartView];
    
    
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    self.aaChartView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
/*
- (void)setIndex:(NSInteger)index {
    _index = index;
    if (index == 0) {
        AAChartModel *aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeSpline)
        .xAxisLabelsStyleSet([AAStyle styleWithColor:@"#C9CDD9" fontSize:12])
        .xAxisTickIntervalSet(@12)
        .titleSet(@"Exercise consumption(kcal)")
        .titleStyleSet([AAStyle styleWithColor:@"#6D7797" fontSize:16])
        .tooltipValueSuffixSet(@"(kcal)")//设置浮动提示框单位后缀
        .yAxisGridLineStyleSet([AALineStyle styleWithWidth:@0])//y轴横向分割线宽度为0(即是隐藏分割线)
        .yAxisLabelsEnabledSet(NO)
        .legendEnabledSet(NO)
        .yAxisLineWidthSet(@0)//Y轴轴线线宽为0即是隐藏Y轴轴线
        .yAxisPlotLinesSet(@[
            AAPlotLinesElement.new
            .colorSet(@"#C9CDD9")//颜色值(16进制)
            .dashStyleSet(AAChartLineDashStyleTypeShortDash)//样式：Dash,Dot,Solid等,默认Solid
            .widthSet(@(1)) //标示线粗细
            .valueSet(@(200)) //所在位置
    //        .zIndexSet(@(5)) //层叠,标示线在图表中显示的层叠级别，值越大，显示越向前
            .labelSet(AALabel.new
              .textSet(@"Target")
            .styleSet([AAStyle styleWithColor:@"#C9CDD9" fontSize:12]))
        ])
        .xAxisCrosshairSet([AACrosshair crosshairWithColor:@"#778899"//浅石板灰准星线
                                                  dashStyle:AAChartLineDashStyleTypeLongDashDotDot
                                                      width:@1.2])//Zero width to disable crosshair by default
        .categoriesSet(@[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",
                         @"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",
                         @"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",
                         @"21:00",@"22:00",@"23:00",@"24:00"])
        .markerRadiusSet(@0)
        .seriesSet(@[
            AASeriesElement.new
            .colorSet(@"#FFAB2D")
            .lineWidthSet(@2)
            .nameSet(@"Consumption")
                .dataSet(@[@290.0, @106.9, @90.5,@199.0, @106.9, @90.5,@199.0, @106.9, @90.5,@199.0, @106.9, @90.5,@199.0, @106.9, @90.5,@199.0, @106.9, @90.5,@199.0, @106.9, @90.5,@199.0, @106.9, @90.5,@201])
            .borderWidthSet(@1),
        ]);
        [self.aaChartView aa_drawChartWithChartModel:aaChartModel];
    } else {
        AAChartModel *aaChartModel = AAChartModel.new
        .chartTypeSet(AAChartTypeSpline)
        .xAxisLabelsStyleSet([AAStyle styleWithColor:@"#C9CDD9" fontSize:12])
        .xAxisTickIntervalSet(@12)
        .titleSet(@"Exercise consumption(kcal)")
        .titleStyleSet([AAStyle styleWithColor:@"#6D7797" fontSize:16])
        .tooltipValueSuffixSet(@"(kcal)")//设置浮动提示框单位后缀
        .yAxisGridLineStyleSet([AALineStyle styleWithWidth:@0])//y轴横向分割线宽度为0(即是隐藏分割线)
        .yAxisLabelsEnabledSet(NO)
        .legendEnabledSet(NO)
        .yAxisLineWidthSet(@0)//Y轴轴线线宽为0即是隐藏Y轴轴线
        .yAxisPlotLinesSet(@[
            AAPlotLinesElement.new
            .colorSet(@"#C9CDD9")//颜色值(16进制)
            .dashStyleSet(AAChartLineDashStyleTypeShortDash)//样式：Dash,Dot,Solid等,默认Solid
            .widthSet(@(1)) //标示线粗细
            .valueSet(@(20)) //所在位置
    //        .zIndexSet(@(5)) //层叠,标示线在图表中显示的层叠级别，值越大，显示越向前
            .labelSet(AALabel.new
              .textSet(@"Target")
            .styleSet([AAStyle styleWithColor:@"#C9CDD9" fontSize:12]))
        ])
        .xAxisCrosshairSet([AACrosshair crosshairWithColor:@"#778899"//浅石板灰准星线
                                                  dashStyle:AAChartLineDashStyleTypeLongDashDotDot
                                                      width:@1.2])//Zero width to disable crosshair by default
        .categoriesSet(@[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",
                         @"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",
                         @"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",
                         @"21:00",@"22:00",@"23:00",@"24:00"])
        .markerRadiusSet(@0)
        .seriesSet(@[
            AASeriesElement.new
            .nameSet(@"Time")
            .lineWidthSet(@2)
            .colorSet(@"#108EFA")
                .dataSet(@[@29.0, @16.9, @9.5,@19.0, @6.9, @9.5,@19.0, @16.9, @0.5,@0.0, @1.9, @0.5,@1.0, @16.9, @9.5,@19.0, @16.9, @9.5,@99.0, @16.9, @90.5,@19.0, @16.9, @9.5,@21])
            .borderWidthSet(@1),
        ]);
        [self.aaChartView aa_drawChartWithChartModel:aaChartModel];
    }
}
 */
@end
