//
//  WSTargetHead.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/6.
//

#import "WSTargetHead.h"

@interface WSTargetHead ()
@property (weak, nonatomic) IBOutlet UILabel *consNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumpLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIView *bigCycleView;
@property (weak, nonatomic) IBOutlet UIView *smallCycleView;
@property (weak, nonatomic) IBOutlet UILabel *midLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentNumLabel;

@end

@implementation WSTargetHead

+ (instancetype)TargetHeadView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WSTargetHead" owner:nil options:@{}] lastObject];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:UIColor.clearColor];
    [self.bigCycleView setBackgroundColor:UIColor.clearColor];
    [self.smallCycleView setBackgroundColor:UIColor.clearColor];
    
    [self.consNumLabel setText:@"150"];
    [self.consNumLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    [self.consNumLabel setFont:KSDINBoldFont(24)];
    [self.consumpLabel setText:@"/150(kcal)"];
    [self.consumpLabel setFont:KSDINBoldFont(16)];
    [self.consumpLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    
    [self.exerciseNumLabel setText:@"20"];
    [self.exerciseNumLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    [self.exerciseNumLabel setFont:KSDINBoldFont(24)];
    [self.exerciseLabel setText:@"/20(min)"];
    [self.exerciseLabel setFont:KSDINBoldFont(16)];
    [self.exerciseLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    

    [self.currentNumLabel setText:@"A"];
    [self.currentNumLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    [self.currentNumLabel setFont:KSDINBoldFont(24)];
    [self.currentLabel setText:@"/s"];
    [self.currentLabel setFont:KSDINBoldFont(16)];
    [self.currentLabel setTextColor:[UIColor k_colorWithHex:0x323F6DFF]];
    
    
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
- (IBAction)leftButtonAction:(UIButton *)sender {
}
- (IBAction)rightButtonAction:(UIButton *)sender {
}
@end
