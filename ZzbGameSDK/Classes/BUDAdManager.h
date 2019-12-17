//
//  BUAdManager.h
//  BUDemo
//
//  Created by carlliu on 2017/7/27.
//  Copyright © 2017年 chenren. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BUDAdManager : NSObject
+ (UINavigationController*)createGameNavController;
+ (void)setAppKey:(NSString*)key;
+ (void)setShowBUD:(BOOL)bShow;

+ (void)setSplashId:(NSString*)slotId; //设置开屏广告id
+ (void)setBannerId:(NSString*)slotId; //设置banna广告id
+ (void)setInterstitialId:(NSString*)slotId; //设置插屏广告id
+ (void)setRewardedVideoId:(NSString*)slotId; //设置激励视频广告id

+ (NSString *)appKey;
+ (BOOL)showBUD;
+ (NSString *)SplashId;
+ (NSString *)BannerId;
+ (NSString *)InterstitialId;
+ (NSString *)RewardedVideoId;
@end
