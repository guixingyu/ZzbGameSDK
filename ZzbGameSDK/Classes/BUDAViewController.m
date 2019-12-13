//
//  ViewController.m
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/10.
//

#import "BUDAViewController.h"
#import <BUAdSDK/BUSplashAdView.h>
#import "ZzbDefine.h"
#import "BUDASplashViewController.h"
#import "BUDABannerViewController.h"
#import "BUDAInterstitialViewController.h"
#import "BUDARewardedVideoViewController.h"
@interface BUDAViewController ()


@end

@implementation BUDAViewController{
	UIButton *btnSplash;
	UIButton *btnBanner;
	UIButton *btnInterstitial;
	UIButton *btnRewardedVideo;
}
- (void)viewDidLoad {
    [super viewDidLoad];

	btnSplash = [UIButton buttonWithType:UIButtonTypeCustom];
	btnSplash.backgroundColor = [UIColor grayColor];
	btnSplash.titleLabel.textColor = ZZBColorWithRGBA(0, 0, 0, 1);
	[btnSplash setTitle:@"开屏" forState:UIControlStateNormal];
	btnSplash.frame = ZZBCGRectMake(0, 100, 200, 50);
	[self.view addSubview:btnSplash];
	[btnSplash addTarget:self action:@selector(btnSplashClick) forControlEvents:UIControlEventTouchUpInside];
	
	btnBanner = [UIButton buttonWithType:UIButtonTypeCustom];
	btnBanner.backgroundColor = [UIColor grayColor];
	btnBanner.titleLabel.textColor = ZZBColorWithRGBA(0, 0, 0, 1);
	[btnBanner setTitle:@"BANNA" forState:UIControlStateNormal];
	btnBanner.frame = ZZBCGRectMake(0, 200, 200, 50);
	[self.view addSubview:btnBanner];
	[btnBanner addTarget:self action:@selector(btnBannerClick) forControlEvents:UIControlEventTouchUpInside];
	
	btnInterstitial = [UIButton buttonWithType:UIButtonTypeCustom];
	btnInterstitial.backgroundColor = [UIColor grayColor];
	btnInterstitial.titleLabel.textColor = ZZBColorWithRGBA(0, 0, 0, 1);
	[btnInterstitial setTitle:@"插屏" forState:UIControlStateNormal];
	btnInterstitial.frame = ZZBCGRectMake(0, 300, 200, 50);
	[self.view addSubview:btnInterstitial];
	[btnInterstitial addTarget:self action:@selector(btnInterstitialClick) forControlEvents:UIControlEventTouchUpInside];
	
	btnRewardedVideo = [UIButton buttonWithType:UIButtonTypeCustom];
	btnRewardedVideo.backgroundColor = [UIColor grayColor];
	btnRewardedVideo.titleLabel.textColor = ZZBColorWithRGBA(0, 0, 0, 1);
	[btnRewardedVideo setTitle:@"视频" forState:UIControlStateNormal];
	
	btnRewardedVideo.frame = ZZBCGRectMake(0, 400, 200, 50);
	[self.view addSubview:btnRewardedVideo];
	[btnRewardedVideo addTarget:self action:@selector(btnRewardedVideo) forControlEvents:UIControlEventTouchUpInside];

}
- (void)btnSplashClick{
	__weak BUDAViewController *that = self;
	
	BUDASplashViewController *vc = [[BUDASplashViewController alloc] init];
	vc.hideWindow = ^(){
		that.window;
		that.window.hidden = true;
		that.window = nil;
	};
//	[self.navigationController pushViewController:vc animated:YES];
	
	_window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
	_window.layer.masksToBounds = YES;

    _window.hidden=NO;
	_window.windowLevel = UIWindowLevelAlert+1;
	_window.backgroundColor = [UIColor whiteColor];
	_window.rootViewController = vc;
}
- (void)btnBannerClick{
	BUDABannerViewController  *vc = [[BUDABannerViewController alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
}
- (void)btnInterstitialClick{
	BUDAInterstitialViewController  *vc = [[BUDAInterstitialViewController alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
}
- (void)btnRewardedVideo{
	BUDARewardedVideoViewController  *vc = [[BUDARewardedVideoViewController alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
