//
//  LLWebViewController.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/11/21.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLWebViewController : UIViewController

//加载普通网页
- (id)initWithFrame:(CGRect)frame url:(NSString *)url title:(NSString *)title;
- (id)initWithUrl:(NSString *)url title:(NSString *)title;

//加载本地html页面
- (id)initWithFrame:(CGRect)frame htmlFileName:(NSString *)htmlFileName title:(NSString *)title;
- (id)initWithHtmlFileName:(NSString *)htmlFileName title:(NSString *)title;

//刷新
- (void)reload;

@end
