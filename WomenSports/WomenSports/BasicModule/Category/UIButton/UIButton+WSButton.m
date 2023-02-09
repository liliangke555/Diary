//
//  UIButton+WSButton.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "UIButton+WSButton.h"
#import "WSMainButton.h"

@implementation UIButton (WSButton)
+ (instancetype) k_buttonWithTarget:(id)target action:(SEL)sel {
    id btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
    return btn;
}

+ (instancetype)k_whiteButtonWithTarget:(id)target action:(SEL)sel {
    UIButton * btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
    UIImage *img = [UIImage k_imageWithColor:K_WhiteColor];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage k_imageWithColor:KHexColor(0x999999FF)] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage k_imageWithColor:KHexColor(0x515151FF)] forState:UIControlStateDisabled];
    [btn setTitleColor:K_BlackColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:KSFProRoundedBoldFont(18)];
    [btn.layer setCornerRadius:6];
    [btn.layer setBorderWidth:1];
    [btn.layer setBorderColor:K_BlackColor.CGColor];
    [btn setClipsToBounds:YES];
    return btn;
}

+ (instancetype)k_blackButtonWithTarget:(id)target action:(SEL)sel {
    UIButton * btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
    UIImage *img = [UIImage k_imageWithColor:K_BlackColor];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage k_imageWithColor:KHexColor(0x999999FF)] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage k_imageWithColor:KHexColor(0x515151FF)] forState:UIControlStateDisabled];
    [btn setTitleColor:K_WhiteColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:KSFProRoundedBoldFont(18)];
    [btn.layer setCornerRadius:6];
    [btn setClipsToBounds:YES];
    return btn;
}

+ (instancetype)k_mainButtonWithTarget:(id)target action:(SEL)sel {
    WSMainButton * btn = [WSMainButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
//    UIImage *img = [UIImage k_imageWithColor:K_MainColor];
//    [btn setBackgroundImage:img forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage k_imageWithColor:KHexColor(0x999999FF)] forState:UIControlStateHighlighted];
//    [btn setBackgroundImage:[UIImage k_imageWithColor:KHexColor(0x515151FF)] forState:UIControlStateDisabled];
    [btn setTitleColor:K_WhiteColor forState:UIControlStateNormal];
    [btn setTitleColor:K_WhiteColor forState:UIControlStateDisabled];
    [btn.titleLabel setFont:KSFProRoundedBoldFont(18)];
    
    
    // gradient
//    CAGradientLayer *gl = [CAGradientLayer layer];
////    gl.frame = CGRectMake(0,0,345,48);
//    
//    gl.startPoint = CGPointMake(1, 0.5);
//    gl.endPoint = CGPointMake(0, 0.5);
//    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:111/255.0 blue:106/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:126/255.0 green:95/255.0 blue:255/255.0 alpha:1.0].CGColor];
//    gl.locations = @[@(0), @(1.0f)];
//    
//    [btn.layer insertSublayer:gl atIndex:0];
//    gl.frame = btn.bounds;
    btn.layer.cornerRadius = 20;
    [btn setClipsToBounds:YES];
    
    return btn;
}
@end
