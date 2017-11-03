//
//  LLWebViewController.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/2.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLWebViewController.h"
#import "LLWebProgressLayer.h"
#import <WebKit/WebKit.h>

@interface LLWebViewController ()<WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate>

@property (nonatomic, strong) WKWebView *webView_WK;
@property (nonatomic, strong) UIWebView *webView_UI;
@property (nonatomic, strong) LLWebProgressLayer *progressLayer;

@end

@implementation LLWebViewController {
    NSString *_url;
    BOOL     _isWKWebView;
    CGRect   _frame;
}

#pragma mark - init
- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _frame = LLRectBottomArea();
        _url = url;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url {
    self = [super init];
    if (self) {
        if (CGRectIsNull(frame)) {
            _frame = LLRectBottomArea();
        }
        else {
            _frame = frame;
        }
        _url = url;
    }
    return self;
}

- (id)initWithHtml:(NSString *)html {
    self = [super init];
    if (self) {
        _frame = LLRectBottomArea();
        _url = [[NSBundle mainBundle] pathForResource:html ofType:@"html"];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame html:(NSString *)html {
    self = [super init];
    if (self) {
        if (CGRectIsNull(frame)) {
            _frame = LLRectBottomArea();
        }
        else {
            _frame = frame;
        }
        _url = [[NSBundle mainBundle] pathForResource:html ofType:@"html"];
    }
    return self;
}

#pragma mark - lazy load
- (WKWebView *)webView_WK {
    if (_webView_WK == nil) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.preferences = [WKPreferences new];
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        
        _webView_WK = [[WKWebView alloc]initWithFrame:_frame configuration:config];
        _webView_WK.navigationDelegate = self;
        _webView_WK.UIDelegate = self;
        [self.view addSubview:_webView_WK];
        
        [self addObserver];
    }
    return _webView_WK;
}

- (UIWebView *)webView_UI {
    if (_webView_UI == nil) {
        _webView_UI = [[UIWebView alloc] initWithFrame:_frame];
        _webView_UI.scalesPageToFit = YES;
        _webView_UI.delegate = self;
        [self.view addSubview:_webView_UI];
    }
    return _webView_UI;
}

- (LLWebProgressLayer *)progressLayer {
    if (_progressLayer == nil) {
        _progressLayer = [[LLWebProgressLayer alloc] init];
        _progressLayer.frame = CGRectMake(0, 42, [UIScreen mainScreen].bounds.size.width, 2);
    }
    return _progressLayer;
}

#pragma mark - life cyclic
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.loadType == LLWebViewLoadTypeAuto) {
        _isWKWebView = ([UIDevice currentDevice].systemVersion.floatValue >= 8.0);
    }
    else if (self.loadType == LLWebViewLoadTypeUIWebView) {
        _isWKWebView = NO;
    }
    else {
        _isWKWebView = YES;
    }
    
    [self loadUrl:_url];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.layer addSublayer:self.progressLayer];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressLayer removeFromSuperlayer];
}

#pragma mark - public method
- (void)loadUrl:(NSString *)url {
    NSURLRequest *request = [self handlingUrl:_url];
    if (_isWKWebView) {
        [self.webView_WK loadRequest:request];
    }
    else {
        [self.webView_UI loadRequest:request];
    }
}

- (void)reload{
    if (_isWKWebView) {
        [self.webView_WK reload];
    }
    else {
        [self.webView_UI reload];
    }
}

- (void)webGoback {
    
    if (_isWKWebView) {
        if (self.webView_WK.canGoBack) {
            [self.webView_WK goBack];
            return;
        }
    }
    else {
        if (self.webView_UI.canGoBack) {
            [self.webView_UI goBack];
            return;
        }
    }
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - pravite method
- (NSURLRequest *)handlingUrl:(NSString *)url {
    NSURL *URL;
    if ([[NSFileManager defaultManager] fileExistsAtPath:url]) {
        URL = [NSURL fileURLWithPath:url];
    }
    else {
        URL = [NSURL URLWithString:url];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    return [self handlingRequest:request];
}

//处理请求头、参数等
- (NSURLRequest *)handlingRequest:(NSMutableURLRequest *)request {
    
    return [request copy];
}

// 添加KVO监听
- (void)addObserver {
    
    [_webView_WK addObserver:self
                  forKeyPath:@"loading"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    
    [_webView_WK addObserver:self
                  forKeyPath:@"title"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    
    [_webView_WK addObserver:self
                  forKeyPath:@"estimatedProgress"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
}

// webView默认frame
CGRect LLRectBottomArea() {
    CGRect rect = [UIScreen mainScreen].bounds;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && rect.size.height == 812) {
        rect.origin.y = 88;
        rect.size.height = rect.size.height-122;
    }
    else {
        rect.origin.y = 64;
        rect.size.height = rect.size.height-64;
    }
    return rect;
}

// 移除KVO监听
- (void)removeObserver {
    [_webView_WK removeObserver:self forKeyPath:@"loading"];
    [_webView_WK removeObserver:self forKeyPath:@"title"];
    [_webView_WK removeObserver:self forKeyPath:@"estimatedProgress"];
}

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading...");
    }
    else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView_WK.title;
    }
    else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"progress: %f", self.webView_WK.estimatedProgress);
    }
    // 加载完成
    if (self.webView_WK.loading == NO) {
        /*
         //手动调用JS代码
         [self.webView_WK evaluateJavaScript:@"" completionHandler:^(id _Nullable response, NSError * _Nullable error) {}];
         */
        [self.progressLayer finishedLoad];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    NSString *word = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([word hasPrefix:@"app"]) {
        NSString *script = [NSString stringWithFormat:@"LLAlert('%@')",word];
        [self stringByEvaluatingJavaScriptFromString:script];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.progressLayer finishedLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.progressLayer finishedLoad];
}

#pragma mark - WKNavigationDelegate
// 请求开始前，会先调用此代理方法
//- (BOOL)webView:shouldStartLoadWithRequest:navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request = navigationAction.request;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated &&
        [request.URL.host.lowercaseString containsString:@"我是跨域标识符"]) {
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        NSString *word = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([word hasPrefix:@"app"]) {
            NSString *script = [NSString stringWithFormat:@"LLAlert('%@')",word];
            [self stringByEvaluatingJavaScriptFromString:script];
        }
        else {
            [self.progressLayer startLoad];
        }
        
        //允许web内跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 在响应完成时，会回调此方法
// 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 开始导航跳转时会回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

// 页面内容到达main frame时回调
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
}

#pragma mark - WKUIDelegate
//需要打开新界面时
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
//会拦截到window.open()事件.
//只需要我们在在方法内进行处理
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView {
    
}

// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - 注入JS
/** 以文件的方式注入JS */
- (void)resgisterJSWithResource:(NSString *)resource ofType:(NSString *)type {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:resource ofType:type];
    NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (_isWKWebView) {
        [self.webView_WK evaluateJavaScript:script completionHandler:nil];
    }
    else {
        [self.webView_UI stringByEvaluatingJavaScriptFromString:script];
    }
}

/** 以字符串的方式注入JS */
- (void)stringByEvaluatingJavaScriptFromString:(NSString *)script {
    if (_isWKWebView) {
        [self.webView_WK evaluateJavaScript:script completionHandler:nil];
    }
    else {
        [self.webView_UI stringByEvaluatingJavaScriptFromString:script];
    }
}

- (void)dealloc {
    NSLog(@"webVC释放");
    [self removeObserver];
}

@end
