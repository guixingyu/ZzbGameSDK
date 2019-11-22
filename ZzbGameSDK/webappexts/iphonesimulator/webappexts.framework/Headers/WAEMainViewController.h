//
//  WAppViewController.h
//  wapp
//
//  Created by Gen2 on 2019/7/4.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import "WAEWebAppViewController.h"
#include "symbols.h"

NS_ASSUME_NONNULL_BEGIN

@interface WAEMenuItem : NSObject

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) void(^block)(void);

@end

@interface WAEMainViewController : WAEWebAppViewController

/**
 * @p apiHost
 * 设置api主机地址
 */
@property (nonatomic, strong) NSString *apiHost;

/**
 * options.id 应用ID
 * options.key 应用Key
 */
+ (void)setup:(NSDictionary *)options;

@property (nonatomic, assign) BOOL closeButtonHidden;

@property (nonatomic, strong) NSArray<WAEMenuItem *> *menuItems;

/**
 * @param code 错误码
 * @param words  本地化配置
 * @param {NSString*} words.hans 简体字
 * @param {NSString*} words.hant 繁体字
 * @param {NSString*} words.en 英文
 */
+ (void)setLocalizedErrorCode:(NSInteger)code withWords:(NSDictionary *)words;

- (instancetype)openWebApp:(NSString *)appID params:(NSDictionary *)params;

+ (WAEMainViewController *)dequeueController:(NSString *)appID;

@end

NS_ASSUME_NONNULL_END
