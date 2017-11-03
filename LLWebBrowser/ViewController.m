//
//  ViewController.m
//  LLWebBrowser
//
//  Created by Mr.Wang on 16/12/22.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "LLWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[@"根据iOS版本，选择合适的webview加载：百度",
                        @"根据iOS版本，选择合适的webview加载：html",
                        @"强制使用UIWebView加载：百度",
                        @"强制使用UIWebView加载：html"];
    for (NSInteger i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(0, 100+i*50, [UIScreen mainScreen].bounds.size.width, 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gotoWebBrowser:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)gotoWebBrowser:(UIButton *)btn{
    LLWebViewController *webVC;
    if (btn.tag == 0) {
        webVC = [[LLWebViewController alloc] initWithUrl:@"http://www.baidu.com/"];
    }
    else if (btn.tag == 1) {
        webVC = [[LLWebViewController alloc] initWithHtml:@"LLTest"];
    }
    else if (btn.tag == 2) {
        webVC = [[LLWebViewController alloc] initWithUrl:@"http://www.baidu.com/"];
        webVC.loadType = LLWebViewLoadTypeUIWebView;
    }
    else {
        webVC = [[LLWebViewController alloc] initWithHtml:@"LLTest"];
        webVC.loadType = LLWebViewLoadTypeUIWebView;
    }
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
