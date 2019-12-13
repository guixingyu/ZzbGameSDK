//
//  MHWebViewController.h
//  webapps
//
//  Created by Gen2 on 2018/12/27.
//  Copyright © 2018 Gen2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "symbols.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^WAWebPluginBlock)(id _Nullable output);
typedef id _Nullable (^WAWebExecuteBlock)(id _Nullable result, NSError * _Nullable error);

typedef NS_ENUM(NSUInteger, WAWindowFeature) {
    WAWindowFeatureFullscreen       = 1,
    WAWindowFeatureNoFullscreen     = 1 << 1,
    WAWindowFeaturePortrait         = 1 << 2,
    WAWindowFeatureLandspace        = 1 << 3,
    WAWindowFeatureRotate           = 1 << 4,
    WAWindowFeatureLightStatusBar   = 1 << 5,
    WAWindowFeatureDarkStatusBar    = 1 << 6,
    WAWindowFeatureGestureEnable    = 1 << 7,
    WAWindowFeatureGestureDisable   = 1 << 8,
};

@class WAWebPlugin;
@class WAContainer;

@class WAWebViewController;

FOUNDATION_EXPORT NSString * const WAWebViewControllerResizeEvent;

#pragma mark -  Unity Extension

typedef void(^WAUnityMethodBlock)(NSArray * _Nullable params, WAWebPluginBlock _Nullable block);

@interface WAUnityObject : NSObject

/**
 * 构造函数
 * @param params {NSArray*} 构造参数
 */
- (id)initWithParams:(NSArray * _Nullable)params;

/**
 * 注册对象方法
 */
- (void)registerMethod:(WAUnityMethodBlock)block forKey:(NSString *)key;

/**
 * 注册静态方法
 */
+ (void)registerMethod:(WAUnityMethodBlock)block forKey:(NSString *)key;

/**
 * 向小程序发送消息
 */
- (void)sendEvent:(NSString *)type params:(NSArray *)params block:(WAWebExecuteBlock _Nullable)block;\

- (WAWebViewController *)webViewController;

/**
 * 摧毁对象
 */
- (void)destroy;

/**
 * 生命周期
 */
- (void)ready;
- (void)unload;
- (void)onShow;
- (void)onHide;

@property (nonatomic, readonly) NSString *key;

@end


#pragma mark - Plugin

@protocol WAWebPluginControl

- (void)registerPlugin:(WAWebPlugin *)plugin;
- (void)execute:(NSString * _Nullable)name content:(id _Nullable)content block:(WAWebExecuteBlock _Nullable)block;

@end

@protocol WAWebViewControllerDelegate <NSObject>

- (void)webViewControllerClosed:(WAWebViewController *)ctrl;
- (void)webViewControllerReady:(WAWebViewController *)ctrl;

@end

@interface WAWebPlugin : NSObject

@property (nonatomic, weak, readonly) WAWebViewController *webViewController;
@property (nonatomic, weak, readonly) id<WAWebPluginControl> control;
@property (nonatomic, readonly) NSString *name;

/**
 * @param name 插件名，作为js调用的标识
 */
- (id)initWithName:(NSString *)name;

/**
 * 必须重载，当被js所调用时发生
 * @param input 输入参数
 * @param block 处理结束后调用
 */
- (void)process:(id)input block:(WAWebPluginBlock)block;

/**
 * 可以被重载, 当webView准备好后发生
 */
- (void)ready;

- (void)load;
- (void)unload;

- (void)onHide;
- (void)onShow;

- (void)onRedirect;

@end

/**
 * 作为入口的viewcontroller
 * 实现如下功能:
 *      - webView与原生的交互
 *      - plugin模块，方便扩展
 *      - native view模块，可以把html标签在原生程序中实现
 */
@interface WAWebViewController : UIViewController <WAWebPluginControl>

/**
 * webView
 */
@property (nonatomic, readonly) WAContainer *container;

/**
 * 覆盖于webView之上的一个遮罩，会在完成加载时fadeOut.
 */
@property (nonatomic, readonly) UIView      *coverView;
/**
 * 原生界面层
 */
@property (nonatomic, readonly) UIView      *nativeView;

/**
 * 原生背景层
 */
@property (nonatomic, readonly) UIView      *bgNativeView;

/**
 * 基础库位置
 */
@property (nonatomic, strong) NSURL     *defaultsURL;
/**
 * 小程序目录的路径
 */
@property (nonatomic, strong) NSURL     *workURL;

@property (nonatomic, readonly) NSURL   *currentURL;

/**
 * 已经注册的插件
 */
@property (nonatomic, readonly) NSArray<WAWebPlugin*>   *plugins;

@property (nonatomic, readonly) NSString    *templatePath;

@property (nonatomic, readonly) NSString    *appIdentifier;
@property (nonatomic, readonly) NSString    *appFilesDir;

@property (nonatomic, strong) NSString *workSKey;

@property (nonatomic, weak) id<WAWebViewControllerDelegate> delegate;

/**
 * 初始化参数
 */
@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, readonly) BOOL    isClosed;

- (NSString *)realPath:(NSString *)path;
- (NSString *)hrefPath:(NSString *)path;

/**
 * 注册插件
 * @param plugin 插件
 */
- (void)registerPlugin:(WAWebPlugin *)plugin;

- (__kindof WAWebPlugin *)findPlugin:(NSString *)name;

/**
 * 执行js代码，如果js中handle的消息
 * @param name      handle的目标
 * @param content   传递参数
 * @param block     调用成功后的返回
 */
- (void)execute:(NSString * _Nullable)name content:(id _Nullable)content block:(WAWebExecuteBlock _Nullable)block;

/**
 * 可被重载，当加载完成时发生
 */
- (void)loadComplete;

/**
 * 注册一个原生界面
 * @param viewClass 原生界面的类，必须是 WANativeView 的子类
 * @param type      这个原生界面所对应的类型
 */
- (void)registerNativeView:(Class)viewClass forType:(NSString *)type;

- (Class)findNativeView:(NSString *)type;

- (void)registerObject:(id)object forKey:(NSString *)key;

- (void)processConfig:(NSDictionary *)configs;

- (void)close;

- (void)onRotateToLandscape;

- (void)requireWindowFeature:(WAWindowFeature)feature;

- (void)onLoadFailed:(NSString *)msg;

- (UIViewController * __nullable)openURL:(NSURL *)url;

+ (NSString *)version;

/**
 * 删除缓存数据
 * @param name  appID或者是本地目录名
 */
+ (void)clearCacheData:(NSString *)name;
+ (void)clearAllCacheData;

- (void)addEventListener:(NSString *)name target:(id)target selector:(SEL)selector;
- (void)removeEventListener:(NSString *)name target:(id)target selector:(SEL)selector;

@end

@class WKWebView;

@interface WAWebViewController (Plugins)

/**
 * 可被重载，用于注册所有插件。
 */
- (void)initializePlugins;

- (void)initializePluginsForAddOn:(id<WAWebPluginControl>)ctrl;

@end

NS_ASSUME_NONNULL_END
