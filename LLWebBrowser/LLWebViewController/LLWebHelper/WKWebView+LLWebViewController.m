//
//  WKWebView+LLWebViewController.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/10/17.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WKWebView+LLWebViewController.h"
#import "LLWebHelper.h"

@implementation WKWebView (LLWebViewController)

- (void)webVC_loadUrl:(NSString *)url {
    [self loadRequest:[LLWebHelper handlingUrl:url]];
}

@end
