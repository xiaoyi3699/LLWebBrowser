//
//  LLWebHelper.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/10/17.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLWebHelper.h"

@implementation LLWebHelper

+ (NSURLRequest *)handlingUrl:(NSString *)url {
    NSURL *URL;
    if ([[NSFileManager defaultManager] fileExistsAtPath:url]) {
        URL = [NSURL fileURLWithPath:url];
    }
    else {
        URL = [NSURL URLWithString:url];
        
        if (URL == nil) {
            URL = [NSURL URLWithString:[self ll_URLEncodedString:url]];
        }
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    return [self handlingRequest:request];
}

+ (NSURLRequest *)handlingRequest:(NSMutableURLRequest *)request {
    return [request copy];
}

+ (NSString *)ll_URLEncodedString:(NSString *)str {
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
