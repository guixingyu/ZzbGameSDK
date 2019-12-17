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
//#import <BUAdSDK/BUSplashAdView.h>
//#import <BUAdSDK/BUNativeExpressBannerView.h>
//#import <BUAdSDK/BUNativeExpressInterstitialAd.h>
//#import <BUAdSDK/BURewardedVideoAd.h>
//#import <BUAdSDK/BURewardedVideoModel.h>
//#import "BUDMacros.h"
//#import "BUDAdManager.h"
//#import <BUAdSDK/BUSize.h>
//#import "BUDNormalButton.h"
//#import "AFHTTPSessionManager.h"
//#import "ReqPacker.h"
//#import "ZzbDefine.h"

//@implementation LogModel
//@end

@interface DemoViewController ()
@property(nonatomic,assign)NSInteger appletId;
//@interface DemoViewController ()<BUSplashAdDelegate, BUNativeExpressBannerViewDelegate, BUNativeExpresInterstitialAdDelegate, BURewardedVideoAdDelegate>
//
//@property(nonatomic, strong) BUNativeExpressBannerView *bannerView;
//@property (nonatomic, strong) BUNativeExpressInterstitialAd *interstitialAd;
//@property (nonatomic, strong) BURewardedVideoAd *rewardedVideoAd;
@end

@implementation DemoViewController {
    IMP _oldImp;
    DemoPlugin *demo;
    //NSInteger _appletId;
//    BOOL _closed;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self registerNativeView:TestView.class forType:@"test"];
    }
    /*
	self.interstitialAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:[BUDAdManager InterstitialId] imgSize:[BUSize sizeBy:BUProposalSize_Interstitial600_600] adSize:CGSizeMake(300, 450)];
	self.interstitialAd.delegate = self;
	[self.interstitialAd loadAdData];

	BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
	model.userId = @"123";
	self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:[BUDAdManager RewardedVideoId] rewardedVideoModel:model];
	self.rewardedVideoAd.delegate = self;
	[self.rewardedVideoAd loadAdData];*/
    return self;
}

- (void)initializePlugins {
    [super initializePlugins];
    demo = [DemoPlugin new];
    /*
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
	};*/
	
	[self registerPlugin:demo];
}

- (void)setAppletId:(NSInteger)appletId {
	_appletId = appletId;
}

//- (void)showSplash{
//	CGRect frame = [UIScreen mainScreen].bounds;
//	BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:[BUDAdManager SplashId] frame:frame];
//	splashView.delegate = self;
//	//UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
//	[splashView loadAdData];
//	[self.view addSubview:splashView];
//}

//- (void)splashAdWillVisible:(BUSplashAdView *)splashAd {
//	NSInteger positionid = [[BUDAdManager SplashId] intValue];
//	[self postAdvertisingInfo:_appletId positionid:positionid opType:1];
//}

//- (void)splashAdDidClick:(BUSplashAdView *)splashAd {
//	[demo responseHandle:TRUE id:@"123"];
//	NSInteger positionid = [[BUDAdManager SplashId] intValue];
//	[self postAdvertisingInfo:_appletId positionid:positionid opType:2];
//}
//- (void)splashAdWillClose:(BUSplashAdView *)splashAd {
//	[demo responseHandle:FALSE id:@"123"];
//}
//- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
//    [splashAd removeFromSuperview];
//}

//- (void)showBanner{
//	if (self.bannerView == nil) {
//		CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
//		CGFloat bannerHeigh = screenWidth/600*90;
//		BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Banner600_150];
//		self.bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:[BUDAdManager BannerId] rootViewController:self imgSize:imgSize adSize:CGSizeMake(screenWidth, bannerHeigh) IsSupportDeepLink:YES interval:30];
//		self.bannerView.frame = CGRectMake(0, 50, screenWidth, bannerHeigh);
//		self.bannerView.delegate = self;
//		[self.view addSubview:self.bannerView];
//	}
//	[self.bannerView loadAdData];
////	[demo responseHandle:TRUE id:@"123"];
//}

//- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error {
//
//}
//- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {
//	NSInteger positionid = [[BUDAdManager BannerId] intValue];
//	[self postAdvertisingInfo:_appletId positionid:positionid opType:1];
//}
//- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView{
//
//}
//- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
//	[demo responseHandle:TRUE id:@"123"];
//
//	NSInteger positionid = [[BUDAdManager BannerId] intValue];
//	[self postAdvertisingInfo:_appletId positionid:positionid opType:2];
//}

//- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterwords {
//	[demo responseHandle:FALSE id:@"123"];
//    [UIView animateWithDuration:0.25 animations:^{
//        bannerAdView.alpha = 0;
//    } completion:^(BOOL finished) {
//        [bannerAdView removeFromSuperview];
//        if (self.bannerView == bannerAdView) {
//            self.bannerView = nil;
//        }
//        if (self.bannerView == bannerAdView) {
//            self.bannerView = nil;
//        }
//    }];
//}

//- (void)showInterstitial{
//	if (self.interstitialAd.isAdValid){
//		[self.interstitialAd showAdFromRootViewController:self];
//	}
//	else{
//		[demo responseHandle:FALSE id:@"123"];
//		[self.interstitialAd loadAdData];
//	}
//}
//- (void)nativeExpresInterstitialAdRenderSuccess:(BUNativeExpressInterstitialAd *)interstitialAd {
//	NSInteger positionid = [[BUDAdManager InterstitialId] intValue];
//	[self postAdvertisingInfo:_appletId positionid:positionid opType:1];
//}

//- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
//	//[demo responseHandle:TRUE id:@"123"];
//	NSInteger positionid = [[BUDAdManager InterstitialId] intValue];
//	[self postAdvertisingInfo:_appletId positionid:positionid opType:2];
//
//}

//- (void)nativeExpresInterstitialAdWillClose:(BUNativeExpressInterstitialAd *)interstitialAd {
//	[demo responseHandle:FALSE id:@"123"];
//}

//- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {
//
//}

//- (void)showRewardedVideo{
//
//	[self.rewardedVideoAd showAdFromRootViewController:self ritScene:BURitSceneType_home_get_bonus ritSceneDescribe:nil];
//}
//- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd {
//	NSInteger positionid = [[BUDAdManager RewardedVideoId] intValue];
//	[self postAdvertisingInfo:_appletId positionid:positionid opType:1];
//}

//- (void)rewardedVideoAdWillClose:(BURewardedVideoAd *)rewardedVideoAd {
//	[demo responseHandle:FALSE id:@"123"];
//}
//- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
//     //BUD_Log(@"rewardedVideoAd video did close");
//}
//- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
//	//[demo responseHandle:TRUE id:@"123"];
//	NSInteger positionid = [[BUDAdManager RewardedVideoId] intValue];
//	[self postAdvertisingInfo:_appletId positionid:positionid opType:2];
//}

//- (void)postAdvertisingInfo:(NSInteger)appid positionid:(NSInteger)positionid opType:(NSInteger)opType {
//
//
//	NSString *url = [NSString stringWithFormat:@"%@advertising/log",apiUrl];
//	ReqPacker *req = [[ReqPacker alloc] init: url];
//	NSDictionary *parameters = @{@"appletId":[NSString stringWithFormat: @"%ld", (long)_appletId],@"adPositionId":[NSString stringWithFormat: @"%ld", (long)positionid],@"opType":[NSString stringWithFormat: @"%ld", (long)opType]};
//
//
//	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
//	NSString * bodyStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//	[req setPostStr:bodyStr];
//
//	url = [req getPostUrl];
//	AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
//	NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
//	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//	[request setHTTPBody:jsonData];
//	__weak DemoViewController *that = self;
//	NSURLSessionDataTask *dt = [manager dataTaskWithRequest:request uploadProgress: nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//		NSLog(@"请求成功：%@",responseObject);
//		if ([responseObject objectForKey:@"success"] && that) {
//			DemoViewController *ctrl = that;
//			dispatch_async(dispatch_get_main_queue(), ^(){
//				LogModel * model = [[LogModel alloc] initWithDictionary:responseObject error:nil];
//				if (model.success){
//					NSLog(@"发送成功：%ld",(long)opType);
//				}
//
//			});
//		}
//	}];
//	[dt resume];
//}
@end
