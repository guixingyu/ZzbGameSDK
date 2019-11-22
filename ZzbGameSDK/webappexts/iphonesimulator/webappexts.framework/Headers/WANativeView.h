//
//  MHNativeView.h
//  webapp
//
//  Created by Gen2 on 2019/1/14.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAWebViewController.h"

typedef void(^WANativeViewBlock)(id);

@interface WANativeView : UIView

@property (nonatomic, weak, readonly) WAWebViewController *webViewController;
@property (nonatomic, readonly) NSString *handlerID;
@property (nonatomic, assign) NSInteger zIndex;
@property (nonatomic, strong) NSString *viewID;

/**
 * 注册可以被js调用的方法
 * @param method    监听方法
 * @param selector  监听回调 -sel:(NSArray*)params block:(MHNativeViewBlock)block
 */
- (void)registerMethod:(NSString *)method selector:(SEL)selector;

+ (void)registerMethod:(NSString *)method selector:(SEL)selector;

- (NSArray<NSString *> *)methods;
+ (NSArray<NSString *> *)methods;

- (void)setFrameRect:(NSDictionary *)rect;

- (void)updateFrameRect:(NSDictionary *)rect animated:(BOOL)animated;
- (void)updateFrame;

/**
 * 初始化方法
 * @param params 初始化参数
 */
- (void)onInitialize:(NSDictionary *)params;

/**
 * 摧毁view
 * 需要使用 removeFromSuperview 把自身移除
 */
- (void)onDestroy;

/**
 * 对js脚本发送信息
 * @param data  信息参数
 * @param block 回调
 */
- (void)sendEvent:(NSDictionary *)data block:(WAWebExecuteBlock)block;

@end
