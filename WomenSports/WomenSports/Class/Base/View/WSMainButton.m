//
//  WSMainButton.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSMainButton.h"

@interface WSMainButton ()
@property (nonatomic, strong)CAGradientLayer *backgroundLayer;
@end

@implementation WSMainButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
    //    gl.frame = CGRectMake(0,0,345,48);
        
        gl.startPoint = CGPointMake(1, 0.5);
        gl.endPoint = CGPointMake(0, 0.5);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:111/255.0 blue:106/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:126/255.0 green:95/255.0 blue:255/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        
        [self.layer insertSublayer:gl atIndex:0];
        self.backgroundLayer = gl;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundLayer.frame = self.bounds;
}
@end
