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
    LLWebViewLoadTypeAuto         = 0,//iOS 8.0+使用WKWebView加载，iOS8.0之前使用UIWebView加载
    LLWebViewLoadTypeUIWebView,       //强制使用UIWebView加载
    LLWebViewLoadTypeWKWebView,       //强制使用WKWebView加载
} LLWebViewLoadType;

@interface LLWebViewController : UIViewController

@property (nonatomic, assign) LLWebViewLoadType loadType;

//加载网页
- (instancetype)initWithUrl:(NSString *)url;
- (instancetype)initWithFrame:(CGRect)frame url:(NSString *)url;

//加载html
- (id)initWithHtml:(NSString *)html;
- (id)initWithFrame:(CGRect)frame html:(NSString *)html;

- (void)reload;
- (void)webGoback;
- (void)loadUrl:(NSString *)url;

@end
