//
//  MHNativeView.h
//  webapp
//
//  Created by Gen2 on 2019/1/14.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAWebViewController.h"

@class WANativeView;

@protocol WANativeViewDelegate <NSObject>

- (void)nativeView:(WANativeView *)nativeView didSendEvent:(NSString *)name withData:(id)data withBlock:(WAWebExecuteBlock)block;

@end

@interface NSObject(WANativeView)

- (void)zIndexUpdate:(WANativeView *)view;

@end

typedef void(^WANativeViewBlock)(id);

@interface WANativeMethodItem : NSObject

@property (nonatomic, assign) BOOL staticMethod;
@property (nonatomic) SEL selector;
@property (nonatomic, strong) NSString *name;

@end

@interface WANativeView : UIView

@property (nonatomic, weak, readonly) WAWebViewController *webViewController;
@property (nonatomic, readonly) NSString *handlerID;
@property (nonatomic, strong) NSString  *viewID;
@property (nonatomic, assign) NSInteger zIndex;
@property (nonatomic, assign) BOOL      fixed;

@property (nonatomic, weak) id <WANativeViewDelegate> delegate;

/**
 * 注册可以被js调用的方法
 * @param method    监听方法
 * @param selector  监听回调 -sel:(NSArray*)params block:(MHNativeViewBlock)block
 */
+ (void)registerInstanceMethod:(NSString *)method selector:(SEL)selector;

+ (void)registerMethod:(NSString *)method selector:(SEL)selector;

/**
 * 获得注册的方法信息
 */
+ (NSDictionary<NSString*, WANativeMethodItem*> *)methods;

//- (NSArray<NSString *> *)methods;
//+ (NSArray<NSString *> *)methods;

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

- (void)sendEvent:(NSString *)eventName withData:(id)data withBlock:(WAWebExecuteBlock)block;

- (void)remove;

@end

@interface WANativeButton : UIButton

@end
