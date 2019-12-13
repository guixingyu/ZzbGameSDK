//
//  BUDAdManager.m
//  BUDemo
//
//  Created by carlliu on 2017/7/27.
//  Copyright © 2017年 chenren. All rights reserved.
//

#import "BUDAdManager.h"
#import "BUDAViewController.h"
#import "ZzbRootNavViewController.h"
/**
 https://wiki.bytedance.net/pages/viewpage.action?pageId=146011735
 */

static NSString *APPID;
static BOOL showBUD;
static NSString *SplashId;
static NSString *BannerId;
static NSString *InterstitialId;
static NSString *RewardedVideoId;
@implementation BUDAdManager{

}

+(ZzbRootNavViewController*)createGameNavController {
    BUDAViewController *vc = [[BUDAViewController alloc] init];
    ZzbRootNavViewController *nav = [[ZzbRootNavViewController alloc] initWithRootViewController:vc];
    return nav;
}

+ (void)setAppKey:(NSString*)key {
    APPID = key;
}
+ (void)setShowBUD:(BOOL)bShow{
	showBUD =  bShow;
}

+ (void)setSplashId:(NSString*)slotId{
	SplashId =  slotId;
}
+ (void)setBannerId:(NSString*)slotId{
	BannerId =  slotId;
}
+ (void)setInterstitialId:(NSString*)slotId{
	InterstitialId =  slotId;
}

+ (void)setRewardedVideoId:(NSString*)slotId{
	RewardedVideoId =  slotId;
}

+ (NSString *)SplashId{
	return SplashId;
}
+ (NSString *)BannerId{
	return BannerId;
}
+ (NSString *)InterstitialId{
	return InterstitialId;
}
+ (NSString *)RewardedVideoId{
	return RewardedVideoId;
}

+ (NSString *)appKey {
    return APPID;
}
+ (BOOL)showBUD{
	return TRUE;
}
@end
