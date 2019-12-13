//
//  DemoViewController.m
//  Project1
//
//  Created by Gen2 on 2019/7/11.
//  Copyright © 2019 Gen2. All rights reserved.
//

#import "DemoViewController.h"
#import "DemoPlugin.h"
#import "TestView.h"
#import <objc/runtime.h>
#import <BUAdSDK/BUSplashAdView.h>
#import <BUAdSDK/BUNativeExpressBannerView.h>
#import <BUAdSDK/BUNativeExpressInterstitialAd.h>
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>
#import "BUDMacros.h"
#import "BUDAdManager.h"
#import <BUAdSDK/BUSize.h>
#import "BUDNormalButton.h"

@interface DemoViewController ()<BUSplashAdDelegate, BUNativeExpressBannerViewDelegate, BUNativeExpresInterstitialAdDelegate, BURewardedVideoAdDelegate>

@property(nonatomic, strong) BUNativeExpressBannerView *bannerView;
@property (nonatomic, strong) BUNativeExpressInterstitialAd *interstitialAd;
@property (nonatomic, strong) BURewardedVideoAd *rewardedVideoAd;
@end

@implementation DemoViewController {
    IMP _oldImp;
    DemoPlugin *demo;
//    BOOL _closed;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self registerNativeView:TestView.class forType:@"test"];
    }

	self.interstitialAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:[BUDAdManager InterstitialId] imgSize:[BUSize sizeBy:BUProposalSize_Interstitial600_600] adSize:CGSizeMake(300, 450)];
	self.interstitialAd.delegate = self;
	[self.interstitialAd loadAdData];

	BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
	model.userId = @"123";
	self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:[BUDAdManager RewardedVideoId] rewardedVideoModel:model];
	self.rewardedVideoAd.delegate = self;
	[self.rewardedVideoAd loadAdData];
    return self;
}

- (void)initializePlugins {
    [super initializePlugins];
    demo = [DemoPlugin new];
	__weak DemoViewController *that = self;
	demo.showSplash = ^(){
		[that showSplash];
	};
	demo.showBanner = ^(){
		[that showBanner];
	};
	demo.showInterstitial = ^(){
		[that showInterstitial];
	};
	demo.showRewardedVideo = ^(){
		[that showRewardedVideo];
	};
	
	[self registerPlugin:demo];
}

- (void)showSplash{
	CGRect frame = [UIScreen mainScreen].bounds;
	BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:[BUDAdManager SplashId] frame:frame];
	splashView.delegate = self;
	UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
	[splashView loadAdData];
	[self.view addSubview:splashView];
}
- (void)splashAdWillClose:(BUSplashAdView *)splashAd {
	[demo responseHandle:TRUE id:@"123"];
}
- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    [splashAd removeFromSuperview];
}

- (void)showBanner{
	if (self.bannerView == nil) {
		CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
		CGFloat bannerHeigh = screenWidth/600*90;
		BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Banner600_150];
		self.bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:[BUDAdManager BannerId] rootViewController:self imgSize:imgSize adSize:CGSizeMake(screenWidth, bannerHeigh) IsSupportDeepLink:YES interval:30];
		self.bannerView.frame = CGRectMake(0, 0, screenWidth, bannerHeigh);
		self.bannerView.delegate = self;
		[self.view addSubview:self.bannerView];
	}
	[self.bannerView loadAdData];
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error {
	
}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {

}
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterwords {

    [UIView animateWithDuration:0.25 animations:^{
        bannerAdView.alpha = 0;
    } completion:^(BOOL finished) {
        [bannerAdView removeFromSuperview];
        if (self.bannerView == bannerAdView) {
            self.bannerView = nil;
        }
        if (self.bannerView == bannerAdView) {
            self.bannerView = nil;
        }
    }];
}

- (void)showInterstitial{
	[self.interstitialAd showAdFromRootViewController:self];
}

- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
}

- (void)nativeExpresInterstitialAdWillClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    [demo responseHandle:TRUE id:@"123"];
}

- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    [self.interstitialAd loadAdData];

}

- (void)showRewardedVideo{

	[self.rewardedVideoAd showAdFromRootViewController:self ritScene:BURitSceneType_home_get_bonus ritSceneDescribe:nil];
}
- (void)rewardedVideoAdWillClose:(BURewardedVideoAd *)rewardedVideoAd {
	[demo responseHandle:TRUE id:@"123"];
}
- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
     //BUD_Log(@"rewardedVideoAd video did close");
}
- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    
}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    Class clz = [UIApplication.sharedApplication.delegate class];
//    Method method = class_getInstanceMethod(clz, @selector(application:supportedInterfaceOrientationsForWindow:));
//    if (method) {
//        _oldImp = method_getImplementation(method);
//    }else {
//        struct objc_method_description m = protocol_getMethodDescription(@protocol(UIApplicationDelegate),
//                                      @selector(application:supportedInterfaceOrientationsForWindow:),
//                                      NO, YES);
//        _oldImp = imp_implementationWithBlock(^(id del, id app, id window) {
//            return UIInterfaceOrientationMaskPortrait;
//        });
//        class_addMethod(clz, @selector(application:supportedInterfaceOrientationsForWindow:), _oldImp, m.types);
//        method = class_getInstanceMethod(clz, @selector(application:supportedInterfaceOrientationsForWindow:));
//    }
//    method_setImplementation(method, imp_implementationWithBlock(^(id del, id app, id window){
//        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
//    }));
//}
//
//typedef UIInterfaceOrientationMask (*tIMP)(id obj, SEL sel, id app, id window);
//
//- (void)close {
//    Class clz = [UIApplication.sharedApplication.delegate class];
//    Method method = class_getInstanceMethod(clz, @selector(application:supportedInterfaceOrientationsForWindow:));
//
//    UIInterfaceOrientationMask mask = ((tIMP)_oldImp)(UIApplication.sharedApplication.delegate, @selector(application:supportedInterfaceOrientationsForWindow:), nil, nil);
//    if (mask == UIInterfaceOrientationMaskPortrait) {
//        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
//        [UIViewController attemptRotationToDeviceOrientation];
//    } else if (mask == UIInterfaceOrientationMaskLandscape) {
//        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
//        [UIViewController attemptRotationToDeviceOrientation];
//    }
//    [UIViewController attemptRotationToDeviceOrientation];
//    [super close];
//
//    method_setImplementation(method, _oldImp);
//}

@end
