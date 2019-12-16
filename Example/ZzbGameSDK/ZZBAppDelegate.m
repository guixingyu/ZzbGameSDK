//
//  ZZBAppDelegate.m
//  ZzbGameSDK
//
//  Created by guixingyu on 11/21/2019.
//  Copyright (c) 2019 guixingyu. All rights reserved.
//

#import "ZZBAppDelegate.h"
#import "ZZBTabBarController.h"
#import <ZzbGameSDK/ZzbGameManager.h>
//#import <BUAdSDK/BUAdSDKManager.h>
//#import <BUAdSDK/BUSplashAdView.h>
//#import <ZzbGameSDK/BUDAdManager.h>

@interface ZZBAppDelegate ()
@property (nonatomic, assign) CFTimeInterval startTime;
@end

@implementation ZZBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	//Override point for customization after application launch.

	//配置穿山甲广告参数
	//[BUDAdManager setAppKey:@"5036707"];
	//[BUDAdManager setShowBUD:TRUE];
	//[BUDAdManager setSplashId:@"836707632"]; //开屏
	//[BUDAdManager setBannerId:@"936707077"]; //banner
	//[BUDAdManager setInterstitialId:@"936707129"]; //插屏
	//[BUDAdManager setRewardedVideoId:@"936707557"]; //激励视频
	
	//[BUAdSDKManager setAppID:BUDAdManager.appKey];
    //[BUAdSDKManager setIsPaidApp:NO];
    //[BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
	
//    CGRect frame = [UIScreen mainScreen].bounds;
//    BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:[BUDAdManager SplashId] frame:frame];
//    splashView.delegate = self;
//    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
//    [splashView loadAdData];
//    [keyWindow.rootViewController.view addSubview:splashView];
//    splashView.rootViewController = keyWindow.rootViewController;

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ZZBTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}
     
//- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
//    [splashAd removeFromSuperview];
//    [[ZzbGameManager sharedManager] setGameAppId:@"2" andAppKey:@"iU6wDkWwfudMADm4"];
//    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = [[ZZBTabBarController alloc] init];
//    [self.window makeKeyAndVisible];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZzbEnterBackground" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZzbEnterForeground" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

@end
