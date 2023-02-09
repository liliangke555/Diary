//
//  WSBaseController.m
//  WomenSports
//
//  Created by 李良科 on 2023/1/4.
//

#import "WSBaseController.h"
#import <YBImageBrowser/YBIBImageData.h>
#import <YBImageBrowser/YBImageBrowser.h>
//#import <YBImageBrowser/YBIBVideoData.h>

@interface WSBaseController ()

@end

@implementation WSBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:K_WhiteColor];
    
//    UIImageView *imageView = [UIImageView.alloc init];
//    [self.view addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
//    [imageView setImage:[UIImage imageNamed:@"background_icon"]];
}
- (void)animation {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.25;    // 在window上执行CATransition, 即可在ViewController转场时执行动画
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:animation forKey:@"kTransitionAnimation"];
}
/// 图片 视频预览
/// @param index 当前图片index
/// @param data 图片数组
/// @param view 展示的View
- (void)showBrowerWithIndex:(NSInteger)index data:(NSArray *)data view:(id)view {
    NSMutableArray *datas = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//         if ([obj hasSuffix:@".mp4"] && [obj hasPrefix:@"http"]) { // 网络视频
//               YBIBVideoData *data = [YBIBVideoData new];
//               data.videoURL = [NSURL URLWithString:obj];
//               data.projectiveView = view;
//               [datas addObject:data];
//
//           } else
               if ([obj hasPrefix:@"http"]) { // 网络图片
               YBIBImageData *data = [YBIBImageData new];
               data.imageURL = [NSURL URLWithString:obj];
               data.projectiveView = view;
               [datas addObject:data];
           } else {
               YBIBImageData *data = [YBIBImageData new];
               data.imageName = obj;
               data.projectiveView = view;
               [datas addObject:data];
           }
    }];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = index;
    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
    [browser reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
