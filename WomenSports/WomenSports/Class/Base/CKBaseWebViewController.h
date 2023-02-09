//
//  CKBaseWebViewController.h
//  CloudKind
//
//  Created by kckj on 2021/5/14.
//

#import "WSBaseController.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CKBaseWebViewController : WSBaseController<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *stringUrl;

- (instancetype)initWithTitle:(NSString *)stringTitle;

@end

NS_ASSUME_NONNULL_END
