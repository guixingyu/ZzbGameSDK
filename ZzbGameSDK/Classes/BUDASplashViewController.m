//
//  BUDASplashViewController.m
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/11.
//

#import "BUDASplashViewController.h"
#import <BUAdSDK/BUSplashAdView.h>
#import "BUDAdManager.h"
@interface BUDASplashViewController ()<BUSplashAdDelegate>

@end

@implementation BUDASplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
	CGRect frame = [UIScreen mainScreen].bounds;
	BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:[BUDAdManager SplashId] frame:frame];
	splashView.delegate = self;
	//UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
	[splashView loadAdData];
	[self.view addSubview:splashView];
	//splashView.rootViewController = keyWindow.rootViewController;
}


- (void)splashAdDidClick:(BUSplashAdView *)splashAd {

}

- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    [splashAd removeFromSuperview];
	if (self.hideWindow){
		self.hideWindow();
	}
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
