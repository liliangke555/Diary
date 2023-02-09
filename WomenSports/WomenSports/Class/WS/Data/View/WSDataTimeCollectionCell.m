//
//  WSDataTimeCollectionCell.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/9.
//

#import "WSDataTimeCollectionCell.h"

@interface WSDataTimeCollectionCell ()
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIView *smallView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (nonatomic, strong)CAGradientLayer *backgroundLayer;

@end

@implementation WSDataTimeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.timeView.layer setCornerRadius:4];
    [self.timeView setClipsToBounds:YES];
    [self.timeLabel setTextColor:K_TextDrakGrayColor];
    
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bigView.frame) / 2,
                                                                                 CGRectGetHeight(self.bigView.frame) / 2)
                                                              radius:(CGRectGetWidth(self.bigView.frame) - 3)/2
                                                          startAngle:-M_PI/2.0f
                                                            endAngle:3/2.0f*M_PI
                                                           clockwise:YES];
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = self.bigView.bounds;
    bgLayer.fillColor = [UIColor clearColor].CGColor;//填充色 -  透明
    bgLayer.lineWidth = 3;
    bgLayer.strokeColor = [UIColor k_colorWithHex:0xE0E2E9FF].CGColor;//线条颜色
    bgLayer.strokeStart = 0;//起始点
    bgLayer.strokeEnd = 1;//终点
    bgLayer.lineCap = kCALineCapRound;//让线两端是圆滑的状态
    bgLayer.path = circlePath.CGPath;//这里就是把背景的路径设为之前贝塞尔曲线的那个路径
    [self.bigView.layer addSublayer:bgLayer];
    
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 3;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeColor = [UIColor k_colorWithHex:0xFFAB0DFF].CGColor;
        _shapeLayer.strokeStart = 0;
        _shapeLayer.strokeEnd = 0.5;
        _shapeLayer.path = circlePath.CGPath;
        [self.bigView.layer addSublayer:_shapeLayer];
    
    {
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.smallView.frame) / 2,
                                                                                     CGRectGetHeight(self.smallView.frame) / 2)
                                                                  radius:(CGRectGetWidth(self.smallView.frame) - 3)/2
                                                              startAngle:-M_PI/2.0f
                                                                endAngle:3/2.0f*M_PI
                                                               clockwise:YES];
        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        bgLayer.frame = self.smallView.bounds;
        bgLayer.fillColor = [UIColor clearColor].CGColor;//填充色 -  透明
        bgLayer.lineWidth = 3;
        bgLayer.strokeColor = [UIColor k_colorWithHex:0xE0E2E9FF].CGColor;//线条颜色
        bgLayer.strokeStart = 0;//起始点
        bgLayer.strokeEnd = 1;//终点
        bgLayer.lineCap = kCALineCapRound;//让线两端是圆滑的状态
        bgLayer.path = circlePath.CGPath;//这里就是把背景的路径设为之前贝塞尔曲线的那个路径
        [self.smallView.layer addSublayer:bgLayer];
        
        
        CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 3;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeColor = [UIColor k_colorWithHex:0x0D8EFFFF].CGColor;
        _shapeLayer.strokeStart = 0;
        _shapeLayer.strokeEnd = 1/360.0f;
        _shapeLayer.path = circlePath.CGPath;
        [self.smallView.layer addSublayer:_shapeLayer];
    }
    [self.bigView.layer setCornerRadius:15];
    [self.smallView.layer setCornerRadius:10];
    
    
}
- (void)setIndex:(NSInteger)index {
    _index = index;
    if (index == 0) {
        [self.timeLabel setText:@"Mon"];
    } else if (index == 1) {
        [self.timeLabel setText:@"Tues"];
    } else if (index == 2) {
        [self.timeLabel setText:@"Wed"];
    } else if (index == 3) {
        [self.timeLabel setText:@"Thur"];
    } else if (index == 4) {
        [self.timeLabel setText:@"Fri"];
    } else if (index == 5) {
        [self.timeLabel setText:@"Sat"];
    } else if (index == 6) {
        [self.timeLabel setText:@"Sun"];
    }
    [self timeViewInsertSubLayerWithIndex:index];
}
- (void)timeViewInsertSubLayerWithIndex:(NSInteger)index {
    if (index == 6) {
        if (self.weekNum == 0) {
            [self.timeView.layer insertSublayer:self.backgroundLayer atIndex:0];
            [self.timeLabel setTextColor:K_WhiteColor];
            self.backgroundLayer.frame = self.timeView.bounds;
        } else {
            [self.backgroundLayer removeFromSuperlayer];
            [self.timeLabel setTextColor:K_TextDrakGrayColor];
        }
    } else {
        if (self.weekNum - 1 == index) {
            [self.timeView.layer insertSublayer:self.backgroundLayer atIndex:0];
            [self.timeLabel setTextColor:K_WhiteColor];
            self.backgroundLayer.frame = self.timeView.bounds;
        } else {
            [self.backgroundLayer removeFromSuperlayer];
            [self.timeLabel setTextColor:K_TextDrakGrayColor];
        }
    }
    
}
- (CAGradientLayer *)backgroundLayer {
    if (!_backgroundLayer) {
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
    //    gl.frame = CGRectMake(0,0,345,48);
        
        gl.startPoint = CGPointMake(1, 0.5);
        gl.endPoint = CGPointMake(0, 0.5);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:111/255.0 blue:106/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:126/255.0 green:95/255.0 blue:255/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        _backgroundLayer = gl;
    }
    return _backgroundLayer;
}
@end
