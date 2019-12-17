//
//  BUDABannerViewController.m
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/11.
//

#import "BUDABannerViewController.h"
#import <BUAdSDK/BUNativeExpressBannerView.h>
#import <BUAdSDK/BUSize.h>
#import "BUDAdManager.h"
#import "BUDNormalButton.h"
@interface BUDABannerViewController ()<BUNativeExpressBannerViewDelegate>
@property(nonatomic, strong) BUDNormalButton *refreshbutton;
@property(nonatomic, strong) BUNativeExpressBannerView *bannerView;
@end

@implementation BUDABannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
   CGRect screenRect = [UIScreen mainScreen].bounds;
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    sv.contentSize = CGSizeMake(screenRect.size.width, screenRect.size.height * 2);
    sv.backgroundColor = [UIColor whiteColor];
    self.view = sv;
	
	CGSize size = [UIScreen mainScreen].bounds.size;
	_refreshbutton = [[BUDNormalButton alloc] initWithFrame:CGRectMake(0, size.height *0.4, 0, 0)];
	_refreshbutton.showRefreshIncon = YES;
	[_refreshbutton setTitle:@"showBanner" forState:UIControlStateNormal];
	[_refreshbutton addTarget:self action:@selector(refreshBanner) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_refreshbutton];
	
	CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
	CGFloat bannerHeigh = screenWidth/600*90;
	BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Banner600_150];
	self.bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:[BUDAdManager BannerId] rootViewController:self imgSize:imgSize adSize:CGSizeMake(screenWidth, bannerHeigh) IsSupportDeepLink:YES interval:30];
	self.bannerView.frame = CGRectMake(0, 0, screenWidth, bannerHeigh);
	self.bannerView.delegate = self;
	[self.view addSubview:self.bannerView];
}

-  (void)refreshBanner {

    [self.bannerView loadAdData];
}

#pragma BUNativeExpressBannerViewDelegate

- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {

}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error {
	
}

- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {

}

- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError *)error {

}

- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
