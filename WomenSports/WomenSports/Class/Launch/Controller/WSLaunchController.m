//
//  WSLaunchController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSLaunchController.h"

@interface WSLaunchController ()

@end

@implementation WSLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:K_MainColor];
    [self setUIView];
}
- (void)setUIView {
    UIImageView *iconImage = [UIImageView.alloc init];
    [self.view addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-140);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [iconImage setImage:[UIImage imageNamed:@"lunch_icon"]];
}
@end
