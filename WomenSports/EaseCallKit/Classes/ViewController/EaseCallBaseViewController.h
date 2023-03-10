//
//  EaseCallBaseViewController.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseCallStreamView.h"
#import <HyphenateChat/HyphenateChat.h>

/**屏幕宽度*/
#define CK_WIDTH  [UIScreen mainScreen].bounds.size.width
/**屏幕高度*/
#define CK_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CK_WIDTH_Sales  CK_WIDTH/375
#define CK_HEIGHT_Sales  CK_HEIGHT/812
#define KStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height

NS_ASSUME_NONNULL_BEGIN

@interface EaseCallBaseViewController : UIViewController
@property (nonatomic,strong) UIButton* microphoneButton;
@property (nonatomic,strong) UIButton* enableCameraButton;
@property (nonatomic,strong) UIButton* switchCameraButton;
@property (nonatomic,strong) UIButton* speakerButton;
@property (nonatomic,strong) UIButton* hangupButton;
@property (nonatomic,strong) UIButton* answerButton;
@property (nonatomic,strong) UILabel* timeLabel;
@property (strong, nonatomic) NSTimer *timeTimer;
@property (nonatomic, assign) int timeLength;
@property (nonatomic,strong) UILabel* microphoneLabel;
@property (nonatomic,strong) UILabel* enableCameraLabel;
@property (nonatomic,strong) UILabel* switchCameraLabel;
@property (nonatomic,strong) UILabel* speakerLabel;
@property (nonatomic,strong) UILabel* hangupLabel;
@property (nonatomic,strong) UILabel* acceptLabel;
@property (nonatomic,strong) UIButton* miniButton;
@property (nonatomic,strong) UIView* contentView;
@property (nonatomic) EaseCallStreamView* floatingView;
@property (nonatomic) BOOL isMini;

- (void)hangupAction;
- (void)muteAction;
- (void)enableVideoAction;
- (void)startTimer;
- (void)answerAction;
- (void)miniAction;
- (void)usersInfoUpdated;
@end

NS_ASSUME_NONNULL_END
