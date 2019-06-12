//
//  LLWebViewController.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/2.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

///加载方式
typedef enum : NSInteger {
    LLWebViewLoadTypeAuto         = 0,
    LLWebViewLoadTypeUIWebView,
    LLWebViewLoadTypeWKWebView,
} LLWebViewLoadType;

@interface LLWebViewController : UIViewController

@property (nonatomic, assign) LLWebViewLoadType loadType;

//加载网页
- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url;

//加载本地html
- (id)initWithHtml:(NSString *)html;
- (id)initWithFrame:(CGRect)frame html:(NSString *)html;

- (void)reload;
- (void)webGoback;
- (void)loadUrl:(NSString *)url;

//注入JS
- (void)stringByEvaluatingJavaScriptFromString:(NSString *)script;
- (void)registerJSWithResource:(NSString *)resource ofType:(NSString *)type;

@end
