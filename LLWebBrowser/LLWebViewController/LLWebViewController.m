//
//  LLWebViewController.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/11/21.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLWebViewController.h"
#import "LLWebProgressLayer.h"

typedef enum : NSUInteger {
    LLWebLoadTypeNormal      = 0, //加载普通网页
    LLWebLoadTypeLocalHtml,       //加载本地html
} LLWebLoadType;
@interface LLWebViewController ()<UIWebViewDelegate>{
    UIWebView          *_webBrowser;
    NSString           *_htmlCont;
    NSURL              *_baseURL;
    NSURLRequest       *_request;
    LLWebProgressLayer *_progressLayer;
    LLWebLoadType      _loadType;
    UIView             *_containerView;
}
@end

#define NAVBAR_HEIGHT  64
#define NON_NAV_HEIGHT (SCREEN_HEIGHT-NAVBAR_HEIGHT)
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
@implementation LLWebViewController

#pragma mark - 加载普通网页
/* 自定义Frame */
- (id)initWithFrame:(CGRect)frame url:(NSString *)url title:(NSString *)title {
    self = [super init];
    if (self) {
        _containerView = [[UIView alloc] initWithFrame:frame];
        [self setTitle:title url:url];
    }
    return self;
}

/*  默认Frame  */
- (id)initWithUrl:(NSString *)url title:(NSString *)title {
    self = [super init];
    if (self) {
        _containerView = [[UIView alloc] init];
        _containerView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, NON_NAV_HEIGHT);
        [self setTitle:title url:url];
    }
    return self;
}

#pragma mark - 加载本地html页面
/* 自定义Frame */
- (id)initWithFrame:(CGRect)frame htmlFileName:(NSString *)htmlFileName title:(NSString *)title {
    self = [super init];
    if (self) {
        _containerView = [[UIView alloc] initWithFrame:frame];
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:htmlFileName
                                                              ofType:@"html"];
        [self setTitle:title htmlPath:htmlPath];
    }
    return self;
}

/*  默认Frame  */
- (id)initWithHtmlFileName:(NSString *)htmlFileName title:(NSString *)title {
    self = [super init];
    if (self) {
        _containerView = [[UIView alloc] init];
        _containerView.frame = CGRectMake(0, 64, SCREEN_WIDTH, NON_NAV_HEIGHT);
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:htmlFileName
                                                             ofType:@"html"];
        [self setTitle:title htmlPath:htmlPath];
    }
    return self;
}

#pragma mark - private 属性赋值，url、路径处理等
- (void)setTitle:(NSString *)title url:(NSString *)url{
    _loadType = LLWebLoadTypeNormal;
    self.title = NSLocalizedString(title,nil);
    
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:URL];
    _request = [self handlingRequest:request];
}

- (void)setTitle:(NSString *)title htmlPath:(NSString *)htmlPath{
    _loadType = LLWebLoadTypeLocalHtml;
    self.title = NSLocalizedString(title,nil);
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    _baseURL = [NSURL fileURLWithPath:path];
    _htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                          encoding:NSUTF8StringEncoding
                                             error:nil];
}
#pragma mark

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_containerView];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)createViews{
    
    NSString *imageNamedString = @"web_load_icon";
    UIImage *reloaddImage = [[UIImage imageNamed:imageNamedString] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *loadItem = [[UIBarButtonItem alloc] initWithImage:[reloaddImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(LLRightBtnItemClick:)];
    self.navigationItem.rightBarButtonItem = loadItem;
    
    _progressLayer = [[LLWebProgressLayer alloc] init];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    
    _webBrowser = [[UIWebView alloc] initWithFrame:_containerView.bounds];
    _webBrowser.scalesPageToFit = YES;
    _webBrowser.delegate = self;
    [_containerView addSubview:_webBrowser];
    
    if (_loadType == LLWebLoadTypeNormal) {
        [_webBrowser loadRequest:_request];
    }
    else{
        [_webBrowser loadHTMLString:_htmlCont baseURL:_baseURL];
    }
}

#pragma mark - 导航栏右侧刷新按钮
- (void)LLRightBtnItemClick:(UIButton *)rightBtn{
    [self reload];
}

- (void)reload{
    if (_loadType == LLWebLoadTypeNormal) {
        [_webBrowser loadRequest:_request];
    }
    else{
        [_webBrowser loadHTMLString:_htmlCont baseURL:_baseURL];
    }
}

#pragma mark - 处理请求头、参数等
- (NSURLRequest *)handlingRequest:(NSMutableURLRequest *)request{
    //此处设置所需要的请求头格式
    return [request copy];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //设置从网页返回的标题
    //self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [_progressLayer finishedLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"请求失败：%@",error);
    [_progressLayer finishedLoad];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    
    NSLog(@"拦截请求：%@",requestString);
    
    return YES;
}
#pragma mark

- (void)dealloc {
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
