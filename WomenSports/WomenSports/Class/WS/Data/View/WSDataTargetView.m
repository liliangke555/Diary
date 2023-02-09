//
//  WSDataTargetView.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/9.
//

#import "WSDataTargetView.h"

@interface WSDataTargetView ()
@property (weak, nonatomic) IBOutlet UILabel *consumptLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptBLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseBLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightBLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIView *bigCycleView;
@property (weak, nonatomic) IBOutlet UIView *smallCycleView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@end

@implementation WSDataTargetView
+ (instancetype)dataTargetView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WSDataTargetView" owner:nil options:@{}] lastObject];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.layer setCornerRadius:12];
    [self setClipsToBounds:YES];
    
    [self.recordButton.layer setCornerRadius:20];
    [self.recordButton setClipsToBounds:YES];
    
    [self.consumptLabel setText:@"150"];
    [self.consumptLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    [self.consumptLabel setFont:KSDINBoldFont(24)];
    [self.consumptBLabel setFont:KSDINBoldFont(16)];
    [self.consumptBLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    
    [self.exerciseLabel setText:@"20"];
    [self.exerciseLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    [self.exerciseLabel setFont:KSDINBoldFont(24)];
    [self.exerciseBLabel setText:@"/20(min)"];
    [self.exerciseBLabel setFont:KSDINBoldFont(16)];
    [self.exerciseBLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    

    [self.weightLabel setText:@"62"];
    [self.weightLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    [self.weightLabel setFont:KSDINBoldFont(24)];
    [self.weightBLabel setText:@"/49(kg)"];
    [self.weightBLabel setFont:KSDINBoldFont(16)];
    [self.weightBLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bigCycleView.frame) / 2,
                                                                                 CGRectGetHeight(self.bigCycleView.frame) / 2)
                                                              radius:(CGRectGetWidth(self.bigCycleView.frame) - 10)/2
                                                          startAngle:-M_PI/2.0f
                                                            endAngle:3/2.0f*M_PI
                                                           clockwise:YES];
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = self.bigCycleView.bounds;
    bgLayer.fillColor = [UIColor clearColor].CGColor;//填充色 -  透明
    bgLayer.lineWidth = 10.f;
    bgLayer.strokeColor = [UIColor k_colorWithHex:0xE0E2E9FF].CGColor;//线条颜色
    bgLayer.strokeStart = 0;//起始点
    bgLayer.strokeEnd = 1;//终点
    bgLayer.lineCap = kCALineCapRound;//让线两端是圆滑的状态
    bgLayer.path = circlePath.CGPath;//这里就是把背景的路径设为之前贝塞尔曲线的那个路径
    [self.bigCycleView.layer addSublayer:bgLayer];
    
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 10.f;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeColor = [UIColor k_colorWithHex:0xFFAB0DFF].CGColor;
        _shapeLayer.strokeStart = 0;
        _shapeLayer.strokeEnd = 0.5;
        _shapeLayer.path = circlePath.CGPath;
        [self.bigCycleView.layer addSublayer:_shapeLayer];
    
    {
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.smallCycleView.frame) / 2,
                                                                                     CGRectGetHeight(self.smallCycleView.frame) / 2)
                                                                  radius:(CGRectGetWidth(self.smallCycleView.frame) - 10)/2
                                                              startAngle:-M_PI/2.0f
                                                                endAngle:3/2.0f*M_PI
                                                               clockwise:YES];
        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        bgLayer.frame = self.smallCycleView.bounds;
        bgLayer.fillColor = [UIColor clearColor].CGColor;//填充色 -  透明
        bgLayer.lineWidth = 10.f;
        bgLayer.strokeColor = [UIColor k_colorWithHex:0xE0E2E9FF].CGColor;//线条颜色
        bgLayer.strokeStart = 0;//起始点
        bgLayer.strokeEnd = 1;//终点
        bgLayer.lineCap = kCALineCapRound;//让线两端是圆滑的状态
        bgLayer.path = circlePath.CGPath;//这里就是把背景的路径设为之前贝塞尔曲线的那个路径
        [self.smallCycleView.layer addSublayer:bgLayer];
        
        
        CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 10.f;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeColor = [UIColor k_colorWithHex:0x0D8EFFFF].CGColor;
        _shapeLayer.strokeStart = 0;
        _shapeLayer.strokeEnd = 1/360.0f;
        _shapeLayer.path = circlePath.CGPath;
        [self.smallCycleView.layer addSublayer:_shapeLayer];
    }
}
- (IBAction)recordButtonAction:(UIButton *)sender {
    if (self.didClickRecord) {
        self.didClickRecord();
    }
}
- (IBAction)rightButtonAction:(UIButton *)sender {
    if (self.didClickRightButton) {
        self.didClickRightButton();
    }
}

@end
