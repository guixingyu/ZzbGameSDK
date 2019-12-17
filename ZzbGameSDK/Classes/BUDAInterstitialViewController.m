//
//  BUDAInterstitialViewController.m
//  ZzbGameSDK
//
//  Created by mywl on 2019/12/11.
//

#import "BUDAInterstitialViewController.h"
#import <BUAdSDK/BUNativeExpressInterstitialAd.h>
#import "BUDNormalButton.h"
#import "BUDAdManager.h"
#import <BUAdSDK/BUSize.h>
@interface BUDAInterstitialViewController () <BUNativeExpresInterstitialAdDelegate>
@property (nonatomic, strong) BUDNormalButton *button;
@property (nonatomic, strong) BUNativeExpressInterstitialAd *interstitialAd;
@end

@implementation BUDAInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	CGSize size = [UIScreen mainScreen].bounds.size;
	self.button = [[BUDNormalButton alloc]
	 initWithFrame:CGRectMake(0, size.height*0.75, 0, 0)];
	self.button.showRefreshIncon = YES;
	[self.button setTitle:@"showInterstitial" forState:UIControlStateNormal];

	[self.button addTarget:self action:@selector(buttonTapped:)forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.button];
	
	self.interstitialAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:[BUDAdManager InterstitialId] imgSize:[BUSize sizeBy:BUProposalSize_Interstitial600_600] adSize:CGSizeMake(300, 450)];
	self.interstitialAd.delegate = self;
	[self.interstitialAd loadAdData];
	[self.interstitialAd showAdFromRootViewController:self];
}

- (void)buttonTapped:(UIButton *)sender {
	if (self.interstitialAd.isAdValid) {
		[self.interstitialAd showAdFromRootViewController:self];
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
