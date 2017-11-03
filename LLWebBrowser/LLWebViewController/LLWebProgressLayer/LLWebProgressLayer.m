//
//  LLWebProgressLayer.m
//  LLFoundation
//
//  Created by Mr.Wang on 16/12/8.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLWebProgressLayer.h"

static NSTimeInterval const LLFastTimeInterval = 0.01;

@implementation LLWebProgressLayer{
    CAShapeLayer *_layer;
    NSTimer *_timer;
    NSTimeInterval _loadTime;
}

- (id)init {
    self = [super init];
    if (self) {
        self.lineWidth = 2;
        self.strokeColor = [UIColor blueColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 2)];
        [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, 2)];
        
        self.path = path.CGPath;
        self.strokeEnd = 0;
    }
    return self;
}

//开始加载动画
- (void)startLoad {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _loadTime = 0.0;
    [self LL_SetStrokeEnd:0];
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:LLFastTimeInterval
                                                  target:self
                                                selector:@selector(pathChanged:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)pathChanged:(NSTimer *)timer {
    if (self.strokeEnd < 0.8) {
        self.strokeEnd += 0.01;
    }
    else if (self.strokeEnd < 0.95){
        self.strokeEnd += 0.002;
    }
    _loadTime += LLFastTimeInterval;
}

//结束加载动画
- (void)finishedLoad {
    if (_loadTime < 0.35) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.25*NSEC_PER_SEC)),
                       dispatch_get_main_queue(),^{
                           [self finished];
                       });
    }
    else{
        [self finished];
    }
}

- (void)finished{
    [self closeTimer];
    self.strokeEnd = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.25*NSEC_PER_SEC)),
                   dispatch_get_main_queue(),^{
                       [self LL_SetStrokeEnd:0];
                   });
}

- (void)closeTimer {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

//无动画
- (void)LL_SetStrokeEnd:(CGFloat)strokeEnd{
    if (strokeEnd < self.strokeEnd) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.strokeEnd = strokeEnd;
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }
}

- (void)removeFromSuperlayer{
    [self closeTimer];
    [self LL_SetStrokeEnd:0];
    [super removeFromSuperlayer];
}

@end
