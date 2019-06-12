//
//  LLWebHelper.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/10/17.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLWebHelper : NSObject

+ (NSURLRequest *)handlingUrl:(NSString *)url;

+ (NSURLRequest *)handlingRequest:(NSMutableURLRequest *)request;

@end
