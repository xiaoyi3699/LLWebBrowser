//
//  LLUserContentController.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/5/27.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <WebKit/WebKit.h>
@protocol LLScriptMessageHandler;

@interface LLUserContentController : WKUserContentController

@property (nonatomic, weak) id<LLScriptMessageHandler> delegate;

- (void)addScriptMessageHandler:(NSArray *)scriptNames;
- (void)removeScriptMessageHandler:(NSArray *)scriptNames;

@end

@protocol LLScriptMessageHandler <NSObject>

@optional
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end
