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
    
    NSArray *titles = @[@"百度",@"html",@"百度",@"html"];
    for (NSInteger i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(20, 100+i*50, 60, 30);
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gotoWebBrowser:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)gotoWebBrowser:(UIButton *)btn{
    LLWebViewController *webVC;
    if (btn.tag == 0) {
        webVC = [[LLWebViewController alloc] initWithUrl:@"http://www.baidu.com/"];
    }
    else{
        webVC = [[LLWebViewController alloc] initWithHtml:@"LLTest"];
    }
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
