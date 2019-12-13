//
//  WAEWebAppViewController.h
//  webappexts
//
//  Created by Gen2 on 2019/1/17.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import "WAWebViewController.h"
#import "WAEImageView.h"
#import "WAEAnimationView.h"
#include "symbols.h"

NS_ASSUME_NONNULL_BEGIN

@class WAEAppControl;
@class WAEAppInfo;

typedef enum {
    LRTB
} WAEDirection;

typedef enum  {
    WAEUpdateTotal,
    WAEUpdateVersion,
    WAEUpdateWeak
} WAEUpdateType;

@interface WAEAnimatiton : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger spriteCount;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) WAEDirection direction;
@property (nonatomic, assign) CGSize cropSize;

@end

@interface WAEAppResponse : NSObject

/**
 * 标题
 */
@property (nonatomic, strong) NSString *title;
/**
 * 版本号
 */
@property (nonatomic, strong) NSString *version;
/**
 * 图标地址
 */
@property (nonatomic, strong) NSString *imageUrl;
/**
 * 增量更新根目录的地址
 */
@property (nonatomic, strong) NSString *url;
/**
 * zip下载地址
 */
@property (nonatomic, strong) NSString *zipUrl;
@property (nonatomic, strong) NSString *coverColor;
@property (nonatomic, strong) NSString *coverImage;

@property (nonatomic, strong) WAEAnimatiton *animation;

@end

typedef void (^WAEWebAppRequestCompleteBlock)(NSError * __nullable error, WAEAppResponse * __nullable info, WAEAppResponse * __nullable base);
typedef void (^WAEWebAppControlCompleteBlock)(NSError * __nullable error, WAEAppResponse * __nullable info);

@protocol WAEAppControlDelegate <NSObject>

- (void)appControlStartLoad:(WAEAppControl *)control;
- (void)appControlDid:(WAEAppControl *)control receiveInfo:(NSString *)imageURL;
- (void)appControlDid:(WAEAppControl *)control progress:(NSUInteger)progress total:(NSUInteger)total;
- (void)appControl:(WAEAppControl *)control processText:(NSString *)text;
- (void)appControlDidReady:(WAEAppControl *)control;
- (void)appControl:(WAEAppControl *)control didFail:(NSError *)error;
- (void)appControl:(WAEAppControl *)control session:(NSURLSession *)session requestApp:(NSString *)appID block:(WAEWebAppControlCompleteBlock)block;

@end

@interface WAEAppControl : NSObject

@property (nonatomic, readonly) WAEAppInfo *appInfo;
@property (nonatomic, readonly) NSURLSession *session;

@property (nonatomic, weak) id<WAEAppControlDelegate> delegate;

+ (WAEAppControl *)controlFromID:(NSString *)ID;
/**
 * 所有小程序信息
 */
+ (NSArray *)appsList;

- (void)forceUpdate;
- (BOOL)exist;
- (NSString *)path;
- (NSString *)iconPath;
/**
 * 清除小程序
 */
- (void)remove;

@end

@interface WAEWebAppViewController : WAWebViewController

@property (nonatomic, readonly) NSURLSession *session;

/**
 * @property defaultsID
 * 基础库ID，会自动执行基础库的下载操作.
 */
@property (nonatomic, strong) NSString *defaultsID;

/**
 * @property iconImage
 * 封面图片
 */
@property (nonatomic, strong) UIImage   *iconImage;

/**
 * @property appID
 * 需要传入appID，与workPath二选一即可，会自动执行小程序的下载操作.
 */
@property (nonatomic, strong) NSString *appID;

/**
 * 设置API服务器地址
 * 会以 URL/appID 这个链接去拉取数据。
 * @param url 服务器地址
 */
+ (void)setServerURL:(NSString *)url;

/**
 * 设置存放app的目录
 * app会放到这个目录下边
 * 如果不设置会使用 {Cache}/webapps
 * @param path 目录路径
 */
+ (void)setAppRootPath:(NSString *)path;

- (void)requestAppInfo:(NSString *)appID
                baseID:(NSString *)baseID
               session:(NSURLSession *)session
                 block:(WAEWebAppRequestCompleteBlock)block;

/**
 * 更新类型
 * 弱更新 情况下，如果有本地资源，不会先检查更新直接进入程序，后台检查，下次进入的时候才会更新。
 */
+ (void)setUpdateType:(WAEUpdateType)type;

+ (void)addExtension:(Class)clz;

- (void)checkForUpdate:(void(^)(BOOL))block;
- (void)applyUpdate;

@property (nonatomic, strong) WAEAnimationView *loadingView;
@property (nonatomic, readonly) UIButton *refreshButton;
@property (nonatomic, readonly) UIButton *closeButton;
@property (nonatomic, readonly) UILabel *progressLabel;
@property (nonatomic, readonly) UILabel *subtitleLabel;

@end

NS_ASSUME_NONNULL_END
